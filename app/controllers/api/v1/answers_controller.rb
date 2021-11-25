module Api
  module V1
    class AnswersController < BaseController
      def index
        @answers = Answer.where(question_id: params[:question_id])
        render json: @answers
      end

      def show
        @answer = Answer.find(params[:id])
        render json: @answer
      end
    end
  end
end

