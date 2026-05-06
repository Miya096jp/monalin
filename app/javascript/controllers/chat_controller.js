import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["loader", "container", "error"];

	connect() {
		this.startObserve();
	}

	startObserve() {
		if (!this.hasContainerTarget) return;
		const config = {
			childList: true,
			attributes: false,
			subtree: true,
		};

		const callback = (mutationList, observer) => {
			const hasAddedNode = mutationList.some((mutationRecord) => {
				return (
					mutationRecord.type === "childList" &&
					mutationRecord.addedNodes.length > 0
				);
			});

			if (hasAddedNode) {
				this.containerTarget.lastElementChild.scrollIntoView({
					behavior: "smooth",
					block: "end",
				});
			}
		};

		this.observer = new MutationObserver(callback);
		this.observer.observe(this.containerTarget, config);
	}

	showLoader() {
		if (!this.hasLoaderTarget) return;
		this.containerTarget.appendChild(this.loaderTarget);
		this.loaderTarget.classList.remove("hidden");
	}

	hideLoader(e) {
		const stream = e.detail.newStream;
		if (stream.getAttribute("target") === "chat") {
			this.loaderTarget.classList.add("hidden");
		}
	}

	showError(e) {
		if (!this.hasErrorTarget) return;
		clearTimeout(this.errorTimer);
		this.errorTarget.textContent = e.detail.message;
		this.errorTarget.classList.replace("opacity-0", "opacity-100");
		this.hideError();
	}

	hideError() {
		this.errorTimer = setTimeout(() => {
			this.errorTarget.classList.replace("opacity-100", "opacity-0");
		}, 3000);
	}

	disconnect() {
		this.observer.disconnect();
	}
}
