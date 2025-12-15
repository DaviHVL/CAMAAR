# Service Object responsável por clonar a estrutura de um Template e distribuí-lo
# para múltiplas turmas na forma de formulários independentes.
#
# Encapsula a lógica de "Deep Copy" (cópia profunda) de Template -> Formulario,
# garantindo que cada turma tenha sua própria instância de avaliação.
class FormDistributionService
  
  # Inicializa o serviço com os dados necessários para a distribuição.
  #
  # Args:
  #   - template (Template): O modelo de questionário original a ser copiado.
  #   - turma_ids (Array<Integer>): Lista de IDs das turmas que receberão a avaliação.
  #
  # Retorno: Instância do Service.
  #
  # Efeitos Colaterais: Apenas atribuição de variáveis de instância.
  def initialize(template, turma_ids)
    @template = template
    @turma_ids = turma_ids
  end

  # Executa o processo de distribuição dentro de uma transação de banco de dados.
  # Garante atomicidade: ou todos os formulários são criados, ou nenhum é.
  #
  # Args: Nenhum
  #
  # Retorno: O resultado da execução do bloco de transação (geralmente a lista de IDs processada).
  #
  # Efeitos Colaterais:
  #   - Cria registros nas tabelas: Formulario, FormularioTurma, QuestaoFormulario e OpcaoFormulario.
  def call
    ActiveRecord::Base.transaction do
      @turma_ids.each do |tid|
        create_form_copy_for_class(tid)
      end
    end
  end

  private

  # Cria uma cópia isolada do formulário para uma turma específica.
  #
  # Args:
  #   - turma_id (Integer): O ID da turma destino.
  #
  # Retorno: O objeto Formulario recém-criado (embora não utilizado explicitamente pelo caller).
  #
  # Efeitos Colaterais:
  #   - Cria o registro Formulario.
  #   - Cria o vínculo FormularioTurma.
  #   - Dispara a cópia em cascata das questões.
  def create_form_copy_for_class(turma_id)
    novo_formulario = Formulario.create!(
      titulo: @template.nome,
      so_alunos: true
    )

    FormularioTurma.create!(formulario: novo_formulario, turma_id: turma_id)
    copy_questions(novo_formulario)
  end

  # Duplica as perguntas do template para o novo formulário.
  #
  # Args:
  #   - novo_formulario (Formulario): A instância do formulário destino.
  #
  # Retorno: A coleção de QuestaoTemplate iterada.
  #
  # Efeitos Colaterais: Cria múltiplos registros de QuestaoFormulario.
  def copy_questions(novo_formulario)
    @template.questao_templates.each do |q_template|
      nova_questao = QuestaoFormulario.create!(
        formulario: novo_formulario,
        texto_questao: q_template.texto_questao,
        tipo_resposta: q_template.tipo_resposta
      )
      copy_options(q_template, nova_questao)
    end
  end

  # Duplica as opções de resposta (se houver) de uma pergunta do template para a pergunta do formulário.
  #
  # Args:
  #   - q_template (QuestaoTemplate): A pergunta original (origem).
  #   - nova_questao (QuestaoFormulario): A pergunta nova (destino).
  #
  # Retorno: A coleção de OpcaoTemplate iterada.
  #
  # Efeitos Colaterais: Cria múltiplos registros de OpcaoFormulario.
  def copy_options(q_template, nova_questao)
    q_template.opcao_templates.each do |o_template|
      OpcaoFormulario.create!(
        questao_formulario: nova_questao,
        texto_opcao: o_template.texto_opcao,
        numero_opcao: o_template.numero_opcao
      )
    end
  end
end