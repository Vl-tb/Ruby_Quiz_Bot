require 'rubygems'
require 'bundler/setup'
require 'pg'
require 'active_record'
require 'yaml'

namespace :db do
  desc 'Migrate the database'
  task :migrate do
    connection_details = YAML::load(File.open("config/database.yml"))
    p connection_details
    if connection_details.fetch('active') == "sqlite"
      ActiveRecord::Base.establish_connection(connection_details.fetch('sqlite'))
    else
      ActiveRecord::Base.establish_connection(connection_details.fetch('postgresql'))
    end
    puts ActiveRecord.version.version
    ActiveRecord::MigrationContext.new("db/migrate/").migrate
  end

  desc 'Create the database'
  task :create do
    connection_details = YAML::load(File.open('config/database.yml'))
    if connection_details.fetch('active') == "sqlite"
      connection_details = connection_details.fetch('sqlite')
      ActiveRecord::Base.establish_connection(connection_details)
      ActiveRecord::Base.connection.execute("SELECT sqlite_version();")
    else # postgresql
      connection_details = connection_details.fetch('postgresql')
      admin_connection = connection_details.merge({'database'=> 'postgres',
                                                'schema_search_path'=> 'public'})
      ActiveRecord::Base.establish_connection(admin_connection)
      ActiveRecord::Base.connection.create_database(connection_details.fetch('database'))
    end
  end

  desc 'Drop the database'
  task :drop do
    connection_details = YAML::load(File.open('config/database.yml'))
    if connection_details.fetch('active') == "sqlite"
      db_path = connection_details.fetch('sqlite').fetch('database')
      if File.exist?(db_path)
        File.delete(db_path)
      end
    else
      connection_details = connection_details.fetch('postgresql')
      admin_connection = connection_details.merge({'database'=> 'postgres',
                                                'schema_search_path'=> 'public'})
      ActiveRecord::Base.establish_connection(admin_connection)
      ActiveRecord::Base.connection.drop_database(connection_details.fetch('database'))
    end
  end
end
