class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :session, null: false, foreign_key: true
      t.integer :role, null: false, default: 0
      t.text :body
      t.integer :token
      t.timestamps
    end
  end
end
