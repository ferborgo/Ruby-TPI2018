class QuestionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :status
  attributes :created_at, :updated_at,:answer_id, :user_id, if: Proc.new { |record, params| params && params[:for_show] == true }
  has_many :answers, if: Proc.new { |record, params| params && params[:complete] == true }
  belongs_to :user, if: Proc.new { |record, params| params && params[:complete] == true }

  attribute :number_of_answers do |question|
    question.answers.count
  end

  attribute :description do |question|
  	question.description.truncate(120)
  end

end