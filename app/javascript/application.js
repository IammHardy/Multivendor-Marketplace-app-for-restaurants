import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-loading"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
import "../vendor_image_preview"
import "chartkick"
import "chartkick/chart.js"
// app/javascript/application.js


import Chart from "chart.js/auto" // Ensure Chart.js is imported
window.Chart = Chart // Make Chart.js globally available

import "./controllers"
import "./channels"


  document.addEventListener("turbo:submit-end", (event) => {
    if (event.target.closest("#new_message_form")) {
      event.target.reset()
      const messages = document.getElementById("messages")
      messages.scrollTop = messages.scrollHeight
    }
  })

