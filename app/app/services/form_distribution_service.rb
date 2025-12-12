class FormDistributionService
  def initialize(template, turma_ids)
    @template = template
    @turma_ids = turma_ids
  end

  def call
    ActiveRecord::Base.transaction do
      @turma_ids.each do |tid|
        create_form_copy_for_class(tid)
      end
    end
  end

  private

  def create_form_copy_for_class(turma_id)
    novo_formulario = Formulario.create!(
      titulo: @template.nome,
      so_alunos: true
    )

    FormularioTurma.create!(formulario: novo_formulario, turma_id: turma_id)
    copy_questions(novo_formulario)
  end

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