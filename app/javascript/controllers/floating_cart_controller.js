// app/javascript/controllers/floating_cart_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cartFrame", "items", "badge"]

  connect() {
    console.log("✅ Floating cart connected")
    this._onFrameLoad = this._onFrameLoad.bind(this)
    this._reconnect = this._reconnect.bind(this)

    document.addEventListener("turbo:frame-load", this._onFrameLoad)
    document.addEventListener("turbo:render", this._reconnect)
  }

  disconnect() {
    document.removeEventListener("turbo:frame-load", this._onFrameLoad)
    document.removeEventListener("turbo:render", this._reconnect)
  }

  toggleCart(event) {
    if (event) event.preventDefault()
    const frame = this.cartFrameElement
    frame.classList.toggle("translate-x-full")
    frame.classList.toggle("translate-x-0")
  }

  showCart() {
    const frame = this.cartFrameElement
    frame.classList.remove("translate-x-full")
    frame.classList.add("translate-x-0")
  }

  hideCart() {
    const frame = this.cartFrameElement
    frame.classList.add("translate-x-full")
    frame.classList.remove("translate-x-0")
  }

  get cartFrameElement() {
    return this.hasCartFrameTarget ? this.cartFrameTarget : document.getElementById("floating-cart")
  }

  _onFrameLoad(event) {
    if (event.target.id === "floating-cart-items") {
      this.updateBadge()
    }
  }

  _reconnect() {
    const button = document.getElementById("floating-cart-button")
    if (button && !button.dataset.action?.includes("click->floating-cart#toggleCart")) {
      button.dataset.action = "click->floating-cart#toggleCart"
    }
    this.updateBadge()
  }

  updateBadge() {
    if (!this.hasBadgeTarget || !this.hasItemsTarget) return

    const total = parseInt(this.itemsTarget.dataset.totalItems || 0)
    if (total > 0) {
      this.badgeTarget.textContent = total
      this.badgeTarget.classList.remove("hidden")
    } else {
      this.badgeTarget.textContent = 0
      this.badgeTarget.classList.add("hidden")
      this.hideCart()
    }
  }
}
