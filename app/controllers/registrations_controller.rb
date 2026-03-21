class RegistrationsController < ApplicationController
  skip_before_action :require_login
  layout "auth"

  def new
  end

  def create
    auth = session[:omniauth_data]

    unless auth
      redirect_to login_path, alert: "認証情報がありません"
      return
    end

    user = User.new(
      username: auth["name"],
      email: auth["email"]
    )

    ActiveRecord::Base.transaction do
      user.save!
      user.social_accounts.create!(
        provider: auth["provider"],
        uid: auth["uid"],
        access_token: auth["access_token"],
        refresh_token: auth["refresh_token"],
        token_expires_at: auth["token_expires_at"] ? Time.at(auth["token_expires_at"]) : nil
      )
    end

    session.delete(:omniauth_data)
    session[:user_id] = user.id
    redirect_to home_path, notice: "登録が完了しました"

  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(e.message)
    redirect_to login_path, alert: "登録に失敗しました"
  end
end
