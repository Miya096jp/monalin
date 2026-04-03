class CreateImageAttachments < ActiveRecord::Migration[8.1]
  def change
    create_table :image_attachments do |t|
      t.references :message, null: false, foreign_key: true
      t.string :object_key, null: false
      t.boolean :diagnosed, null: false, default: false
      t.timestamps
    end
  end
end
