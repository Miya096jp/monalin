require "capybara/rspec"
require "selenium-webdriver"

RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    screen_size = example.metadata[:desktop] ? [ 1280, 800 ] : [ 375, 812 ]
    if ENV["SELENIUM_REMOTE_URL"].present?
      driven_by :selenium, using: :headless_chrome, screen_size: screen_size, options: {
        browser: :remote,
        url: ENV["SELENIUM_REMOTE_URL"]
      }

      Capybara.server_host = "0.0.0.0"
      Capybara.server_port = ENV.fetch("TEST_APP_PORT", 3001).to_i
      Capybara.app_host = "http://#{ENV.fetch("TEST_APP_HOST", "web")}:#{Capybara.server_port}"
    else
      driven_by :selenium, using: :headless_chrome
    end
    ActionController::Base.allow_forgery_protection = true
  end
  config.after(:each, type: :system) do
    ActionController::Base.allow_forgery_protection = false
  end
end
