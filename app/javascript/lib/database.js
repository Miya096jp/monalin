import Dexie from "dexie";

const db = new Dexie("AppDatabase");

db.version(1).stores({
	captures: "key, message_id, captured_at",
});

export default db;
