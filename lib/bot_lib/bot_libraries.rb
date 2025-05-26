require 'logger'
require 'active_record'
require 'telegram/bot'


require_relative '../../models/user'
require_relative '../../db/migrate/001_create_users.rb'
require_relative 'app_configurator'
require_relative 'database_connector'
require_relative 'engine_bot'
require_relative 'message_sender'
require_relative 'message_responder'
require_relative 'quiz_bot'
require_relative 'reply_markup_formatter'