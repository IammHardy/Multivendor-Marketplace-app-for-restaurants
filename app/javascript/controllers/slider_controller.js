import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track"]

  connect() {
    // Optionally, we can add snapping support or arrows here
  }
}
