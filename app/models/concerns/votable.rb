module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    make_vote(user, 1)
  end

  def vote_down(user)
    make_vote(user, -1)
  end

  def unvote(user)
    votes.where(user_id: user).delete_all
  end

  def votes_score
    votes.sum(:value)
  end

  private

  def make_vote(user, value)
    vote = votes.find_or_initialize_by(user_id: user.id)

    unless vote.not_votable_author?
      vote.value = value
      vote.save!
    end
    
    return
  end
end
