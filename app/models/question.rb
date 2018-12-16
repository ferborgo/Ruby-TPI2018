class Question < ApplicationRecord
	validates :title, :description, :status, :user_id, presence: true
	has_many :answers
	belongs_to :user
end
