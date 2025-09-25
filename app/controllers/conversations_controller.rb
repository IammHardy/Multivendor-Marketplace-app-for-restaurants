class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Show all conversations for the current user
    # Show all conversations for this user
    @conversations = current_user.conversations.includes(:messages, :vendor)
  end

  def show
     @conversation = current_user.conversations.find(params[:id])
    @messages = @conversation.messages.order(:created_at)
    @message = Message.new
  end

  def create
    @vendor = Vendor.find(params[:vendor_id])
    # Check if conversation already exists
    @conversation = Conversation.find_or_create_by!(
      customer_id: current_user.id,
      vendor_id: @vendor.id
    )

    redirect_to conversation_path(@conversation)
  end
end
