class User < ActiveRecord::Base
  has_many :quiz_tests, dependent: :destroy
end
