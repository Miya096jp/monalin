require "rails_helper"

RSpec.describe "Photo capture", type: :system do
  before do
    sign_in_with_google
  end

  describe "photo capture on an existing session" do
    let!(:chat_session) { create(:session, user: User.last) }

    before do
      visit session_path(chat_session)
    end

    it "shows the capture screen when the photo button is clicked" do
      find('button[aria-label="撮影メニューを開く"]').click
      find('button[aria-label="カメラ撮影"]').click
      expect(page).to have_css('[data-photo-capture-target="screen"]')
    end

    it "closes the capture screen when the close button is clicked" do
      find('button[aria-label="撮影メニューを開く"]').click
      find('button[aria-label="カメラ撮影"]').click
      expect(page).to have_css('[data-photo-capture-target="screen"]')

      find('button[aria-label="閉じる"]').click
      expect(page).to have_css('[data-photo-capture-target="screen"].hidden', visible: false)
    end
  end
end
