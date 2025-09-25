class Vendor::MessagesController < Vendor::BaseController
  before_action :authenticate_vendor!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.sender = current_vendor
    @message.recipient = @conversation.user # polymorphic recipient
    if @message.save
      redirect_to vendor_conversation_path(@conversation), notice: "Message sent."
    else
      redirect_to vendor_conversation_path(@conversation), alert: "Failed to send message."
    end
  end

  private

  def set_conversation
    # Use vendor_id instead of current_user
    @conversation = Conversation.find_by(id: params[:conversation_id], vendor_id: current_vendor.id)
    unless @conversation
      redirect_to vendor_conversations_path, alert: "Conversation not found."
    end
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
