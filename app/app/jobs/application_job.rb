# Classe base abstrata para todos os Jobs (tarefas em segundo plano) da aplicação.
# Centraliza configurações comuns, como estratégias de retentativa (retry)
# e tratamento de erros de serialização, que serão herdadas por todos os workers.
#
# Embora não tenha métodos ativos no momento, serve como ponto de extensão
# para configurações globais do ActiveJob.
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end