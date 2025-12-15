# Módulo auxiliar para a lógica de apresentação do Dashboard do usuário (Aluno/Professor).
# Centraliza verificações de status de formulários e contagem de pendências para manter as views limpas.
module DashboardHelper
  
  # Verifica se existe uma avaliação disponível para a turma que ainda não foi respondida pelo aluno.
  # Utiliza o primeiro formulário associado à turma como base para a verificação.
  #
  # Args:
  #   - turma (Turma): O objeto da turma a ser verificado.
  #   - ids_respondidos (Array<Integer>): Lista de IDs dos formulários que o usuário atual já respondeu.
  #
  # Retorna:
  #   - Boolean: true se houver um formulário presente e não respondido, false caso contrário.
  #
  # Efeitos Colaterais: Nenhum (apenas leitura de dados).
  def turma_tem_formulario_pendente?(turma, ids_respondidos)
    formulario = turma.formularios.first
    formulario.present? && !ids_respondidos.include?(formulario.id)
  end

  # Determina o estado atual de um formulário específico com base no histórico do usuário.
  #
  # Args:
  #   - formulario_id (Integer): O ID do formulário a ser verificado.
  #   - ids_respondidos (Array<Integer>): Lista de IDs de formulários já submetidos pelo usuário.
  #
  # Retorna:
  #   - String: 'respondido' (se o ID estiver na lista) ou 'pendente' (caso contrário).
  #
  # Efeitos Colaterais: Nenhum.
  def status_formulario(formulario_id, ids_respondidos)
    if ids_respondidos.include?(formulario_id)
      'respondido'
    else
      'pendente'
    end
  end

  # Calcula o número total de avaliações que o aluno ainda precisa responder.
  # Útil para exibir contadores de notificação ou badges no painel.
  #
  # Args:
  #   - turmas (ActiveRecord::Relation | Array): Coleção de turmas em que o aluno está matriculado.
  #   - ids_respondidos (Array<Integer>): Lista de IDs de formulários já respondidos.
  #
  # Retorna:
  #   - Integer: A quantidade de turmas com formulários pendentes.
  #
  # Efeitos Colaterais: Itera sobre a coleção de turmas.
  def contar_formularios_pendentes(turmas, ids_respondidos)
    turmas.count do |turma|
      turma_tem_formulario_pendente?(turma, ids_respondidos)
    end
  end

  # Traduz o código de status técnico para uma mensagem legível (human-readable) na interface.
  #
  # Args:
  #   - status (String): O código de status ('respondido', 'pendente', etc.).
  #
  # Retorna:
  #   - String: O texto formatado para exibição (ex: "Avaliação Respondida").
  #   - String: "Status Desconhecido" caso o argumento não corresponda a nenhum caso.
  #
  # Efeitos Colaterais: Nenhum.
  def mensagem_status_formulario(status)
    case status
    when 'respondido'
      'Avaliação Respondida'
    when 'pendente'
      'Avaliação Pendente'
    else
      'Status Desconhecido'
    end
  end
end