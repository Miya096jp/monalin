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

    it "automatically captures images in the specified period" do
      el = find('[data-controller="video-capture"]')
      execute_script("arguments[0].setAttribute('data-video-capture-prep-duration-value', '300')", el)
      execute_script("arguments[0].setAttribute('data-video-capture-interval-duration-value', '200')", el)

      find('button[aria-label="撮影メニューを開く"]').click
      find('button[aria-label="ビデオ撮影"]').click

      expect(page).to have_css('[data-video-capture-target="screen"]')

      find('button[aria-label="撮影"]').click
      expect(page).to have_css('[data-video-capture-target="rec"]')

      expect(page).to have_no_css('[data-video-capture-target="screen"]', wait: 5)
    end
  end
end
