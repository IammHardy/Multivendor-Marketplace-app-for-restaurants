class Users::ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = ConversationService.for_user(current_user).order(updated_at: :desc)
  end

  def show
    @conversation = ConversationService.find_for_user(current_user, params[:id])
    return redirect_to users_conversations_path, alert: "Conversation not found." unless @conversation

    @messages = @conversation.messages.order(:created_at)
    @new_message = Message.new

    # Mark vendor messages as read
    @messages.where(sender_type: "Vendor").update_all(read: true)
  end

  def start
    vendor = Vendor.find(params[:vendor_id])
    conversation = Conversation.find_or_create_by(user_id: current_user.id, vendor_id: vendor.id)
    redirect_to users_conversation_path(conversation)
  end
end
