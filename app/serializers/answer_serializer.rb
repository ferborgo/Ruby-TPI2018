class AnswerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :content
  belongs_to :question
  belongs_to :user
end
