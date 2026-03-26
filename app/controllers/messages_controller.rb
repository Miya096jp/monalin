class MessagesController < ApplicationController
  def create
    @session = find_or_create_session
    @message = @session.messages.build(message_params)
    @message.role = "user"

    if @session.save
      if @session.previously_new_record?
        head :created, location: session_path(@session)
      else
        head :ok
      end
    else
      head :unprocessable_entity
    end
  end

  def update
  end

  private

  def find_or_create_session
    if params[:session_id]
      current_user.sessions.find(params[:session_id])
    else
      current_user.sessions.build(session_title: "新しいセッション")
    end
  end


  def message_params
    params.require(:message).permit(:body)
  end
end
