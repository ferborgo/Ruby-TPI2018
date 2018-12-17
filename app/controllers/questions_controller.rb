class QuestionsController < ApplicationController
  attr_reader :current_user
  before_action :set_question, only: [:show, :update, :destroy, :resolve]
  before_action :authenticate_request, only: [:create, :update, :destroy, :create_answer, :delete_answer]
  before_action :owns_the_question, only: [:destroy, :resolve, :update]

  # GET /questions
  def index
    options = {}
    case params["sort"]
      when "latest"
        @questions = Question.all.order(created_at: :desc).limit(50)
      when "pending_first"
        @questions = Question.all.order(:status,created_at: :desc).limit(50)
      #Terminar needing help. Falta que ordene por cant de answers.
      when "needing_help"
        @questions = Question.all.where(status: false).limit(50)
      else
        @questions = Question.all.order(created_at: :desc).limit(50)
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
    params = question_params
    params[:user_id] = @current_user.id
    params[:status] = false
    @question = Question.new(params)
    json_string = QuestionSerializer.new(@question)
    if @question.save
      render json: json_string, status: :created, location: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      render json: @question, status: :ok
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1
  def destroy
    if (@question.answers.count > 0)
      #405 Method Not Allowed
      render json: { error: 'A questions cannot be deleted if it has answers' }, status: 405
    else
      @question.destroy
    end
  end
  
  # GET /questions/1/answers
  def answers
    @question = Question.find(params[:question_id])
    json_string = AnswerSerializer.new(@question.answers)
    render json: json_string, status: :ok
  end

  # PUT /questions/:id/resolve
  def resolve
    begin
      if @question.answers.include?(Answer.find(params[:answer_id]))
        @question.status = true
        @question.answer_id = params[:answer_id]
        @question.save
        render json: @question, status: :ok
      else
        render json: { error: 'The answer must belong to the question' }, status: 400
      end 
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'The answer could not be found' }, status: 404
    end
  end

  def owns_the_question
    authenticate_request
    if @current_user
      if (@question.user_id != @current_user.id)
        render json: { error: 'Not Authorized' }, status: 401
      end
    end
  end

  # post /questions/:question_id/answers
  def create_answer
    question = Question.find(params[:question_id])
    if not question.status
      param = {}
      param[:question_id] = params[:question_id]
      param[:user_id] = @current_user.id
      param[:content] = params[:content] 
      Answer.create(param)
    else
      render json: { error: 'Questions that are already resolved cannot receive new answers'}, status: :unprocessable_entity
    end
  end

  # delete /questions/:question_id/answers/:id
  def delete_answer
    answer = Answer.find(params[:id])
    if answer.user_id == @current_user.id
      question = Question.find(params[:question_id])
      if (question.answers.include?(answer))
        if question.answer_id == answer.id
          render json: { error: 'The answer cannot be deleted because it has been selected as the correct one'}, status: :unprocessable_entity
        else
          answer.destroy
        end
      else
        render json: { error: 'The answer must belong to the question' }, status: 400
      end
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
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
