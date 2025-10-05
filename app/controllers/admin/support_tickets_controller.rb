class Admin::SupportTicketsController < Admin::BaseController
  before_action :set_ticket, only: [:show, :update]

  # List all tickets
  def index
    @tickets = SupportTicket.order(created_at: :desc)
  end

  # Show a specific ticket
  def show
    # Optional: load ticket messages or comments if you implement them
  end

  # Respond to or update ticket (e.g., mark as closed)
  # app/controllers/admin/support_tickets_controller.rb
def update
  if @ticket.update(ticket_params)
    if params[:response_message].present?
      # Send email to user
      SupportTicketMailer.ticket_response(@ticket.user, @ticket, params[:response_message]).deliver_later
    end
    redirect_to admin_support_ticket_path(@ticket), notice: "Ticket updated successfully."
  else
    flash.now[:alert] = "Failed to update ticket."
    render :show
  end
end


  private

  def set_ticket
    @ticket = SupportTicket.find(params[:id])
  end

  def ticket_params
    params.require(:support_ticket).permit(:body, :status)
  end
end
