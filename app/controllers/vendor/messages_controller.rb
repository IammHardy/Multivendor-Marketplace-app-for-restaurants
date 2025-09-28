class Vendor::MessagesController < Vendor::BaseController
  before_action :authenticate_vendor!
  before_action :set_conversation

  def create
  @message = @conversation.messages.build(message_params)
  @message.sender = current_vendor
  @message.recipient = @conversation.user

  if @message.save
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(
          "messages", 
          partial: "messages/message", 
          locals: { message: @message }
        )
      end
      format.html { redirect_to vendor_conversation_path(@conversation) }
    end
  else
    head :unprocessable_entity
  end
end



  private

  def set_conversation
    @conversation = Conversation.find_by(id: params[:conversation_id], vendor_id: current_vendor.id)
    redirect_to vendor_conversations_path, alert: "Conversation not found." unless @conversation
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
