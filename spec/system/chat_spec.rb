require "rails_helper"

RSpec.describe "Chat message", type: :system do
  before do
    sign_in_with_google
  end

  describe "sends a message to an existing session" do
    let!(:chat_session) { create(:session, user: User.last) }

    before do
      visit session_path(chat_session)
    end

    it "appears in the chat thread after sent" do
      fill_in "message_body", with: "hello"
      find('input[type="submit"]').click
      expect(page).to have_content("hello")
    end

    it "disappears from the chat form after sent" do
      fill_in "message_body", with: "chao"
      find('input[type="submit"]').click
      expect(page).to have_field("message_body", with: "")
    end

    it "cannot be sent when it is empty" do
      find('input[type="submit"]').click
      expect(page).to have_no_css(".user-message")
    end
  end
end
