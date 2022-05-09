# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_best_and_other_answers, only: :show
  after_action  :publish_question, only: :create

  include Voted

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new

    gon.question_id = question.id
    gon.current_user_id = current_user&.id
  end

  def new
    question.links.new
    Reward.new(question: question)
  end

  def create
    @question = Question.create(question_params.merge(user_id: current_user.id))

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if current_user.author_of?(question)
      question.update(question_params)
      flash.now[:notice] = 'The question was updated successfully.'
    end

    @question = question
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted!'
    else
      flash[:error] = 'You are not allowed delete the answer'
      redirect_to questions_path
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def find_best_and_other_answers
    @best_answer = question.best_answer
    @other_answers = question.answers.where.not(id: question.best_answer_id)
  end

  helper_method :question

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      {
        partial: ApplicationController.render(partial: 'questions/list_item', locals: { question: @question }),
        question: @question
      }
    )
  end

  def question_params
    params
      .require(:question)
      .permit(:title,
              :body,
              files: [],
              links_attributes: %i[name url id],
              reward_attributes: %i[name image])
  end
end
