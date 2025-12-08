module FormulariosHelper
  # Formata o tipo de resposta para exibição amigável
  def formato_tipo_resposta(tipo)
    case tipo
    when 'texto'
      'Resposta Aberta'
    when 'multipla_escolha'
      'Múltipla Escolha'
    else
      tipo.humanize
    end
  end

  # Retorna uma classe CSS baseada no tipo de resposta
  def classe_tipo_resposta(tipo)
    case tipo
    when 'texto'
      'bg-blue-50 border-blue-200'
    when 'multipla_escolha'
      'bg-purple-50 border-purple-200'
    else
      'bg-gray-50 border-gray-200'
    end
  end

  # Verifica se um formulário tem questões
  def formulario_tem_questoes?(formulario)
    formulario.questao_formularios.any?
  end
end
