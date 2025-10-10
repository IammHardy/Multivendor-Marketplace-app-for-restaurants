import consumer from "./consumer"

const riderId = 1; // from order.rider_id
const channel = consumer.subscriptions.create(
  { channel: "RiderLocationChannel", rider_id: riderId },
  {
    received(data) {
      console.log("Rider location updated:", data);
      // Update map marker here
    }
  }
)
