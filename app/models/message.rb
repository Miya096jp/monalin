class Message < ApplicationRecord
  enum :role, { user: 0, ai: 1 }
  belongs_to :session
  has_many :image_attachments, dependent: :destroy
  has_many :diagnosed_images, class_name: "ImageAttachment", foreign_key: :ai_message_id
end
