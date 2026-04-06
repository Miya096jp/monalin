import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["itemTemplate", "screen", "list", "error"];

	show(e) {
		this.photos = e.detail.photos;
		if (!this.photos) return;
		this.listTarget.innerHTML = "";
		this.photos.forEach((photo, i) => {
			const clone = this.itemTemplateTarget.content.cloneNode(true);
			clone.querySelector("img").src = URL.createObjectURL(photo);
			clone.querySelector("input").dataset.index = i;
			this.listTarget.appendChild(clone);
		});
		this.screenTarget.classList.remove("hidden");
	}

	toggle(e) {
		const checkMark = e.currentTarget;
		const item = checkMark.closest(".photoItem");
		const checkbox = item.querySelector("input");

		checkbox.checked = !checkbox.checked;

		if (checkbox.checked) {
			checkMark.classList.replace("bg-gray-500", "bg-green-500");
		} else {
			checkMark.classList.replace("bg-green-500", "bg-gray-500");
		}
	}

	async confirm() {
		const selectedPhotos = this.listTarget.querySelectorAll("input:checked");

		if (selectedPhotos.length === 0) {
			this.showError("写真を選択してください");
			return;
		}

		if (selectedPhotos.length >= 5) {
			this.showError("同時に分析できる写真は5枚までです");
			return;
		}

		for (const selectedPhoto of selectedPhotos) {
			const index = parseInt(selectedPhoto.dataset.index);
			const blob = this.photos[index];
			await db.captures.add({
				key: crypto.randomUUID(),
				message_id: null,
				blob: blob,
				diagnose: null,
				captured_at: new Date().toISOString(),
			});
		}
		this.close();
	}

	showError(message) {
		clearTimeout(this.errorTimer);
		this.errorTarget.textContent = message;
		this.errorTarget.classList.replace("opacity-0", "opacity-100");
		this.hideError();
	}

	hideError() {
		this.errorTimer = setTimeout(() => {
			this.errorTarget.classList.replace("opacity-100", "opacity-0");
		}, 3000);
	}

	close() {
		this.screenTarget.classList.add("hidden");
		this.photos = [];
	}
}
