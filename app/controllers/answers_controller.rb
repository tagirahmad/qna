# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :answer
  after_action :publish_answer, only: %i[create]

  include Voted

  authorize_resource

  def mark_as_best
    @old_best_answer = question.best_answer
    answer.mark_as_best if current_user.author_of?(answer.question)
  end

  def create
    @answer = question.answers.build(answer_params.merge(user_id: current_user.id))
    if @answer.save
      flash[:alert] = 'Answer successfully created!'
    else
      render nothing: true, status: :unprocessable_entity
    end
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
    return unless current_user.author_of?(answer) && answer.update(answer_params)

    flash.now[:notice] = 'The answer was updated successfully.'
  end

  private

  def answer
    answer_id = params[:id]
    @answer ||= answer_id ? Answer.with_attached_files.find(answer_id) : Answer.new
  end

  helper_method :answer, :question

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{params[:question_id]}/answers", {
        partial: ApplicationController.render(
          partial: 'answers/non_author_answer',
          locals: { answer: @answer }
        ),
        current_user_id: current_user.id
      }
    )
  end

  def question
    Question.find(params[:question_id] || answer.question_id)
  end

  def answer_params
    params.require(:answer).permit(:title, files: [], links_attributes: %i[name url id])
  end
end
