import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages"]

  connect() {
    this.scrollToBottom()
  }

  scrollToBottom() {
    const messages = this.messagesTarget
    messages.scrollTop = messages.scrollHeight
  }

  // Called after Turbo appends a new message
  messageAdded() {
    this.scrollToBottom()
  }
}
