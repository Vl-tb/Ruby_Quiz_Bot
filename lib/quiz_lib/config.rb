require_relative 'quiz'

QuizProtsenkoVakariuk::Quiz.config do |config|
  config.yaml_dir = "quiz/yml"
  config.in_ext = "yml"
  config.answers_dir = "quiz/answers"
end
