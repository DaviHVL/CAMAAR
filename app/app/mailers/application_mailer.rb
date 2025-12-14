# Classe base para todos os disparadores de e-mail (Mailers) da aplicação.
# Centraliza configurações comuns, como o remetente padrão e o layout visual,
# garantindo consistência em todas as comunicações enviadas pelo sistema.
class ApplicationMailer < ActionMailer::Base
  # Define o remetente padrão ("From") para todos os e-mails.
  # Este valor será usado caso um mailer específico não defina um remetente próprio.
  default from: "from@example.com"

  # Define o arquivo de layout base (geralmente app/views/layouts/mailer.html.erb)
  # que envolverá o corpo de todos os e-mails, aplicando estilos e estruturas comuns.
  layout "mailer"
end