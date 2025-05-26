require 'singleton'

module QuizProtsenkoVakariuk
  class Quiz
    include Singleton

    class << self
      attr_accessor :yaml_dir, :in_ext, :answers_dir

      def config
        yield self
      end
    end
  end
end
