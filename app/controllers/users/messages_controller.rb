class Users::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.sender = current_user
    @message.recipient = @conversation.vendor # polymorphic recipient (Vendor)

    if @message.save
      redirect_to users_conversation_path(@conversation), notice: "Message sent."
    else
      redirect_to users_conversation_path(@conversation), alert: "Failed to send message."
    end
  end

  private

  def set_conversation
  @conversation = Conversation.find_by(id: params[:conversation_id], user_id: current_user.id)
  unless @conversation
    redirect_to users_conversations_path, alert: "Conversation not found."
  end
end


  def message_params
    params.require(:message).permit(:body)
  end
end
