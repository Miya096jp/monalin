import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["aside", "overlay"]

  open() {
    this.asideTarget.classList.remove("-translate-x-full")
    this.asideTarget.classList.add("translate-x-0")
    this.overlayTarget.classList.remove("invisible", "opacity-0")
    this.overlayTarget.classList.add("opacity-100")
  }

  close() {
    this.asideTarget.classList.remove("translate-x-0")
    this.asideTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.remove("opacity-100")
    this.overlayTarget.classList.add("invisible", "opacity-0")
  }
}
