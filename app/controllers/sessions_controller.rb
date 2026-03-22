class SessionsController < ApplicationController
  before_action :set_session, only: [ :show, :edit, :update, :destroy ]

  def show
    @session_messages = @session.messages.order(created_at: :asc)
  end

  def edit
    render partial: "sessions/session_edit_row", locals: { session: @session }
  end

  def update
    if @session.update(session_params)
      render partial: "sessions/session_list_item", locals: { session: @session }
    else
      render partial: "sessions/session_edit_row", locals: { session: @session }, status: :unprocessable_entity
    end
  end

  def destroy
    @session.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@session)) }
      format.html { redirect_to root_path }
    end
  end

  private

  def set_session
    @session = current_user.sessions.find(params[:id])
  end

  def session_params
    params.require(:session).permit(:session_title)
  end
end
