import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["loader", "container"];

	connect() {
		this.startObserve();
	}

	startObserve() {
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
		this.containerTarget.appendChild(this.loaderTarget);
		this.loaderTarget.classList.remove("hidden");
	}

	hideLoader(e) {
		const stream = e.detail.newStream;
		if (stream.getAttribute("target") === "chat") {
			this.loaderTarget.classList.add("hidden");
		}
	}

	disconnect() {
		this.observer.disconnect();
	}
}
