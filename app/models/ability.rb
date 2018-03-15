class Ability
  include CanCan::Ability

  attr_reader :user, :question

  def initialize(user, opts = {})
    @user = user
    @question = opts[:question] if opts[:question]

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def common_abilities
    can :read, :all
  end

  def guest_abilities
    common_abilities
    can :set_email, User
    can :create_user, User
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    common_abilities
    can :me, User
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], user_id: user.id

    can :destroy, Attachment, attachable: { user_id: user.id }

    can [:set_best], Answer, best: false, question: { user_id: user.id }

    can [:rating_up, :rating_down], Votable do |votable|
      !user.author_of?(votable) && votable.votes.where(user: user).blank?
    end

    can [:cancel_vote], Votable do |votable|
      votable.votes.where(user: user).present?
    end

    can :create, Subscribe unless user.subscribed_to_question?(question)

    can :destroy, Subscribe if user.subscribed_to_question?(question)
  end
end
