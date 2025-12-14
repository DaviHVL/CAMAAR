# Módulo auxiliar para a exibição de detalhes dos formulários nas views.
# Responsável por formatação de textos técnicos, definição de estilos visuais (CSS)
# baseados em estado e verificações de conteúdo do formulário.
module FormulariosHelper
  
  # Traduz o código técnico do tipo de resposta para um texto legível na interface.
  # Útil para mostrar ao usuário "Resposta Aberta" ao invés de "texto" ou "text_area".
  #
  # Args:
  #   - tipo (String): O identificador do tipo de resposta (ex: 'texto', 'multipla_escolha').
  #
  # Retorno:
  #   - String: O nome formatado e amigável (Human Readable).
  #
  # Efeitos Colaterais: Nenhum.
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

  # Retorna as classes CSS apropriadas para estilizar o container da pergunta
  # com base no seu tipo. Permite diferenciação visual (ex: cores diferentes)
  # entre perguntas de texto e de múltipla escolha.
  #
  # Args:
  #   - tipo (String): O identificador do tipo de resposta.
  #
  # Retorno:
  #   - String: Uma lista de classes CSS (ex: Tailwind 'bg-blue-50 ...').
  #
  # Efeitos Colaterais: Nenhum.
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

  # Verifica se um formulário específico possui perguntas associadas.
  # Utilizado para exibir mensagens de "Formulário vazio" ou ocultar botões de envio.
  #
  # Args:
  #   - formulario (Formulario): O objeto formulário a ser verificado.
  #
  # Retorno:
  #   - Boolean: true se houver pelo menos uma questão, false caso contrário.
  #
  # Efeitos Colaterais:
  #   - Realiza consulta ao banco de dados (exists?/any?) na associação questao_formularios.
  def formulario_tem_questoes?(formulario)
    formulario.questao_formularios.any?
  end
end