class Vendor::ConversationsController < Vendor::BaseController
  before_action :authenticate_vendor!
  before_action :set_conversation, only: [:show]

  def index
    # Get all conversations for the current vendor
    @conversations = Conversation.where(vendor_id: current_vendor.id)
                                 .includes(:messages, :user) # eager load messages and user
                                 .order(updated_at: :desc)
  end

  def show
    # @conversation is already set in before_action
    @messages = @conversation.messages.order(:created_at)

    # Mark all user messages as read
    @messages.where(sender_type: "User").update_all(read: true)

    @new_message = Message.new
  end

  private

  def set_conversation
    @conversation = Conversation.find_by(id: params[:id], vendor_id: current_vendor.id)
    unless @conversation
      redirect_to vendor_conversations_path, alert: "Conversation not found."
    end
  end
end
