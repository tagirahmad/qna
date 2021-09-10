# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params.merge(user_id: current_user.id))

    if @answer.save
      redirect_to question, notice: 'The answer was created successfully.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:alert] = 'Answer successfully deleted!'
    else
      flash[:error] = 'You are not allowed delete the answer'
    end

    redirect_to @answer.question
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer
  helper_method :question

  def question
    Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:title)
  end
end
