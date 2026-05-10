class AddUniqueConstraintToImageAttachmentsObjectKey < ActiveRecord::Migration[8.1]
  def change
    add_index :image_attachments, :object_key, unique: true
  end
end
