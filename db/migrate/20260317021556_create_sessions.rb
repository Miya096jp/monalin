class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_title, null: false, default: "新規セッション"
      t.timestamps
    end
  end
end
