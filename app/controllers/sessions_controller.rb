class SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    social = SocialAccount.find_by(provider: auth.provider, uid: auth.uid)

    if social
      user = social.user
      session[:user_id] = user.id
      # 暫定: sessions_pathに変更予定
      redirect_to root_path, notice: "ログインしました"
    else
      session[:omniauth_data] = {
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name,
        email: auth.info.email,
        access_token: auth.credentials.token,
        refresh_token: auth.credentials.refresh_token,
        token_expires_at: auth.credentials.expires_at
      }
      redirect_to signup_path, notice: "ユーザー登録してください"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "ログアウトしました"
  end

  def failure
    redirect_to login_path, alert: "認証に失敗しました"
  end
end
