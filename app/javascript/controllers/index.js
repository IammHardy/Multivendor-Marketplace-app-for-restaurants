import { Application } from "@hotwired/stimulus"

const application = Application.start()

// ✅ Explicit imports (ESBuild-compatible)
import MenuController from "./menu_controller.js"
application.register("menu", MenuController)

// Add more controllers manually here if needed
// import ModalController from "./modal_controller.js"
// application.register("modal", ModalController)

// Optional debug
console.log("✅ Stimulus initialized")

export { application }
