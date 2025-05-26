module QuizProtsenkoVakariuk
    class InputReader
      def read(welcome_message: nil, validator: nil, error_message: nil, process: nil)
        puts welcome_message if welcome_message
        input = gets.chomp
        
        if validator && !validator.call(input)
          puts error_message if error_message
          return read(welcome_message: welcome_message, validator: validator, error_message: error_message, process: process)
        end
        input = process.call(input) if process

        input
      end
    end
  end
  