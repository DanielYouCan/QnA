class Authorization < ApplicationRecord
  belongs_to :user
  scope :by_provider, -> (provider, uid) { where(provider: provider, uid: uid.to_s) }

  def set_confirmed!
    Authorization.transaction do
      self.confirmed = true
      self.confirmation_token = nil
      save!
    end
  end

  def send_confirmation
    set_confirmation_token
    AuthorizationMailer.email_confirmation(self).deliver
  end

  private

  def set_confirmation_token
    return false unless confirmation_token.blank?
    Authorization.transaction do
      self.confirmation_token = SecureRandom.urlsafe_base64.to_s
      save!
    end
  end
end
