class CustomerMailer < ApplicationMailer
  default from: "no-reply@yourapp.com"

  def new_message_notification
    @message = params[:message]
    @customer = @message.recipient
    @vendor = @message.sender

    mail(
      to: @customer.email,
      subject: "New reply from #{@vendor.name} regarding Order ##{@message.order&.id || 'N/A'}"
    )
  end
end
