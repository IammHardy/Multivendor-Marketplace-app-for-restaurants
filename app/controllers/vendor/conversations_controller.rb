class Vendor::ConversationsController < Vendor::BaseController
  before_action :authenticate_vendor!
  before_action :set_conversation, only: [:show]

  def index
    @conversations = ConversationService.for_vendor(current_vendor).order(updated_at: :desc)
  end

  def show
    @messages = @conversation.messages.order(:created_at)
    @new_message = Message.new

    # Mark user messages as read
    @messages.where(sender_type: "User").update_all(read: true)
  end

  private

  def set_conversation
    @conversation = ConversationService.find_for_vendor(current_vendor, params[:id])
    redirect_to vendor_conversations_path, alert: "Conversation not found." unless @conversation
  end
end
