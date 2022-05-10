# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  # rubocop:disable Metrics/AbcSize
  def user_abilities
    user_id = user.id

    guest_abilities

    can :me, User, id: user_id

    can :create,  [Question, Answer, Comment, Subscription]
    can :update,  [Question, Answer, Comment], user_id: user_id
    can :destroy, [Question, Answer, Comment, Subscription], user_id: user_id

    can :mark_as_best, Answer, question: { user_id: user_id }

    can(%i[vote_up vote_down unvote], [Question, Answer]) { |resource| !user.author_of?(resource) }
    can(:unvote, [Question, Answer]) { |resource| user.author_of?(resource) }

    can :destroy, Link, linkable: { user_id: user_id }
    can :destroy, ActiveStorage::Attachment, record: { user_id: user_id }
  end
end
