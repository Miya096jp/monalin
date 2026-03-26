import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  async send(e) {
    e.preventDefault()
    if (this.inputTarget.value.trim() === "") return

    const body = this.inputTarget.value

    const formData = new FormData()
    formData.append("message[body]", body)

    const response = await fetch(this.element.action, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      }
    })

    if (response.ok) {
      const location = response.headers.get("Location")
      if (location) {
        window.location.href = location
      } else {
        this.appendMessage(body)
      }
    }
    this.inputTarget.value = ""
  }

  appendMessage(body) {
    const container = document.getElementById("chat")
    const outer = document.createElement("div")
    outer.className = "user-message flex justify-end"
    const inner = document.createElement("div")
    inner.className = "bg-chat rounded-lg p-4 max-w-xs"
    const p = document.createElement("p")
    p.textContent = body

    inner.appendChild(p)
    outer.appendChild(inner)
    container.appendChild(outer)
    outer.scrollIntoView({ behavior: "smooth" })
  }
}
