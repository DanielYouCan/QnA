class Authorization < ApplicationRecord
  belongs_to :user
  scope :by_provider, -> (provider, uid) { where(provider: provider, uid: uid.to_s) }

  def set_confirmed!
    self.update!(confirmed: true)
    self.update!(confirmation_token: nil)
  end

  def send_confirmation
    set_confirmation_token
    AuthorizationMailer.email_confirmation(self).deliver
  end

  private

  def set_confirmation_token
    return false unless confirmation_token.blank?
    token = SecureRandom.urlsafe_base64.to_s
    
    self.update!(confirmation_token: token)
  end
end
