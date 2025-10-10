
import "@hotwired/turbo-rails"
import "./controllers" // ✅ loads all Stimulus controllers

// --- Charts ---
import "chartkick"
import "chart.js/auto"
import Chart from "chart.js/auto"
window.Chart = Chart

// --- Leaflet (Maps) ---
import L from "leaflet"
window.L = L

// --- Other scripts ---
import "./channels"
import "./order_tracking"

// --- Chat form auto-reset ---
document.addEventListener("turbo:submit-end", (event) => {
  if (event.target.closest("#new_message_form")) {
    event.target.reset()
    const messages = document.getElementById("messages")
    if (messages) messages.scrollTop = messages.scrollHeight
  }
})
