class SessionsController < ApplicationController
  def new
  end

  def show
    @session = current_user.sessions.find(params[:id])
    @session_messages = @session.messages.order(created_at: :asc)
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
