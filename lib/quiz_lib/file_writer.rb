module QuizProtsenkoVakariuk
    class FileWriter
      def initialize(mode, filename)
        @answers_dir = QuizProtsenkoVakariuk::Quiz.answers_dir
        @filename = prepare_filename("#{filename}.txt")
        @mode = mode
      end
  
      def write(message)
        File.open(@filename, @mode) { |f| f.puts message }
      end
  
      def prepare_filename(filename)
        File.join(@answers_dir, filename)
      end
    end
  end
  