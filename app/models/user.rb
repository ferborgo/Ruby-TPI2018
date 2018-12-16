class User < ApplicationRecord
	validates :email, :username, uniqueness: true
	validates :email, :username, :screen_name, :password, presence: true
	has_many :questions
	has_many :answers
end
