import { Controller } from "@hotwired/stimulus";
import db from "lib/database";

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
		this.capturedCount = 1;
		this.recTarget.classList.remove("hidden");

		this.prepTimer = setTimeout(() => {
			this.startIntervalCapture();
		}, this.prepDurationValue);
	}

	async startIntervalCapture() {
		await this.capture();

		this.intervalTimer = setInterval(async () => {
			await this.capture();

			if (this.capturedCount >= this.totalShotsValue) {
				clearInterval(this.intervalTimer);
				this.close();
			}
		}, this.intervalDurationValue);
	}

	async capture() {
		try {
			const blob = await this.captureFrame();
			const record = {
				key: crypto.randomUUID(),
				message_id: null,
				blob: blob,
				diagnose: null,
				captured_at: new Date().toISOString(),
			};
			await db.captures.add(record);
			this.capturedCount++;
			console.log(
				`Captured: ${this.capturedCount}/${this.totalShotsValue}`,
				record.key,
			);
		} catch (e) {
			console.error("Failed to capture and save:", e);
		}
	}

	captureFrame() {
		const video = this.videoTarget;
		const canvas = this.canvasTarget;
		const ctx = canvas.getContext("2d");

		const srcWidth = video.videoHeight * (9 / 16);
		const srcHeight = srcWidth * (4 / 3);
		const sx = (video.videoWidth - srcWidth) / 2;
		const sy = (video.videoHeight - srcHeight) / 2;

		canvas.width = srcWidth;
		canvas.height = srcHeight;

		ctx.drawImage(
			video,
			sx,
			sy,
			srcWidth,
			srcHeight,
			0,
			0,
			srcWidth,
			srcHeight,
		);

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
