import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review-stars"
export default class extends Controller {
  static targets = ["input", "star"]

  connect() {
    this.currentRating = parseInt(this.inputTarget.value) || 0
    this.updateStars()
  }

  // Click a star
  setRating(event) {
    const value = parseInt(event.currentTarget.dataset.value)
    this.inputTarget.value = value
    this.currentRating = value
    this.updateStars()
  }

  // Hover over a star
  hoverStar(event) {
    const value = parseInt(event.currentTarget.dataset.value)
    this.stars.forEach((star, index) => {
      star.classList.toggle("text-yellow-400", index < value)
      star.classList.toggle("text-gray-300", index >= value)
    })
  }

  // Reset to selected rating when mouse leaves
  resetStars() {
    this.updateStars()
  }

  // Update visual stars based on currentRating
  updateStars() {
    this.stars.forEach((star, index) => {
      if (index < this.currentRating) {
        star.classList.add("text-yellow-400")
        star.classList.remove("text-gray-300")
      } else {
        star.classList.add("text-gray-300")
        star.classList.remove("text-yellow-400")
      }
    })
  }

  get stars() {
    return this.starTargets
  }
}
