class Users::ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
  @conversations = Conversation.where(user_id: current_user.id).order(updated_at: :desc)
end

def show
  @conversation = Conversation.find_by(id: params[:id], user_id: current_user.id)
  unless @conversation
    redirect_to users_conversations_path, alert: "Conversation not found."
    return
  end
  @messages = @conversation.messages.order(created_at: :asc)
  @new_message = Message.new
end




 def start
  vendor = Vendor.find(params[:vendor_id])

  conversation = Conversation.find_or_create_by(
    user_id: current_user.id,
    vendor_id: vendor.id
  )

  redirect_to users_conversation_path(conversation)
end
end
