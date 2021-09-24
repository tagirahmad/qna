# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @best_answer = question.best_answer
    @other_answers = question.answers.where.not(id: question.best_answer_id)
  end

  def new; end

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
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
