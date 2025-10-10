import { Controller } from "@hotwired/stimulus"


export default class extends Controller {

   connect() {
    console.log("✅ Stimulus controller connected!")
  }
  static targets = ["input", "submit"]

  increase() {
    let value = parseInt(this.inputTarget.value) || 1
    this.inputTarget.value = value + 1
    this.updateButton()
  }

  decrease() {
    let value = parseInt(this.inputTarget.value) || 1
    if (value > 1) {
      this.inputTarget.value = value - 1
      this.updateButton()
    }
  }

  updateButton() {
  if (this.hasSubmitTarget) {
    this.submitTarget.form.querySelector("input[name='quantity']").value = this.inputTarget.value
    this.submitTarget.click() // ✅ triggers the form submission
  }
}

}
