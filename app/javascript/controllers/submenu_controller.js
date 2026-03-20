import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]

  toggle() {
    this.listTarget.classList.toggle("hidden")
  }

  close(e) {
    if (!this.element.contains(e.target)) {
      this.listTarget.classList.add("hidden")
    }
  }
}
