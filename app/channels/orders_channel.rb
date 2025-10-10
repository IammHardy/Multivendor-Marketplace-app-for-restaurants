class OrdersChannel < ApplicationCable::Channel
  def subscribed
    # Stream orders for this rider
    stream_for current_rider
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
