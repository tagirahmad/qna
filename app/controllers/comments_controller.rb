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
    if params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    elsif params[:question_id]
      @commentable = Question.find(params[:question_id])
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
    @comment.commentable_type.to_sym == :Answer ? @comment.commentable.question : @comment.commentable
  end
end
