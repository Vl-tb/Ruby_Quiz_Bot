class DatabaseConnector
  class << self
    def establish_connection
      ActiveRecord::Base.logger = Logger.new(active_record_logger_path)

      config = YAML::load(IO.read(database_config_path))
      if config.fetch('active') == "sqlite"
        config = config.fetch('sqlite')
      else
        config = config.fetch('postgresql')
      end
      ActiveRecord::Base.establish_connection(config)
    end

    private

    def active_record_logger_path
      'log/debug.log'
    end

    def database_config_path
      'config/database.yml'
    end
  end
end