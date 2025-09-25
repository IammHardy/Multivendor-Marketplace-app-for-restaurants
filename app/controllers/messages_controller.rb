class Vendor::MessagesController < Vendor::BaseController
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.sender = current_vendor # ✅ use polymorphic sender

    if @message.save
      redirect_to vendor_conversation_path(@conversation), notice: "Message sent."
    else
      redirect_to vendor_conversation_path(@conversation), alert: "Failed to send message."
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
