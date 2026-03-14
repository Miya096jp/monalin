class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email
      t.integer :role, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :tickets, null: false, default: 3
      t.string :stripe_customer_id
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
