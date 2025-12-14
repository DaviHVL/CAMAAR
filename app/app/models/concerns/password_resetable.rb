# Encapsula toda a lógica relacionada à redefinição de senha segura.
# Permite que o model Usuario foque apenas em identidade e validações.
module PasswordResetable
  extend ActiveSupport::Concern

  # Gera um novo token de redefinição, salva o hash no banco e envia o e-mail ao usuário.
  #
  # Args: Nenhum
  # Retorno: Objeto Mail (resultado do deliver_now).
  # Efeitos Colaterais:
  #   - Atualiza colunas reset_digest e reset_sent_at no banco de dados.
  #   - Dispara um e-mail via SMTP/Provider.
  def send_password_reset_email
    token = create_reset_digest
    UserMailer.password_reset(self, token).deliver_now
  end

  # Limpa os dados de redefinição de senha após o uso bem-sucedido.
  # Previne que o mesmo link seja usado duas vezes (ataque de replay).
  #
  # Args: Nenhum
  # Retorno: Boolean (resultado da atualização).
  # Efeitos Colaterais: Define reset_digest e reset_sent_at como nil no banco.
  def clear_reset_digest
    update_columns(reset_digest: nil, reset_sent_at: nil)
  end

  # Verifica se o token fornecido é válido e se a solicitação não expirou.
  #
  # Args:
  #   - token (String): O token recebido via parâmetro na URL (texto plano).
  # Retorno: Boolean (true se válido e não expirado, false caso contrário).
  # Efeitos Colaterais: Nenhum.
  def valid_reset_token?(token)
    return false unless reset_digest
    return false if password_reset_expired?

    BCrypt::Password.new(reset_digest).is_password?(token)
  end

  private

  # Gera um token aleatório seguro, cria o hash BCrypt e salva no banco.
  #
  # Args: Nenhum
  # Retorno: String (O token em texto plano para ser enviado por email).
  # Efeitos Colaterais: Persiste o hash e o timestamp no banco de dados (update_columns).
  def create_reset_digest
    token = SecureRandom.urlsafe_base64
    update_columns(reset_digest: BCrypt::Password.create(token), reset_sent_at: Time.zone.now)
    token
  end

  # Verifica se o prazo de validade do token (2 horas) já passou.
  #
  # Args: Nenhum
  # Retorno: Boolean (true se expirado ou sem data, false se válido).
  # Efeitos Colaterais: Nenhum.
  def password_reset_expired?
    return true unless reset_sent_at

    reset_sent_at < 2.hours.ago
  end
end