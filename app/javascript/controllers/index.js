// app/javascript/controllers/index.js
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Explicit imports (ESBuild-compatible)
import MenuController from "./menu_controller.js"
import ModalController from "./modal_controller.js"
import ReviewStarsController from "./review_stars_controller.js"
import QuantityController from "./quantity_controller.js"
import ScrollController from "./scroll_controller.js"
import VendorSignupController from "./vendor_signup_controller.js"
import LandingController from "./landing_controller.js"
import FloatingCartController from "./floating_cart_controller.js"
import DropdownController from "./dropdown_controller.js"

// Register DropdownController separately to avoid conflicts
application.register("dropdown", DropdownController)

// Register FloatingCartController separately to ensure it works globally
application.register("floating-cart", FloatingCartController)

// Register them
application.register("menu", MenuController)
application.register("modal", ModalController)
application.register("review-stars", ReviewStarsController)
application.register("quantity", QuantityController)
application.register("scroll", ScrollController)
application.register("vendor-signup", VendorSignupController)
application.register("landing", LandingController)

console.log("✅ Stimulus initialized with ESBuild")
