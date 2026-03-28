import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["screen", "video", "rec"]

  open() {
    this.screenTarget.classList.remove("hidden")
    this.startCamera()
  }

  async startCamera() {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: false, video: true })
      this.videoTarget.srcObject = stream
      await this.videoTarget.play()
    } catch (e) {
      console.warn("Camera not available", e.message)
    }
  }

  stopCamera() {
    const stream = this.videoTarget.srcObject
    if (!stream) return
    // const tracks = stream.getTracks();
    // tracks[0].stop();
    stream.getTracks().forEach(track => track.stop())
    this.videoTarget.srcObject = null
  }

  start() {
    this.recTarget.classList.remove("hidden")
    // 45秒のインターバル撮影
    // this.close()  撮影後に自動で撮影画面をクローズ
  }

  close() {
    this.recTarget.classList.add("hidden")
    this.screenTarget.classList.add("hidden")
    this.stopCamera()
  }

  disconnect() {
    this.stopCamera()
  }
}
