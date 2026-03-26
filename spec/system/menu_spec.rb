require "rails_helper"

RSpec.describe "Menu", type: :system do
  before do
    sign_in_with_google
  end

  describe "Main menu" do
    it "opens sidebar when hamburger icon is clicked" do
      find("[data-action='click->menu#open']").click
      expect(find("[data-menu-target='aside']")[:class]).to include("translate-x-0")
    end

    it "closes sidebar when close button is clicked" do
      find("[data-action='click->menu#open']").click
      find("[aria-label='メニューを閉じる']").click
      expect(find("[data-menu-target='aside']")[:class]).to include("-translate-x-full")
    end

    it "closes sidebar when overlay is clicked" do
      find("[data-action='click->menu#open']").click
      find("[data-menu-target='overlay']").click
      expect(find("[data-menu-target='aside']")[:class]).to include("-translate-x-full")
    end
  end

  # ハンバーガーメニュー内の左下3点リーダーアイコン
  describe "Submenu" do
    before do
      find("[data-action='click->menu#open']").click
    end

    it "shows submenu when ellipsis is clicked" do
      find("[data-action='click->submenu#toggle']").click
      expect(page).to have_css("[data-submenu-target='list']", visible: :visible)
    end
  end

  # セッションリスト. Turbo frameでインライン編集・削除
  describe "Session menu" do
    let!(:chat_session) { create(:session, user: User.last) }

    before do
      visit home_path
      find("[data-action='click->menu#open']").click
    end

    it "shows edit and delete when ellipsis is clicked" do
      within first("[data-controller='session-menu']") do
        find("[data-action='click->session-menu#show']", visible: :all).click
        expect(page).to have_css("[data-session-menu-target='list']", visible: :visible)
      end
    end
  end

  # フォーム横の+ボタンで撮影メニュー開閉
  describe "Capture menu" do
    let!(:chat_session) { create(:session, user: User.last) }

    before do
      visit session_path(chat_session)
    end

    it "shows capture menu when plus button is clicked" do
      find("[data-action='click->capture-menu#show']").click
      expect(page).to have_css("[data-capture-menu-target='list']", visible: :visible)
    end

    it "hides capture menu when textarea is focused" do
      find("[data-action='click->capture-menu#show']").click
      find("textarea").click
      expect(page).to have_css("[data-capture-menu-target='list']", visible: :hidden)
    end
  end
end
