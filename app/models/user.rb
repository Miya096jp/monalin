class User < ApplicationRecord
  enum :role, { user: 0, admin: 1 }
  enum :status, { active: 0, suspended: 1, banned: 2 }

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
end
