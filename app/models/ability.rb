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

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment],  user: user
    can :destroy, [Question, Answer, Comment], user: user

    can :mark_as_best, Answer, question: { user_id: user.id }

    can %i[vote_up vote_down unvote], [Question, Answer] do |resource|
      resource.user_id != user.id
    end

    can :destroy, Link, linkable: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
  end
end
