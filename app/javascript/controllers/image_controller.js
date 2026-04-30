import { Controller } from "@hotwired/stimulus";
import db from "lib/database";

export default class extends Controller {
	static targets = ["garelly"];
	static values = {
		imageMetadata: { type: Array, default: [] },
	};

	async connect() {
		await this.update();
		const records = await this.fetch();
		this.show(records);
	}

	async update() {
		try {
			for (const metadata of this.imageMetadataValue) {
				await db.captures
					.filter((c) => c.key === metadata.object_key)
					.modify({ diagnose: metadata.diagnosed });
			}
		} catch (e) {
			console.error("Image update failed:", e);
		}
	}

	async fetch() {
		const keys = this.imageMetadataValue.map((img) => img.object_key);
		try {
			const records = await db.captures
				.filter((c) => keys.includes(c.key) && c.diagnose === true)
				.toArray();
			return records;
		} catch (e) {
			console.error("Image fetch failed:", e);
		}
	}

	async show(records) {
		if (records.length === 0) return;
		for (const record of records) {
			const img = document.createElement("img");
			img.src = URL.createObjectURL(record.blob);
			img.classList.add("w-full", "aspect-square", "object-cover", "rounded");
			img.setAttribute("data-action", "click->image-preview#showImagePreview");
			try {
				await img.decode();
				this.garellyTarget.appendChild(img);
			} catch (e) {
				console.error("Decode failded:", e);
			}
		}
	}
}
