class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_for Conversation.find(params[:conversation_id])
  end

  def typing(data)
    ConversationChannel.broadcast_to(
      Conversation.find(params[:conversation_id]),
      { typing: true, sender: current_user&.id || current_vendor&.id }
    )
  end

  def stop_typing(data)
    ConversationChannel.broadcast_to(
      Conversation.find(params[:conversation_id]),
      { typing: false, sender: current_user&.id || current_vendor&.id }
    )
  end
end
