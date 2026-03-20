import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]

  show() {
    this.listTarget.classList.remove("hidden")
  }

  hide() {
    this.listTarget.classList.add("hidden")
  }

  close(e) {
    if (!this.element.contains(e.target)) {
      this.listTarget.classList.add("hidden")
    }
  }
}
