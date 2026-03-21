class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_sidebar_sessions, :require_login

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  helper_method :current_user

  private

  def require_login
    unless current_user
      redirect_to login_path, alert: "ログインしてください"
    end
  end

  def current_user
  @current_user ||= User.find_by(id: session[:user_id])
  end

  def set_sidebar_sessions
    @sidebar_sessions = current_user&.sessions&.order(created_at: :desc) || []
  end
end
