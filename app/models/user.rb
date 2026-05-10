class User < ApplicationRecord
  enum :role, { user: 0, admin: 1 }
  enum :status, { active: 0, suspended: 1, banned: 2 }

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  validetas :username, presence: true, length: { maximum: 24 }

  has_many :social_accounts, dependent: :destroy
  has_many :sessions, dependent: :destroy
end
