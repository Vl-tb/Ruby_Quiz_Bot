require 'yaml'
require 'json'

module QuizProtsenkoVakariuk
  class QuestionData
    attr_accessor :collection

    def initialize
      # @collection = []
      @collection = Hash.new { |h, k| h[k] = [] }
      @yaml_dir = QuizProtsenkoVakariuk::Quiz.yaml_dir
      @in_ext = QuizProtsenkoVakariuk::Quiz.in_ext
      @threads = []
      # puts @yaml_dir
      load_data
    end

    # def to_yaml
    #   @collection.map(&:to_h).to_yaml
    # end
    def to_yaml
      @collection.transform_values { |questions| questions.map(&:to_h) }.to_yaml
    end

    def save_to_yaml(filename)
      # puts filename
      # puts prepare_filename(filename)
      File.write(prepare_filename(filename), to_yaml)
    end

    # def to_json
    #   @collection.map(&:to_h).to_json
    # end
    def to_json
      @collection.transform_values { |questions| questions.map(&:to_h) }.to_json
    end

    def save_to_json(filename)
      File.write(prepare_filename(filename), to_json)
    end

    def prepare_filename(filename)
      File.expand_path(filename, __dir__)
    end

    # def each_file
    #   Dir.glob(File.join(@yaml_dir, "*.#{@in_ext}")) { |f| yield f }
    # end
    def each_file_in_locale
      @yaml_dir.each do |locale_dir|
        locale = File.basename(locale_dir)
        files = Dir.glob(File.join(locale_dir, "*.#{@in_ext}"))
        
        files.each_with_index do |file, index|
          yield locale, file, index
        end
      end
    end

    def in_thread(&block)
      @threads << Thread.new(&block)
    end

    def load_data
      each_file_in_locale do |locale, file, index|
        in_thread { load_from(file, locale, index) }
      end
      @threads.each(&:join)
    end

    def load_from(filename, locale, index)
      data = YAML.load_file(filename)
      data.each do |item|
        question = item['question']
        answers = item['answers']
        @collection[locale][index] = Question.new(question, answers, index)
      end
    end
  end
end
