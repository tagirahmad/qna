module Api
  module V1
    class QuestionsController < BaseController
      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        render json: Question.with_attached_files.find(params[:id]), serializer: QuestionSerializer
      end
    end
  end
end
