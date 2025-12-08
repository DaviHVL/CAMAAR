module DashboardHelper
  # Verifica se uma turma tem formulário pendente para responder
  def turma_tem_formulario_pendente?(turma, ids_respondidos)
    formulario = turma.formularios.first
    formulario.present? && !ids_respondidos.include?(formulario.id)
  end

  # Retorna o status de resposta de um formulário
  def status_formulario(formulario_id, ids_respondidos)
    if ids_respondidos.include?(formulario_id)
      'respondido'
    else
      'pendente'
    end
  end

  # Conta quantos formulários pendentes o usuário tem
  def contar_formularios_pendentes(turmas, ids_respondidos)
    turmas.count do |turma|
      turma_tem_formulario_pendente?(turma, ids_respondidos)
    end
  end

  # Formata a mensagem de status para exibição
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
