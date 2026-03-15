require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid email" do
    user = FactoryBot.build(:user, email: "valid@example.com")
    expect(user).to be_valid
  end

  it "is invalid with malformed email" do
    user = FactoryBot.build(:user, email: "not-an-email")
    expect(user).not_to be_valid
  end

  it "is valid with email nil" do
    user = FactoryBot.build(:user, email: nil)
    expect(user).to be_valid
  end

  it "is valid with a unique email address" do
    FactoryBot.create(:user, email: "first@example.com")
    user = FactoryBot.build(:user, email: "second@example.com")
    expect(user).to be_valid
  end

  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "dup@example.com")
    user = FactoryBot.build(:user, email: "dup@example.com")
    user.valid?
    expect(user.errors.of_kind?(:email, :taken)).to be true
  end

  it "has default role of user" do
    user = FactoryBot.build(:user)
    expect(user).to be_user
  end

  it "has default status of active" do
    user = FactoryBot.build(:user)
    expect(user).to be_active
  end
end
