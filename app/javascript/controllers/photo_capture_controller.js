import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["screen", "video", "canvas", "flash"];

	open() {
		this.screenTarget.classList.remove("hidden");
		this.startCamera();
		this.capturedPhotos = [];
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

	async capture() {
		try {
			const blob = await this.captureFrame();
			this.capturedPhotos.push(blob);
			this.flashTarget.classList.replace("opacity-0", "opacity-100");
			setTimeout(() => {
				this.flashTarget.classList.replace("opacity-100", "opacity-0");
			}, 100);
			console.log(`Captured Photos: ${this.capturedPhotos.length} captured!`);
		} catch (e) {
			console.error("Failed to capture and save:", e);
		}
	}

	captureFrame() {
		const video = this.videoTarget;
		const canvas = this.canvasTarget;
		const ctx = canvas.getContext("2d");

		const srcHeight = video.videoHeight;
		const srcWidth = srcHeight * (9 / 16);
		const sx = (video.videoWidth - srcWidth) / 2;

		canvas.width = srcWidth;
		canvas.height = srcHeight;
		ctx.drawImage(video, sx, 0, srcWidth, srcHeight, 0, 0, srcWidth, srcHeight);

		return new Promise((resolve) => {
			canvas.toBlob((blob) => resolve(blob), "image/jpeg", 0.8);
		});
	}

	complete() {
		this.dispatch("complete", {
			detail: { photos: this.capturedPhotos },
		});
		this.close();
	}

	close() {
		this.screenTarget.classList.add("hidden");
		this.capturedPhotos = [];
		this.stopCamera();
	}
}
