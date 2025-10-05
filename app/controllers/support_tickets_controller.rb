class SupportTicketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tickets = current_user.support_tickets.order(created_at: :desc)
  end

  def show
    @ticket = current_user.support_tickets.find(params[:id])
  end

  def new
    @ticket = SupportTicket.new
  end

  def create
    @ticket = current_user.support_tickets.new(ticket_params)
    if @ticket.save
      redirect_to support_ticket_path(@ticket), notice: "Support ticket created successfully."
    else
      render :new
    end
  end

  private

  def ticket_params
    params.require(:support_ticket).permit(:subject, :body, :order_id)
  end
end
