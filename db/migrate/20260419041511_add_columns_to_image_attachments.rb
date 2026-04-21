class AddColumnsToImageAttachments < ActiveRecord::Migration[8.1]
  def change
    add_column :image_attachments, :diagnosed_detail, :string
    add_column :image_attachments, :ai_message_id, :integer
  end
end
