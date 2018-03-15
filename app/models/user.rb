class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy
  has_many :subscribes, dependent: :destroy

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[facebook twitter]

  validates :username, presence: true, uniqueness: true, length: { minimum: 5 }

  def author_of?(item)
    id == item.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.by_provider(auth.provider, auth.uid).first
    return authorization.user if authorization

    email = auth.info[:email]
    return User.new if email.blank?

    user = User.where(email: email).first
    user ? user.create_authorization(auth) : user = create_user!(auth, email)

    user
  end

  def self.create_user_for_network!(params, session)
    return false unless params[:email].present?
    user = User.where(params).first
    auth = OmniAuth::AuthHash.new(session)
    return user.create_unconfirmed_authorization(auth) if user

    email = params[:email]
    create_user!(auth, email)
  end

  def create_unconfirmed_authorization(auth)
    authorization = self.create_authorization(auth, unconfirmed: true)
    authorization.send_confirmation
  end

  def create_authorization(auth, opts = {})
    return self.authorizations.create(provider: auth.provider, uid: auth.uid, confirmed: false) if opts[:unconfirmed]
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def has_confirmed_authorization?(provider, uid)
    authorizations.by_provider(provider, uid).first.confirmed?
  end

  def subscribed_to_question?(question)
    subscribes.by_question(question).present?
  end

  private

  def self.create_user!(auth, email)
    user = User.new

    User.transaction do
      password = Devise.friendly_token[0, 20]
      username = auth.info[:nickname] || auth.info[:name]
      user = User.create!(email: email, password: password, password_confirmation: password, username: username)
      user.create_authorization(auth)
    end

    user
  end

end
