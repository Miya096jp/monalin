class AddStatusToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :status, :string, default: "processing", null: false
  end
end
