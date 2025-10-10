// app/javascript/controllers/menu_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  toggle() {
    const menu = this.menuTarget
    const icon = this.buttonTarget.querySelector("i")

    menu.classList.toggle("hidden")

    if (!menu.classList.contains("hidden")) {
      menu.classList.remove("-translate-y-5", "opacity-0")
      menu.classList.add("translate-y-0", "opacity-100")
      icon.classList.replace("fa-bars", "fa-times")
    } else {
      menu.classList.add("-translate-y-5", "opacity-0")
      menu.classList.remove("translate-y-0", "opacity-100")
      icon.classList.replace("fa-times", "fa-bars")
    }
  }
}
