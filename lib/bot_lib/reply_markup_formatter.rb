class ReplyMarkupFormatter
    attr_reader :array
  
    def initialize(array)
      @array = array
      # puts @array
    end


    def get_markup
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: array.map { |text| [Telegram::Bot::Types::KeyboardButton.new(text: text)] },
        resize_keyboard: true,
        one_time_keyboard: false
      )
    end

    def get_clear_markup
      Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
    end
end
  