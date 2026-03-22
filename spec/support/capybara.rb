require "capybara/rspec"
require "selenium-webdriver"

RSpec.configure do |config|
  config.before(:each, type: :system) do
    if ENV["SELENIUM_REMOTE_URL"].present?
      driven_by :selenium, using: :headless_chrome, options: {
        browser: :remote,
        url: ENV["SELENIUM_REMOTE_URL"]
      }

      Capybara.server_host = "0.0.0.0"
      Capybara.server_port = ENV.fetch("TEST_APP_PORT", 3001).to_i
      Capybara.app_host = "http://#{ENV.fetch("TEST_APP_HOST", "web")}:#{Capybara.server_port}"
    else
      driven_by :selenium, using: :headless_chrome
    end
  end
end
