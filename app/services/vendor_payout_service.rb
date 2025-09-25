# app/services/vendor_payout_service.rb
class VendorPayoutService
  Result = Struct.new(:success?, :amount, :details, :error_message)

  def initialize(vendor:, initiated_by: nil)
    @vendor = vendor
    @initiated_by = initiated_by
  end

  # mode: :simulate or :paystack
  def pay_all_pending!(mode: :simulate)
    pending = @vendor.vendor_earnings.pending.to_a
    return Result.new(false, 0, nil, "No pending earnings") if pending.empty?

    total_amount = pending.sum { |e| e.amount.to_d }

    ActiveRecord::Base.transaction do
      if mode == :simulate
        paid_time = Time.current
        pending.each { |e| e.mark_paid!(paid_time) }
        return Result.new(true, total_amount, { vendor_id: @vendor.id, count: pending.size }, nil)
      end

      if mode == :paystack
        paystack_response = paystack_transfer_to_vendor(total_amount)
        if paystack_response[:success]
          paid_time = Time.current
          pending.each { |e| e.mark_paid!(paid_time) }
          return Result.new(true, total_amount, paystack_response[:data], nil)
        else
          raise ActiveRecord::Rollback
        end
      end

      Result.new(false, total_amount, nil, "Unknown payout mode")
    end
  rescue => ex
    Result.new(false, 0, nil, ex.message)
  end

  private

  def paystack_transfer_to_vendor(amount)
    api_key = ENV["PAYSTACK_SECRET_KEY"]
    return { success: false, error: "PAYSTACK_SECRET_KEY not set" } if api_key.blank?

    recipient_code = ensure_transfer_recipient(api_key)
    return { success: false, error: "Could not create recipient" } if recipient_code.blank?

    require "net/http"
    require "uri"
    require "json"

    uri = URI.parse("https://api.paystack.co/transfer")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, {
      "Authorization" => "Bearer #{api_key}",
      "Content-Type" => "application/json"
    })

    req.body = {
      source: "balance",
      amount: (amount.to_d * 100).to_i, # Paystack expects kobo
      recipient: recipient_code,
      reason: "Vendor payout for #{@vendor.id}"
    }.to_json

    resp = http.request(req)
    parsed = JSON.parse(resp.body) rescue { "status" => false, "message" => "Invalid response" }

    if parsed["status"]
      { success: true, data: parsed }
    else
      { success: false, error: parsed["message"] || parsed }
    end
  end

  def ensure_transfer_recipient(api_key)
    return @vendor.transfer_recipient_code if @vendor.transfer_recipient_code.present?

    body = {
      type: "nuban",
      name: @vendor.account_name || @vendor.name,
      account_number: @vendor.account_number,
      bank_code: bank_code_for(@vendor.bank_name),
      currency: "NGN"
    }

    uri = URI.parse("https://api.paystack.co/transferrecipient")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, {
      "Authorization" => "Bearer #{api_key}",
      "Content-Type" => "application/json"
    })
    req.body = body.to_json
    resp = http.request(req)
    parsed = JSON.parse(resp.body) rescue {}

    if parsed["status"] && parsed.dig("data", "recipient_code")
      recipient = parsed["data"]["recipient_code"]
      @vendor.update_column(:transfer_recipient_code, recipient)

      return recipient
    end

    nil
  end

  def bank_code_for(bank_name)
    mapping = {
      "Access Bank" => "044",
      "GTBank" => "058",
      "Zenith Bank" => "057",
      "First Bank" => "011"
      # Add more banks as needed
    }
    mapping[bank_name] || bank_name
  end
end
