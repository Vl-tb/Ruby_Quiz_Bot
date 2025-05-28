module QuizProtsenkoVakariuk
    class Statistics
      attr_reader :correct_answers
      attr_reader :incorrect_answers

      def initialize(writer)
        @correct_answers = 0
        @incorrect_answers = 0
        @writer = writer
      end
  
      def correct_answer
        @correct_answers += 1
      end
  
      def incorrect_answer
        @incorrect_answers += 1
      end

      def false_to_true
        @correct_answers += 1
        @incorrect_answers -= 1
      end

      def true_to_false
        @correct_answers -= 1
        @incorrect_answers += 1
      end

      def total
        return @correct_answers + @incorrect_answers
      end

      def percent
        return total.zero? ? 0 : (@correct_answers.to_f / total * 100).round(2)
      end
      
      def print_report
        # report = "Correct: #{@correct_answers}, Incorrect: #{@incorrect_answers}, Success Rate: #{percent}%"
        report = I18n.t(
          :report_message,
          correct: @correct_answers,
          incorrect: @incorrect_answers,
          rate: percent
        )
        @writer.write(report)
        return report
      end
    end
  end
  