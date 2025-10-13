import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.hideTimeout = null
    document.addEventListener("click", this.closeOnClickOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnClickOutside.bind(this))
  }

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }

  show() {
    if (window.innerWidth >= 1024) {
      clearTimeout(this.hideTimeout)
      this.menuTarget.classList.remove("hidden")
    }
  }

  hide() {
    if (window.innerWidth >= 1024) {
      // Add a small delay before hiding (so user can move cursor to dropdown)
      this.hideTimeout = setTimeout(() => {
        this.menuTarget.classList.add("hidden")
      }, 200) // 200ms = sweet spot
    }
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
