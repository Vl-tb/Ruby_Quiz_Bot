module QuizProtsenkoVakariuk

    class Question
      attr_accessor :question_body, :question_correct_answer, :question_answers, :q_idx
  
      def initialize(raw_text, raw_answers, q_idx)
        @question_body = raw_text
        @q_idx = q_idx
        load_answers(raw_answers)
      end
  
      def display_answers
        @question_answers.map { |char, answer| "#{char}. #{answer}" }
      end
  
      def to_s
        @question_body
      end
  
      def to_h
        {
          question_body: @question_body,
          question_correct_answer: @question_correct_answer,
          question_answers: @question_answers
        }
      end
  
      def to_json(*_args)
        to_h.to_json
      end
  
      def to_yaml
        to_h.to_yaml
      end
  
      def load_answers(raw_answers)
        @question_correct_answer = raw_answers.first
        shuffled = raw_answers.shuffle(random: Random.new(@q_idx))
        @question_answers = {}
        ('A'..'Z').each_with_index do |char, i|
          break if i >= shuffled.size
          @question_answers[char] = shuffled[i]
        end
      end
  
      def find_answer_by_char(char)
        @question_answers[char.upcase]
      end

      def print_letter_correct_answer
        correct_letter = @question_answers.key(@question_correct_answer)
        "#{correct_letter}. #{@question_correct_answer}"
      end
    end
  end
  