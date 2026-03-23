import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  send(e) {
    e.preventDefault()
    if (this.inputTarget.value.trim() === "") return

    const formData = new FormData()
    formData.append("message[body]", this.inputTarget.value)

    fetch(this.element.action, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      }
    })

    this.inputTarget.value = ""
  }
}
