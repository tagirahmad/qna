module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable,     only: %i[vote_up vote_down unvote]
    before_action :validate_votable, only: %i[vote_up vote_down unvote]
  end

  def vote_up
    @votable.vote_up(current_user)
    success
  end
  
  def vote_down
     @votable.vote_down(current_user)
     success
  end

   def unvote
    @votable.unvote(current_user)
    success
  end 

   private

   def validate_votable
     error('Author can not vote') if current_user.author_of?(@votable)
   end

   def success
     render json: {
       id:    @votable.id,
       name:  @votable.class.name.underscore,
       score: @votable.votes_score
     }
   end

   def error(message)
     render json: { message: message }, status: :forbidden
   end

   def find_votable
     @votable = klass_model.find(params[:id])
   end

   def klass_model
     controller_name.classify.constantize
   end
end
