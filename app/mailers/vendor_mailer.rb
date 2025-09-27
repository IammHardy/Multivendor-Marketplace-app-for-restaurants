# app/mailers/vendor_mailer.rb
class VendorMailer < ApplicationMailer
    default from: "no-reply@yourapp.com"
  # Sent immediately after vendor registers

  # Notify admin when a new vendor signs up
  def new_vendor_notification
    @vendor = params[:vendor]
    mail(
      to: "abdulhadiyusuf842@gmail.com", # replace with your real admin email or ENV var
      subject: "New Vendor Registration: #{@vendor.name}"
    )
  end
  def pending_approval_email
    @vendor = params[:vendor]
    mail(
      to: @vendor.email,
      subject: "Your vendor application is under review"
    )
  end
  def approved_email
    @vendor = params[:vendor]
    mail(to: @vendor.email, subject: "Your Vendor Account has been Approved!")
  end

  def rejected_email
    @vendor = params[:vendor]
    mail(to: @vendor.email, subject: "Your Vendor Account has been Rejected")
  end
end
