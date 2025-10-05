class Vendor::MessagesController < Vendor::BaseController
  before_action :authenticate_vendor!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.sender = current_vendor
    @message.recipient = @conversation.user

    if @message.save
      # Optional: Notify customer via email
      CustomerMailer.with(message: @message).new_message_notification.deliver_later

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            "messages",
            partial: "messages/message",
            locals: { message: @message }
          )
        end
        format.html { redirect_to vendor_conversation_path(@conversation), notice: "Message sent." }
      end
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
