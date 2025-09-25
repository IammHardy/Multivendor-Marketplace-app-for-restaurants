import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nav", "button"]

  connect() {
    console.log("Menu controller connected!")
  }

  toggle() {
    const nav = this.navTarget
    const icon = this.buttonTarget.querySelector("i")

    nav.classList.toggle("hidden")

    if (!nav.classList.contains("hidden")) {
      nav.classList.remove("-translate-y-5", "opacity-0")
      nav.classList.add("translate-y-0", "opacity-100")
      icon.classList.remove("fa-bars")
      icon.classList.add("fa-times")
    } else {
      nav.classList.add("-translate-y-5", "opacity-0")
      nav.classList.remove("translate-y-0", "opacity-100")
      icon.classList.remove("fa-times")
      icon.classList.add("fa-bars")
    }
  }
}
