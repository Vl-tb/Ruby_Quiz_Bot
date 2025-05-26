require_relative "../lib/load_libraries"


config = AppConfigurator.new
config.configure

token = config.get_token
logger = config.get_logger

engine = QuizBot::EngineBot.new(token: token, logger: logger)
engine.run
