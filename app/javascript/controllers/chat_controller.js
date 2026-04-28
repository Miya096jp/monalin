import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["loader", "container"];

	showLoader() {
		this.containerTarget.appendChild(this.loaderTarget);
		this.loaderTarget.classList.remove("hidden");
	}

	hideLoader(e) {
		const stream = e.detail.newStream;
		if (stream.getAttribute("target") === "chat") {
			this.loaderTarget.classList.add("hidden");
		}
	}
}
