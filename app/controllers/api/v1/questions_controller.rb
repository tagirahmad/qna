# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < BaseController
      before_action :question, except: :create

      authorize_resource

      def index
        render json: Question.all
      end

      def show
        render json: @question, serializer: QuestionSerializer
      end

      def create
        question = Question.new(question_params.merge(user: current_user))

        if question.save
          render json: question
        else
          render json: { errors: question.errors.full_messages }
        end
      end

      def update
        if @question.update(question_params)
          render json: @question
        else
          render json: { errors: @question.errors.full_messages }
        end
      end

      def destroy
        head :ok if @question.destroy
      end

      private

      def question_params
        params.require(:question).permit(:title, :body, links_attributes: %i[name url id],
                                                        reward_attributes: %i[name image])
      end

      def question
        question_id = params[:id]
        @question ||= question_id ? Question.with_attached_files.find(question_id) : Question.new
      end
    end
  end
end
