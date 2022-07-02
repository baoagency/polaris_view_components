# Use direct uploads for Active Storage (remember to import "@rails/activestorage" in your application.js)
pin "@rails/activestorage", to: "activestorage.esm.js"

# Use npm packages from a JavaScript CDN by running ./bin/importmap

pin "application"
pin "@hotwired/stimulus", to: "stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "polaris-view-components", to: "polaris_view_components.js"
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.6
