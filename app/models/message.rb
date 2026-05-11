class Message < ApplicationRecord
  enum :role, { user: 0, ai: 1 }
  enum :status, { processing: "processing", completed: "completed", failed: "failed" }
  belongs_to :session
  has_many :image_attachments, dependent: :destroy
  has_many :diagnosed_images, class_name: "ImageAttachment", foreign_key: :ai_message_id, dependent: :nullify

  validates :role, inclusion: { in: %w[user ai] }
  validates :status, inclusion: { in: %w[processing completed failed] }
  validates :body, length: { maximum: 500 }

  def mark_as_failed!
    update!(status: "failed")
  end
end
