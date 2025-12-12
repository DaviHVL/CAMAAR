# Encapsula toda a lógica relacionada à redefinição de senha segura.
# Permite que o model Usuario foque apenas em identidade e validações.
module PasswordResetable
  extend ActiveSupport::Concern

  def send_password_reset_email
    token = create_reset_digest
    UserMailer.password_reset(self, token).deliver_now
  end

  def clear_reset_digest
    update_columns(reset_digest: nil, reset_sent_at: nil)
  end

  def valid_reset_token?(token)
    return false unless reset_digest
    return false if password_reset_expired?

    BCrypt::Password.new(reset_digest).is_password?(token)
  end

  private

  def create_reset_digest
    token = SecureRandom.urlsafe_base64
    update_columns(reset_digest: BCrypt::Password.create(token), reset_sent_at: Time.zone.now)
    token
  end

  def password_reset_expired?
    return true unless reset_sent_at

    reset_sent_at < 2.hours.ago
  end
end