// app/javascript/controllers/vendor_signup_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "step", "progress", "submitButton",
    "email", "emailError",
    "profileImage", "profilePreview",
    "bannerImage", "bannerPreview",
    "idCard", "idPreview",
    "prevBtn", "nextBtn"
  ]

  connect() {
    this.currentStep = 0
    this.showStep(this.currentStep)
    this.emailAvailable = true
    console.log("Vendor Signup controller connected!")
  }

showStep(index) {
  this.stepTargets.forEach((step, i) => {
    const inputs = step.querySelectorAll("input, select, textarea")
    if (i === index) {
      step.classList.remove("hidden", "opacity-0")
      step.classList.add("opacity-100")
      inputs.forEach(input => input.required = true) // only current step required
    } else {
      step.classList.add("opacity-0")
      setTimeout(() => step.classList.add("hidden"), 500)
      inputs.forEach(input => input.required = false) // hidden step not required
    }
  })

  // update progress bar
  this.progressTargets.forEach((prog, i) => {
    if (i <= index) {
      prog.classList.add("bg-indigo-600", "text-white")
      prog.classList.remove("bg-gray-300", "text-gray-600")
    } else {
      prog.classList.add("bg-gray-300", "text-gray-600")
      prog.classList.remove("bg-indigo-600", "text-white")
    }
  })

  // show/hide submit button
  this.submitButtonTarget.classList.toggle("hidden", index !== this.stepTargets.length - 1)
  this.nextBtnTarget.classList.toggle("hidden", index === this.stepTargets.length - 1)
  this.prevBtnTarget.classList.toggle("hidden", index === 0)
}



  nextStep(event) {
    event.preventDefault()
    if (!this.validateStep(this.currentStep)) return
    if (this.currentStep < this.stepTargets.length - 1) {
      this.currentStep++
      this.showStep(this.currentStep)
    }
  }

  prevStep(event) {
    event.preventDefault()
    if (this.currentStep > 0) {
      this.currentStep--
      this.showStep(this.currentStep)
    }
  }

  validateStep(index) {
    const step = this.stepTargets[index]
    let valid = true
    step.querySelectorAll("input[required], select[required], textarea[required]").forEach(input => {
      if (!input.value.trim()) {
        input.classList.add("border-red-500")
        valid = false
      } else {
        input.classList.remove("border-red-500")
      }
    })
    return valid
  }

  checkEmail() {
    const email = this.emailTarget.value.trim()
    if (!email) return
    fetch(`/vendors/check_email?email=${encodeURIComponent(email)}`)
      .then(res => res.json())
      .then(data => {
        if (data.exists) {
          this.emailErrorTarget.textContent = "Email already in use"
          this.emailTarget.classList.add("border-red-500")
          this.emailAvailable = false
        } else {
          this.emailErrorTarget.textContent = ""
          this.emailTarget.classList.remove("border-red-500")
          this.emailAvailable = true
        }
      })
  }

  previewFile(event) {
    const input = event.target
    const previewTargetName = input.dataset.previewTarget
    const preview = this[previewTargetName + "Target"]
    if (input.files && input.files[0]) {
      const reader = new FileReader()
      reader.onload = e => preview.src = e.target.result
      reader.readAsDataURL(input.files[0])
      preview.classList.remove("hidden")
    }
  }
}
