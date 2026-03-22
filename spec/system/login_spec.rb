require "rails_helper"

RSpec.describe "ログイン", type: :system do
  describe "Google OAuthでログイン" do
    it "moves to home" do
      sign_in_with_google
      expect(page).to have_current_path(home_path)
    end
  end
end
