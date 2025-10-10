import { Turbo } from "@hotwired/turbo-rails"
import consumer from "./consumer"

document.querySelectorAll('[data-turbo-stream-from]').forEach(element => {
  const conversationId = element.dataset.turboStreamFrom.split(":").pop()
  consumer.subscriptions.create(
    { channel: "ConversationChannel", conversation_id: conversationId },
    {
      received(data) {
        // Turbo handles inserting the stream automatically
      }
    }
  )
})
import "./orders_channel"
import "./rider_location_channel"
import "./order_status_channel"
