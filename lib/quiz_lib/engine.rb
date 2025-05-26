module QuizProtsenkoVakariuk
    class Engine
      attr_reader :question_collection, :statistics

      def initialize(user_name)
        QuizProtsenkoVakariuk::Quiz.config do |q|
          # q.yaml_dir = File.expand_path("../../config/quiz_yml/", __dir__)
          q.yaml_dir = [
            File.expand_path('../../config/quiz_yml/en', __dir__),
            File.expand_path('../../config/quiz_yml/ua', __dir__)
          ]
          q.in_ext = "yaml"
          q.answers_dir = File.expand_path("../../quiz_answers/", __dir__)
        end
        @question_collection = QuestionData.new
        @question_collection.save_to_yaml('questions_out.yaml')
        @question_collection.save_to_json('questions_out.json')
  
        # @input_reader = InputReader.new
        @user_name = user_name
        @current_time = Time.now.strftime("%Y%m%d_%H%M%S")
        @writer = FileWriter.new("w", "#{@user_name}_#{@current_time}")
        @statistics = Statistics.new(@writer)
      end
      
      def get_question(index)
        question = @question_collection.collection[I18n.locale.to_s][index]
       
        return nil unless question
        # puts question.to_s
        {
          text: question.to_s,
          options: question.display_answers,
          correct_answer: question.question_correct_answer,
          question_answers: question.question_answers,
          correct_answer_letter: question.print_letter_correct_answer
        }
      end

      # def run
      #   @question_collection.collection.each do |question|
      #     # puts "\n#{question}"
      #     question.display_answers.each { |ans| puts ans }
      #     user_answer = get_answer_by_char(question)
      #     correct = question.question_correct_answer
      #     check(user_answer, correct)
      #   end
      #   @statistics.print_report
      # end
  
      def check(user_answer, correct_answer, options, old_answer)
        # puts user_answer
        # puts correct_answer
        # puts options
        if user_answer == correct_answer
          @writer.write("Correct: #{user_answer}")
          if old_answer.nil?
            @statistics.correct_answer
            
          elsif old_answer == false
            @statistics.false_to_true
          end
          puts @statistics.print_report
          true
      
        elsif !options.include?(user_answer)
          @writer.write("Invalid answer: #{user_answer} is not in options")
          nil

        else
          @writer.write("Incorrect: #{user_answer} (Correct: #{correct_answer})")
          if old_answer.nil?
            @statistics.incorrect_answer
            
          elsif old_answer == true
            @statistics.true_to_false
          end
          puts @statistics.print_report
          false
        end
      end
  
      def get_answer_by_char(question)
        @input_reader.read(
          welcome_message: "Your answer:",
          validator: ->(input) { !input.empty? },
          process: ->(input) { question.find_answer_by_char(input[0]) },
          error_message: "Please enter a valid answer character"
        )
      end
    end
  end
  