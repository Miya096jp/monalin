class ProcessAiResponseJob < ApplicationJob
  queue_as :default

  def perform(session:, message:, images: [])
    image_attachments = message.image_attachments()
    chat_history = session.messages.where.not(id: message.id).order(:created_at)
    Gemini::ProcessAiResponse.call(
      session: session,
      message: message,
      images: images,
      image_attachments: image_attachments,
      chat_history: chat_history
    )
  end
end
