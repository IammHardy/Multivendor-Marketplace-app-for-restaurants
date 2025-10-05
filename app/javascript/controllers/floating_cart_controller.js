import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.button = this.element.querySelector("#cart-toggle")
    this.dropdown = this.element.querySelector("#cart-dropdown")

    if (this.button) {
      this.button.addEventListener("click", () => {
        this.dropdown.classList.toggle("hidden")
      })
    }
  }
}
