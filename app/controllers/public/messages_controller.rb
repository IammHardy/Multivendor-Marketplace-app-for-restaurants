class Public::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.sender = current_user
    @message.recipient = @conversation.vendor

    if @message.save
      # Send email notification to vendor
      if @message.sender_type == "User"
      VendorMailer.with(message: @message).new_message_notification.deliver_now

      end

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            "messages",
            partial: "messages/message",
            locals: { message: @message }
          )
        end
        format.html { redirect_to conversation_path(@conversation), notice: "Message sent." }
      end
    else
      redirect_to conversation_path(@conversation), alert: "Failed to send message."
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
