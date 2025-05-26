require 'active_record'

# ActiveRecord::Base.establish_connection(
#   adapter: 'postgresql',
#   database: 'telegrambot_quiz',
#   username: 'postgres',
#   password: 'your_db_password',
#   host: 'localhost'
# )

class CreateUsers < ActiveRecord::Migration[4.2]
    def change
      create_table :users, force: true do |t|
        t.integer :uid
        t.string  :username
        t.string :locale, default: 'en'
      end
    end
   end
   
# CreateUsers.migrate(:up)