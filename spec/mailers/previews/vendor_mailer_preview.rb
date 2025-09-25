class VendorMailer < ApplicationMailer
  default from: "no-reply@yourapp.com"

  def approval_email
    @vendor = params[:vendor]
    @dashboard_url = vendor_dashboard_url
    mail(to: @vendor.email, subject: "Your Vendor Account Has Been Approved!")
  end
end
