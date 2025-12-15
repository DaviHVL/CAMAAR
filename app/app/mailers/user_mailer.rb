# Responsável pelo envio de e-mails transacionais relacionados à conta do usuário.
# Gerencia as notificações de sistema, como a recuperação de senha.
class UserMailer < ApplicationMailer
  
  # Prepara o e-mail de redefinição de senha para ser enviado ao usuário.
  # O corpo do e-mail conterá o link com o token necessário para autorizar a troca.
  #
  # Args:
  #   - user (Usuario): O objeto do usuário que solicitou a recuperação.
  #   - token (String): O token de segurança (em texto plano) gerado no model.
  #
  # Retorno:
  #   - Mail::Message: O objeto de e-mail construído, configurado e pronto para entrega.
  #
  # Efeitos Colaterais:
  #   - Renderiza o template de view associado (views/user_mailer/password_reset).
  #   - Define as variáveis de instância @user e @token disponíveis para o template.
  def password_reset(user, token)
    @user = user
    @token = token

    mail to: user.email, subject: "Redefinição de Senha - CAMAAR"
  end
end