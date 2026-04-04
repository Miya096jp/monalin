import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["screen", "video", "canvas", "flash"];

	open() {
		this.screenTarget.classList.remove("hidden");
		this.startCamera();
	}

	async startCamera() {
		try {
			const stream = await navigator.mediaDevices.getUserMedia({
				audio: false,
				video: true,
			});
			this.videoTarget.srcObject = stream;
			await this.videoTarget.play();
		} catch (e) {
			console.warn("Camera not available", e.message);
		}
	}

	stopCamera() {
		const stream = this.videoTarget.srcObject;
		if (!stream) return;
		stream.getTracks().forEach((track) => {
			track.stop();
		});
		this.videoTarget.srcObject = null;
	}

	close() {
		this.screenTarget.classList.add("hidden");
		this.stopCamera();
	}

	disconnect() {
		this.stopCamera();
	}

	start() {
		this.capturedCount = 1;
		this.recTarget.classList.remove("hidden");

		this.prepTimer = setTimeout(() => {
			this.startIntervalCapture();
		}, this.prepDurationValue);
	}

	capture() {
		try {
			this.flashTarget.classList.replace("opacity-0", "opacity-100");
			setTimeout(() => {
				this.flashTarget.classList.replace("opacity-100", "opacity-0");
			}, 100);
			// const blob = await this.captureFrame();
			// 撮影ボタン押下 -> capture発火 -> 写真を配列追加(ary.push(blob)) -> complete()でlistにdispatch
			// console.log(`Captured: ${this.capturedCount}`);
		} catch (e) {
			console.error("Failed to capture and save:", e);
		}
	}

	captureFrame() {
		const video = this.videoTarget;
		const canvas = this.canvasTarget;
		const ctx = canvas.getContext("2d");

		canvas.width = video.videoWidth;
		canvas.height = video.videoHeight;
		ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

		return new Promise((resolve) => {
			canvas.toBlob((blob) => resolve(blob), "image/jpeg", 0.8);
		});
	}
}
