class Usuario < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :matricula, presence: true, uniqueness: true
  validates :nome, presence: true
  validates :ocupacao, presence: true

  has_many :usuario_turmas
  has_many :turmas, through: :usuario_turmas

  has_many :formulario_respondidos
  has_many :templates

  def generate_password_reset_token!
    token = SecureRandom.urlsafe_base64
    update_columns(reset_digest: BCrypt::Password.create(token), reset_sent_at: Time.zone.now)
    token 
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
end