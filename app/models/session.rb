class Session < ApplicationRecord
  validates :session_title, presence: true, length: { maximum: 100 }
  has_many :messages, dependent: :destroy

  belongs_to :user
end
