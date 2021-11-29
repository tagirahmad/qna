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

      def create
        answer = Answer.new(answer_params.merge(user: current_resource_owner))

        if answer.save
          render json: answer
        else
          render json: { errors: answer.errors.full_massages }
        end
      end

      def answer_params
        params.require(:answer).permit(:title, links_attributes: %i[name url id],
                                         reward_attributes: %i[name image])
      end
    end
  end
end

