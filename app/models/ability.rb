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
    can :set_email, User
    can :create_user, User
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    can :read, :all
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], user: user

    can :destroy, Attachment, attachable: { user: user }

    can [:set_best], Answer, question: { user: user }

    can [:rating_up, :rating_down], Votable do |votable|
      votable.user != user && votable.votes.where(user: user).blank?
    end

    can [:cancel_vote], Votable do |votable|
      votable.votes.where(user: user).present?
    end
  end
end
