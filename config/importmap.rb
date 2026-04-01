# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "dexie", to: "https://cdn.jsdelivr.net/npm/dexie@4.0.11/dist/dexie.mjs"
pin "process" # @2.1.0
pin "lib/database", to: "lib/database.js"
