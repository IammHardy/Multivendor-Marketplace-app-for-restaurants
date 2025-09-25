# Pin npm packages by running ./bin/importmap
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin_all_from "app/javascript/controllers", under: "controllers"


pin "application"
pin "chartkick" # @5.0.1
pin "chart.js" # @4.5.0
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.4
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
