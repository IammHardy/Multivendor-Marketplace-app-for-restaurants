// app/javascript/controllers/landing_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.animateCounters()
    this.animateVendors()
    this.animateHowItWorks()
    this.animateTestimonials()
    this.animatePromotions()
    this.animateFaq()
    this.animateTrustCards()
  }

  // ========== COUNTERS ==========
  animateCounters() {
    const counters = [
      { id: "happy-customers", target: 2000 },
      { id: "vendors-count", target: 5 },
      { id: "orders-delivered", target: 1000 }
    ]

    const heroSection = document.getElementById("hero-section")
    if (!heroSection) return

    const observer = new IntersectionObserver(entries => {
      if (entries[0].isIntersecting) {
        counters.forEach(c => {
          const el = document.getElementById(c.id)
          if (el) this.runCounter(el, c.target)
        })
        observer.disconnect()
      }
    }, { threshold: 0.5 })

    observer.observe(heroSection)
  }

  runCounter(el, target) {
    let current = 0
    const duration = 2000
    const increment = target / (duration / 16)

    const timer = setInterval(() => {
      current += increment
      if (current >= target) {
        current = target
        clearInterval(timer)
      }
      el.textContent = Math.floor(current).toLocaleString() + "+"
    }, 16)
  }

  // ========== VENDORS ==========
  animateVendors() {
    const vendorSection = document.getElementById("top-vendors")
    if (!vendorSection) return

    const vendorTitle = document.getElementById("vendors-title")
    const vendorCards = vendorSection.querySelectorAll(".vendor-card")

    const observer = new IntersectionObserver(entries => {
      if (entries[0].isIntersecting) {
        vendorTitle?.classList.remove("opacity-0", "translate-y-4")
        vendorCards.forEach((card, i) =>
          setTimeout(() => card.classList.remove("opacity-0", "translate-y-6"), i * 100)
        )
        observer.disconnect()
      }
    }, { threshold: 0.2 })

    observer.observe(vendorSection)
  }

  // ========== HOW IT WORKS ==========
  animateHowItWorks() {
    const section = document.getElementById("how-it-works")
    if (!section) return

    const title = document.getElementById("how-title")
    const steps = section.querySelectorAll(".how-step")

    const observer = new IntersectionObserver(entries => {
      if (entries[0].isIntersecting) {
        title?.classList.remove("opacity-0", "translate-y-4")
        steps.forEach((s, i) => {
          setTimeout(() => s.classList.remove("opacity-0", "translate-y-6"), i * 150)
        })
        observer.disconnect()
      }
    }, { threshold: 0.2 })

    observer.observe(section)
  }

  // ========== TESTIMONIALS ==========
  animateTestimonials() {
    const title = document.querySelector('#testimonials h2')
    const cards = document.querySelectorAll(".testimonial-card")
    if (!title || !cards.length) return

    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.remove("opacity-0", "translate-y-6", "translate-y-4")
          entry.target.classList.add("opacity-100", "translate-y-0")
          observer.unobserve(entry.target)
        }
      })
    }, { threshold: 0.2 })

    observer.observe(title)
    cards.forEach(card => observer.observe(card))
  }

  // ========== PROMOTIONS ==========
  animatePromotions() {
    const title = document.querySelector('#promotions h2')
    const cards = document.querySelectorAll(".promo-card")
    if (!title || !cards.length) return

    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.remove("opacity-0", "translate-y-6", "translate-y-4")
          entry.target.classList.add("opacity-100", "translate-y-0")
          observer.unobserve(entry.target)
        }
      })
    }, { threshold: 0.2 })

    observer.observe(title)
    cards.forEach(card => observer.observe(card))
  }

  // ========== FAQ ==========
  animateFaq() {
    const section = document.getElementById("faq")
    if (!section) return

    const items = section.querySelectorAll("details")

    // Set initial hidden state
    items.forEach(item => item.classList.add("opacity-0", "translate-y-4"))

    const observer = new IntersectionObserver(entries => {
      if (entries[0].isIntersecting) {
        items.forEach((item, i) => {
          item.classList.add("opacity-100", "translate-y-0")
          item.classList.remove("opacity-0", "translate-y-4")
        })
        observer.disconnect()
      }
    }, { threshold: 0.2 })

    observer.observe(section)
  }

  // ========== TRUST CARDS ==========
  animateTrustCards() {
    const cards = document.querySelectorAll(".trust-card")
    if (!cards.length) return

    const observer = new IntersectionObserver(entries => {
      entries.forEach((entry, i) => {
        if (entry.isIntersecting) {
          setTimeout(() => {
            entry.target.classList.add("opacity-100", "translate-y-0")
            entry.target.classList.remove("opacity-0", "translate-y-4")
          }, i * 150)
          observer.unobserve(entry.target)
        }
      })
    }, { threshold: 0.2 })

    cards.forEach(card => observer.observe(card))
  }
}
