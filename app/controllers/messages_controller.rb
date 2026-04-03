class MessagesController < ApplicationController
  def create
    @session = find_or_create_session
    @message = @session.messages.build(body: message_params[:body])
    @message.role = "user"

    if message_params[:images]
      message_params[:images].values.each do |image|
        @message.image_attachments.build(object_key: image[:key])
      end
    end

    if @session.save
      response_data = { message_id: @message.id }
      if @session.previously_new_record?
        render json: response_data, status: :created, location: session_path(@session)
      else
        render json: response_data, status: :ok
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

  def find_session
    current_user.sessions.find(params[:session_id])
  end

  def message_params
    params.require(:message).permit(:body, images: [ :key, :blob ])
  end
end
