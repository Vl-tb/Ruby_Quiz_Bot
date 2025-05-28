require 'active_record'

class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users, force: true do |t|
      t.integer :uid
      t.string  :username
      t.string :locale, default: 'en'
    end
  end
end
