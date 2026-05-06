class ProcessAiResponseJob < ApplicationJob
  queue_as :default

  server_error_msg = "サーバーに接続できませんでした。しばらく経ってからもう一度お試しください"
  request_error_msg = "アクセスが集中しています。しばらく時間を空けてお試しください。"
  client_error_msg = "エラーが発生しました"

  retry_on Faraday::ConnectionFailed, wait: 10.seconds, attempts: 3 do |job, error|
    message = Message.find(job.arguments.first[:message][:id])
    message.mark_as_failed!
    session = job.arguments.first[:session]
    Rails.logger.error("[Gemini] #{error.class}: #{error.message} | #{error.backtrace&.first(3)&.join(' <- ')}")
    Gemini::ProcessAiResponse.return_error_message(session, server_error_msg)
  end

  retry_on Faraday::TimeoutError, wait: 10.seconds, attempts: 3 do |job, error|
    message = Message.find(job.arguments.first[:message][:id])
    message.mark_as_failed!
    session = job.arguments.first[:session]
    Rails.logger.error("[Gemini] #{error.class}: #{error.message} | #{error.backtrace&.first(3)&.join(' <- ')}")
    Gemini::ProcessAiResponse.return_error_message(session, server_error_msg)
  end

  discard_on Faraday::SSLError do |job, error|
    message = Message.find(job.arguments.first[:message][:id])
    message.mark_as_failed!
    session = job.arguments.first[:session]
    Rails.logger.error("[Gemini] #{error.class}: #{error.message} | #{error.backtrace&.first(3)&.join(' <- ')}")
    Gemini::ProcessAiResponse.return_error_message(session, server_error_msg)
  end

  retry_on Gemini::Errors::RequestError, wait: 10.seconds, attempts: 3 do |job, error|
    message = Message.find(job.arguments.first[:message][:id])
    message.mark_as_failed!
    session = job.arguments.first[:session]
    status = error.request&.response&.dig(:status) || "unknown"
    Rails.logger.error("[Gemini][#{status}] #{error.class}: #{error.message} | #{error.backtrace&.first(4)&.join(' <- ')}")
    Gemini::ProcessAiResponse.return_error_message(session, server_error_msg)
  end

  discard_on Faraday::ClientError do |job, error|
    message = Message.find(job.arguments.first[:message][:id])
    message.mark_as_failed!
    session = job.arguments.first[:session]
    Rails.logger.error("[Gemini] #{error.class}: #{error.message} | #{error.backtrace&.first(3)&.join(' <- ')}")
    Gemini::ProcessAiResponse.return_error_message(session, client_error_msg)
  end

  retry_on Faraday::TooManyRequestsError, wait: 15.seconds, attempts: 3 do |job, error|
    message = Message.find(job.arguments.first[:message][:id])
    message.mark_as_failed!
    session = job.arguments.first[:session]
    status = error.response_status || "unknown"
    body = error.response_body
    Rails.logger.error("[Gemini][#{status}] #{error.class}: #{error.message} | details: #{body} | #{error.backtrace&.first(3)&.join(' <- ')}")
    Gemini::ProcessAiResponse.return_error_message(session, request_error_msg)
  end

  def perform(session:, message:, images: [])
    if executions >= 1
      Gemini::ProcessAiResponse.show_retry_counts(session, executions)
    end
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
