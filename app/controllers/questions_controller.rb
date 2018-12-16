class QuestionsController < ApplicationController
  attr_reader :current_user
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :authenticate_request, only: [:create, :update, :delete]

  # GET /questions
  def index
    options = {}
    case params["sort"]
      when "latest"
        @questions = Question.all.order(:created_at).limit(50).reverse
      when "pending_first"
        @questions = Question.all.order(:status,:created_at).limit(50)
      when "needing_help"
        @questions = Question.all.where(status: false).order(:created_at).limit(50).reverse
      else
        @questions = Question.all.order(:created_at).limit(50).reverse
    end
    options[:complete] = false
    json_string = QuestionSerializer.new(@questions).serialized_json
    render json: json_string
  end

  # GET /questions/1
  def show
    options = {}
    options[:params] = {for_show: true}
    if params['include_answers']
      options[:include] = [:answers]
      options[:params].store(:complete, true)
    end
    json_string = QuestionSerializer.new([@question], options).serialized_json
    render json: json_string
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      render json: @question, status: :created, location: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
  end
  
  # GET /questions/1/answers
  def answers
    @question = Question.find(params[:question_id])
    render json: @question.answers
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.require(:question).permit(:title, :description, :status, :user_id)
    end

    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
end
