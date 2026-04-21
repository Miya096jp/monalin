require "json"
require "gemini-ai"

class Gemini::ProcessAiResponse
  def self.call(**kwargs) = new(**kwargs).call

  def initialize(session:, message:, images: [], image_attachments: [], chat_history: [])
    @session = session
    @message = message
    @images = images
    @image_attachments = image_attachments
    @chat_history = chat_history
    @config_path ||= Rails.root.join("config/gemini/generation_config.yml")
  end

  def call
    response = fetch_ai_response
    save_ai_response(response)
  end

  private

  def fetch_ai_response
    client = Gemini.new(
      credentials: {
        service: "generative-language-api",
        api_key: Rails.application.credentials.dig(:gemini, :api_key),
        version: "v1beta"
      },
      options: { model: "gemini-2.5-flash" }
    )

    instruction_prompt = ApplicationController.render(
      template: "gemini/prompts/instruction",
      formats: [ :text ],
      locals: { image_count: @images.size }
    )

    response = client.generate_content({
      "system_instruction": {
        "parts": [
          { "text": instruction_prompt }
        ]
      },
        "contents": Gemini::BuildAiRequestContents.call(
          session: @session,
          message: @message,
          images: @images,
          chat_history: @chat_history
        ),
      "generationConfig": YAML.load_file(@config_path) })
    response
  end

  def save_ai_response(response)
    text = response.dig("candidates", 0, "content", "parts", 0, "text")
    parsed = JSON.parse(text)
    diagnosed_results = parsed["image_metadata"]
    ai_message_body = parsed["message_body"]

    ActiveRecord::Base.transaction do
      ai_message = @session.messages.create!(
        body: ai_message_body,
        role: "ai",
        token: response.dig("usageMetadata", "totalTokenCount") || 0
      )

      if @image_attachments.any?
        @image_attachments.each_with_index do |img, i|
          img.update!(
            diagnosed: diagnosed_results[i]["diagnosed"],
            ai_message_id: ai_message.id,
            diagnosed_detail: diagnosed_results[i]["diagnosed_detail"]
          )
        end
      end
    end
  end
end
