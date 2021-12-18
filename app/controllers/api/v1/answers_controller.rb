# frozen_string_literal: true

module Api
  module V1
    class AnswersController < BaseController
      before_action :find_question, only: :create
      before_action :find_answer,   only: %i[update destroy]
      authorize_resource

      def index
        @answers = Answer.where(question_id: params[:question_id])
        render json: @answers
      end

      def show
        @answer = Answer.find(params[:id])
        render json: @answer
      end

      def create
        answer = @question.answers.build(answer_params.merge(user: current_user))

        if answer.save
          render json: answer
        else
          render json: { errors: answer.errors.full_messages }
        end
      end

      def update
        if @answer.update(answer_params)
          render json: @answer
        else
          render json: { errors: @answer.errors.full_messages }
        end
      end

      def destroy
        head :ok if @answer.destroy
      end

      private

      def answer_params
        params.require(:answer).permit(:title, links_attributes: %i[name url id],
                                               reward_attributes: %i[name image])
      end

      def find_question
        @question = Question.find(params[:question_id])
      end

      def find_answer
        @answer = Answer.find(params[:id])
      end
    end
  end
end
