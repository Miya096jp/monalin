require "rails_helper"

RSpec.describe "Video capture", type: :system do
  before do
    sign_in_with_google
  end

  describe "video capture on an existing session" do
    let!(:chat_session) { create(:session, user: User.last) }

    before do
      visit session_path(chat_session)
    end

    it "shows the capture screen when the video button is clicked" do
      find('button[aria-label="撮影メニューを開く"]').click
      find('button[aria-label="ビデオ撮影"]').click
      expect(page).to have_css('[data-video-capture-target="screen"]:not(.hidden)')
    end

    it "closes the capture screen when the close button is clicked" do
      find('button[aria-label="撮影メニューを開く"]').click
      find('button[aria-label="ビデオ撮影"]').click
      expect(page).to have_css('[data-video-capture-target="screen"]:not(.hidden)')

      find('button[aria-label="閉じる"]').click
      expect(page).to have_css('[data-video-capture-target="screen"].hidden', visible: false)
    end
  end
end
