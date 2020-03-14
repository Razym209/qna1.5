class AnswersController < ApplicationController
   include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: %w[edit update destroy]
  before_action :load_question, only: %w[create]

  after_action :publish_answer, only: :create
  
  def edit
  end

  def create
    @answer.author = current_user
    @answer.save
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'you successfully deleted'
    else
      flash[:notice] = 'you do not have enough rights'
    end
    redirect_to question_path(@answer.question)
  end

  private
  
  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
          "answers_of_question_#{@answer.question_id}",
          ApplicationController.render(
            partial: 'answers/answer.json',
            locals: { answer: @answer }
          )
    )
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end
end
