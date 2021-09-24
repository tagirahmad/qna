# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def index
    question.answers.order(created_at: :desc)
  end

  def mark_as_best
    @old_best_answer = question.best_answer
    answer.mark_as_best if current_user.author_of?(answer)
    @answer = answer
  end

  def create
    @answer = question.answers.create(answer_params.merge(user_id: current_user.id))
    flash[:alert] = 'Answer successfully created!'
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:alert] = 'Answer successfully deleted!'
    else
      flash[:error] = 'You are not allowed delete the answer'
    end
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
      flash.now[:notice] = 'The answer was updated successfully.'
    end

    @answer = answer
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer
  helper_method :question

  def question
    Question.find(params[:question_id] || answer.question_id)
  end

  def answer_params
    params.require(:answer).permit(:title)
  end
end
