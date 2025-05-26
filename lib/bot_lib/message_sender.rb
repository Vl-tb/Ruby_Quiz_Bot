class MessageSender
  attr_reader :bot
  attr_reader :text
  attr_reader :chat
  attr_reader :answers
  attr_reader :logger
  attr_reader :clear

  def initialize(options)
    @bot = options[:bot]
    @text = options[:text]
    @chat = options[:chat]
    @answers = options[:answers]
    @clear = options[:clear]
    @logger = AppConfigurator.new.get_logger
  end

  def send
    if reply_markup
      bot.api.send_message(chat_id: chat.id, text: text, reply_markup: reply_markup)
    else
      bot.api.send_message(chat_id: chat.id, text: text)
    end

    logger.debug "sending '#{text}' to #{chat.username}"
  end

  private

  def reply_markup
    if answers
      ReplyMarkupFormatter.new(answers).get_markup
    elsif clear == true
      ReplyMarkupFormatter.new(clear).get_clear_markup
    end

  end
end