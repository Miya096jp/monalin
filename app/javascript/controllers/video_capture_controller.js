import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["screen", "video", "rec", "canvas"];
	static values = {
		prepDuration: { type: Number, default: 5000 },
		intervalDuration: { type: Number, default: 8000 },
		totalShots: { type: Number, default: 6 },
	};

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

	start() {
		this.capturedImages = [];
		this.recTarget.classList.remove("hidden");

		this.prepTimer = setTimeout(() => {
			this.startIntervalCapture();
		}, this.prepDurationValue);
	}

	async startIntervalCapture() {
		await this.capture();

		let count = 1;
		this.intervalTimer = setInterval(async () => {
			await this.capture();
			count++;

			if (count >= this.totalShotsValue) {
				clearInterval(this.intervalTimer);
				this.close();
			}
		}, this.intervalDurationValue);
	}

	async capture() {
		const blob = await this.captureFrame();
		this.capturedImages.push(blob);
		console.log(
			`Captured: ${this.capturedImages.length}/${this.totalShotsValue}`,
			blob,
		);
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

	stopCamera() {
		const stream = this.videoTarget.srcObject;
		if (!stream) return;
		stream.getTracks().forEach((track) => {
			track.stop();
		});
		this.videoTarget.srcObject = null;
	}

	close() {
		clearTimeout(this.prepTimer);
		clearInterval(this.intervalTimer);
		this.recTarget.classList.add("hidden");
		this.screenTarget.classList.add("hidden");
		this.stopCamera();
		this.capturedImages = [];
	}

	disconnect() {
		clearTimeout(this.prepTimer);
		clearInterval(this.intervalTimer);
		this.stopCamera();
	}
}
