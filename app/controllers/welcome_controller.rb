class WelcomeController < ApplicationController
  skip_before_action :require_login
  layout "auth"

  def index; end
end
