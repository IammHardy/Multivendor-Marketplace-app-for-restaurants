import consumer from "./consumer"

const conversationId = document.getElementById("conversation").dataset.id

const channel = consumer.subscriptions.create(
  { channel: "ConversationChannel", conversation_id: conversationId },
  {
    received(data) {
      if (data.typing) {
        document.getElementById("typing-indicator").innerText = "Typing..."
      } else {
        document.getElementById("typing-indicator").innerText = ""
      }
    }
  }
)

document.getElementById("message_body").addEventListener("input", () => {
  channel.perform("typing", {})
  clearTimeout(window.typingTimeout)
  window.typingTimeout = setTimeout(() => channel.perform("stop_typing", {}), 2000)
})
