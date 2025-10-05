# app/mailers/support_ticket_mailer.rb
class SupportTicketMailer < ApplicationMailer
  default from: "support@yourapp.com"

  def ticket_response(user, ticket, message)
    @user = user
    @ticket = ticket
    @message = message
    mail(to: @user.email, subject: "Response to your support ticket: #{@ticket.subject}")
  end
end
