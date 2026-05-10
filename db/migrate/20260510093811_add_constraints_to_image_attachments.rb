class AddConstraintsToImageAttachments < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :image_attachments, :messages, column: :ai_message_id
    add_index :image_attachments, :ai_message_id
    change_column_null :image_attachments, :ai_message_id, true
  end
end
