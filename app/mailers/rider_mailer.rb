class RiderMailer < ApplicationMailer
  default from: "no-reply@yourapp.com"

  def registration_complete
    @rider = params[:rider]
    mail(
      to: @rider.email,
      subject: "Welcome #{@rider.name}! Your registration is complete"
    )
  end

  def new_rider_notification
    @rider = params[:rider]
    mail(
      to: "abdulhadiyusuf842@gmail.com", # admin email
      subject: "New Rider Registration: #{@rider.name}"
    )
  end

  def account_approved
    @rider = params[:rider]
    mail(
      to: @rider.email,
      subject: "Your Rider Account Has Been Approved!"
    )
  end

  def account_rejected
    @rider = params[:rider]
    mail(
      to: @rider.email,
      subject: "Your Rider Application Has Been Rejected"
    )
  end

  def account_verified
    @rider = params[:rider]
    mail(to: @rider.email, subject: "Your Rider Account Has Been Verified")
  end
   # <-- Add this method
  def account_unverified
    @rider = params[:rider]
    mail(to: @rider.email, subject: "Your Rider Account Has Been Unverified")
  end
end
