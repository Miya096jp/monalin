class Gemini::BuildAiRequestContents
  def self.call(**kwargs) = new(**kwargs).call

  def initialize(session:, message:, images: [], chat_history: [])
    @session = session
    @message = message
    @images = images
    @chat_history = chat_history
  end

  def call
    contents = build_history
    contents << build_current_turn
    contents
  end

  private

  def build_history
    @chat_history.map do |msg|
      chat_turn = {
        role: msg.role == "ai" ? "model" : "user",
        parts: [
          { text: msg.body.presence || "No message" }
        ]
      }

      if msg.diagnosed_images.any?
        msg.diagnosed_images.each_with_index do |img, i|
          chat_turn[:parts] << {
            text: "Image_description_#{i + 1}: #{img.diagnosed_detail}"
        }
        end
      end
      chat_turn
    end
  end

  def build_current_turn
    current_turn = {
      role: @message.role,
      parts: [
        { text: @message.body.presence || "No message" }
      ]
    }

    if @images.any?
      @images.each do |img|
        current_turn[:parts] << { inline_data: {
          mime_type: "image/jpeg",
          data: img[:blob]
        } }
      end
    end
    current_turn
  end
end
