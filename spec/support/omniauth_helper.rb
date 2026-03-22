module OmniauthHelper
  def sign_in_with_google(user = nil)
    user ||= create(:user)
    create(:social_account, user: user, provider: "google_oauth2", uid: "123456")

    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "123456",
      info: {
        email: user.email,
        name: user.username
      },
      credentials: {
        token: "mock_token",
        refresh_token: "mock_refresh_token",
        expires_at: Time.now.to_i + 3600
      }
    )

    visit login_path
    click_on "Googleでログイン"
  end
end
