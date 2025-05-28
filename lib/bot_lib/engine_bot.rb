module QuizBot
  class EngineBot
    attr_accessor :user_engines, :user_progress

    def initialize(token: nil, logger: nil)
        @token = token || AppConfigurator.new.get_token
        @logger = logger || AppConfigurator.new.get_logger

        @user_engines = {}    # user_id => Engine instance
        @user_progress = {}   # user_id => { question_index => true/false/nil }
    end

    def run
        Telegram::Bot::Client.run(@token) do |bot|
            # updates = bot.api.get_updates
            # update_id = updates.last.update_id
            # bot.api.get_updates(offset: update_id + 1)
            bot.listen do |message|
                responder = MessageResponder.new(bot: bot, message: message, engine_bot: self)
                case message
                when Telegram::Bot::Types::Message
                  responder.respond
                # when Telegram::Bot::Types::CallbackQuery
                #   responder.respond_button
                end
            end
        end
    end
  end
end
    