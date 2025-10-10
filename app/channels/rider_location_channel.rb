class RiderLocationChannel < ApplicationCable::Channel
  def subscribed
    # Stream for a specific rider
    rider = Rider.find(params[:rider_id])
    stream_for rider
  end

  def unsubscribed
    # Cleanup when channel is closed
  end
end
