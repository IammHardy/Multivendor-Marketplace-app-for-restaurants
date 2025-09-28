class ConversationService
  def self.for_user(user)
    Conversation.where(user_id: user.id).includes(:messages, :vendor)
  end

  def self.for_vendor(vendor)
    Conversation.where(vendor_id: vendor.id).includes(:messages, :user)
  end

  def self.find_for_user(user, id)
    Conversation.find_by(id: id, user_id: user.id)
  end

  def self.find_for_vendor(vendor, id)
    Conversation.find_by(id: id, vendor_id: vendor.id)
  end
end
