import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["input"];
	static values = { message: Boolean };

	async send(e) {
		e.preventDefault();

		const body = this.inputTarget.value;
		const blobs = await db.captures
			.filter((c) => c.message_id === null)
			.toArray();

		if (this.messageValue === false && blobs.length === 0) {
			this.dispatch("error", {
				detail: { message: "最初に撮影を行なってください" },
			});
			return;
		} else if (
			this.messageValue === true &&
			blobs.length === 0 &&
			body === ""
		) {
			return;
		}

		const formData = new FormData();
		formData.append("message[body]", body);
		if (blobs.length > 0) {
			blobs.forEach((b, i) => {
				formData.append(`message[images][${i}][key]`, b.key);
				const blob = new Blob([b.blob], { type: b.type || "image/jpeg" });
				formData.append(`message[images][${i}][blob]`, blob);
			});
		}

		try {
			const response = await fetch(this.element.action, {
				method: "POST",
				body: formData,
				headers: {
					"X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
						.content,
				},
			});

			if (response.status === 422) {
				const res = await response.json();
				this.dispatch("error", { detail: { message: res.message } });
				return;
			}

			if (!response.ok) {
				throw new Error(`予期せぬステータス: ${response.status}`);
			}

			const res = await response.json();

			await db.captures
				.filter((c) => c.message_id === null)
				.modify({ message_id: res.message_id });

			if (response.status === 201) {
				window.location.href = response.headers.get("Location");
				this.messageValue = true;
			} else {
				this.appendMessage(body);
				this.messageValue = true;
			}
		} catch (error) {
			console.error("通信エラー:", error);
		} finally {
			this.dispatch("submitted");
		}
		this.inputTarget.value = "";
	}

	appendMessage(body) {
		const container = document.getElementById("chat");
		const outer = document.createElement("div");
		outer.className = "user-message flex justify-end";
		const inner = document.createElement("div");
		inner.className = "bg-chat rounded-lg p-4 max-w-xs";
		const p = document.createElement("p");
		p.textContent = body;

		inner.appendChild(p);
		outer.appendChild(inner);
		container.appendChild(outer);
		outer.scrollIntoView({ behavior: "smooth" });
	}
}
