# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: :create
  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))

    flash[:alert] = 'The comment was created successfully.' if @comment.save
  end

  private

  def find_commentable
    answer_id = params[:answer_id]
    question_id = params[:question_id]
    if answer_id
      @commentable = Answer.find(answer_id)
    elsif question_id
      @commentable = Question.find(question_id)
    end
  end

  def comment_params
    params.require(:comment).require(:comments).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "questions/#{channel.id}", {
        partial: ApplicationController.render(partial: 'comments/comment', locals: { comment: @comment }),
        comment: @comment,
        current_user_id: current_user.id
      }
    )
  end

  def channel
    comment_commentable = @comment.commentable
    @comment.commentable_type.to_sym == :Answer ? comment_commentable.question : comment_commentable
  end
end
