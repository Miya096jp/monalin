import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["screen", "frame"];

	showImagePreview(e) {
		this.frameTarget.src = e.currentTarget.src;
		this.screenTarget.classList.remove("hidden");
	}

	closeImagePreview() {
		this.screenTarget.classList.add("hidden");
		this.frameTarget.src = "";
	}
}
