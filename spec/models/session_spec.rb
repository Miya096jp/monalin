require 'rails_helper'

RSpec.describe Session, type: :model do
  it "is invalid with blank session_title" do
    session = FactoryBot.build(:session, session_title: nil)
    session.valid?
    expect(session.errors.of_kind?(:session_title, :blank)).to be true
  end

  it "is valid with session_title" do
    session = FactoryBot.build(:session)
    expect(session).to be_valid
  end

  it "is valid with session_title of 100 characters" do
    session = FactoryBot.build(:session, session_title: "a" * 100)
    expect(session).to be_valid
  end

  it "is valid with session_title over 100 characters" do
    session = FactoryBot.build(:session, session_title: "a" * 101)
    expect(session).not_to be_valid
  end
end
