# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    Rails.application.credentials.dig(:google, Rails.env.to_sym, :client_id),
    Rails.application.credentials.dig(:google, Rails.env.to_sym, :client_secret),
           scope: "email,profile"

  provider :line,
    Rails.application.credentials.dig(:line, Rails.env.to_sym, :channel_id),
    Rails.application.credentials.dig(:line, Rails.env.to_sym, :channel_secret),
           scope: "profile openid"
end

OmniAuth.config.allowed_request_methods = %i[get post]
