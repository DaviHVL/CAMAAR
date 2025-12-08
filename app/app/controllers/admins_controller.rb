class AdminsController < ApplicationController
  before_action :require_login
  layout 'dashboard' 
  before_action :set_template, only: [:edit_template, :update_template, :destroy_template]
  skip_before_action :require_login, only: [:create_template]

  # --- Menu Principal ---
  def dashboard
  end

  # --- Funcionalidade de Importação ---
  def import_form
  end

  # ADICIONADO: O método que processa o upload
  def importar
    arquivo_turmas = params[:arquivo_turmas]
    arquivo_membros = params[:arquivo_membros]

    if arquivo_turmas.present? && arquivo_membros.present?
      # Caminho temporário dos arquivos enviados
      path_turmas = arquivo_turmas.path
      path_membros = arquivo_membros.path

      # Chama o serviço para processar
      SigaaService.new(path_turmas, path_membros).call

      redirect_to admin_path, notice: "Importação realizada com sucesso!"
    else
      redirect_to admin_importar_form_path, alert: "Por favor, anexe os dois arquivos JSON."
    end
  end

  # --- Funcionalidade de Enviar Formulários ---
  def send_forms
    @turmas = Turma.all

    @templates = Template.where(usuario_id: current_user.id)
                          .order(:nome)
  end

  # --- Funcionalidade de Templates (Manual) ---
  def edit_templates
    @templates = Template.all.order(created_at: :desc)
  end

  def new_template
    @template = Template.new
    questao = @template.questao_templates.build
    # Adiciona pelo menos um bloco de Questão vazio para iniciar o formulário
    questao.opcao_templates.build
  end


    # app/controllers/admins_controller.rb

  def create_template

    attrs = params.require(:template).permit(
      :nome,
      questao_templates_attributes: [
        :tipo,
        :texto,
        options_attributes: [:texto]
      ]
    )

    template = Template.create!(
      nome: attrs[:nome],
      usuario_id: current_user.id
    )

    if attrs[:questao_templates_attributes]
      attrs[:questao_templates_attributes].each do |_, q|
        questao = QuestaoTemplate.create!(
          template_id: template.id,
          tipo_resposta: q[:tipo],       # renomeando automaticamente
          texto_questao: q[:texto]
        )

        if q[:options_attributes]
          q[:options_attributes].each do |idx, op|
            OpcaoTemplate.create!(
              questao_template_id: questao.id,
              texto_opcao: op[:texto],
              numero_opcao: idx.to_i + 1
            )
          end
        end
      end
    end
    redirect_to admin_edit_templates_path, notice: "Template criado com sucesso!"

  end


  def destroy_template
    # @template já foi carregado por set_template, mas a lógica de verificação
    # de permissão DEVE estar no set_template, ou você corre o risco de tentar
    # rodar o destroy em um objeto que você não deveria ter acessado.
    
    template_name = @template.nome # Salva o nome para a mensagem de feedback
    @template.destroy
    
    redirect_to admin_edit_templates_path, notice: "Template '#{template_name}' excluído com sucesso."
  end

  def edit_template
    # @template já vem do set_template (com questao_templates e opcao_templates carregados)
    Rails.logger.info "EDIT_TEMPLATE: template id=#{@template.id} - questoes_count=#{@template.questao_templates.size}"
    @template.questao_templates.each do |q|
      Rails.logger.info "  questao id=#{q.id} texto='#{q.texto_questao}' options_count=#{q.opcao_templates.size}"
    end

    render 'update_template'
  end

  def update_template
    puts "========= ENTROU NO MÉTODO UPDATE_TEMPLATE ========="
    @template = Template.find(params[:id])
    puts "PARAMS RECEBIDOS:"
    pp params[:template]
    attrs = params.require(:template).permit(
      :nome,
      questao_templates_attributes: [
        :id, :tipo_resposta, :texto_questao, :_destroy,
        opcao_templates_attributes: [:id, :texto_opcao, :numero_opcao, :_destroy]
      ]
    )

    if @template.update(attrs)
      redirect_to admin_edit_templates_path,
                  notice: "Template atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def process_send_forms
    template_id = params[:template_id]
    turma_ids = params[:turma_ids]

    if template_id.blank? || turma_ids.blank?
      redirect_to admin_send_forms_path, alert: "Selecione um template e pelo menos uma turma."
      return
    end

    ActiveRecord::Base.transaction do
      turma_ids.each do |tid|
        FormularioTurma.create!(
          formulario_id: template_id,
          turma_id: tid,
        )
      end
    end

    redirect_to admin_send_forms_path, notice: "Formulários enviados com sucesso!"
  end

  private

  # Método forte para permitir apenas os parâmetros esperados
  def template_params
    # Permite o nome do template, e então, permite a lista de atributos de QuestaoTemplate
    params.require(:template).permit(
      :nome,
      # Nome da associação no plural snake_case: questao_templates
      questao_templates_attributes: [
        :id, 
        :texto_questao, 
        :tipo_resposta, 
        :_destroy, # Para remover questões existentes
        # Permite a lista de atributos de OpcaoTemplate
        opcao_templates_attributes: [
          :id, 
          :texto_opcao, 
          :numero_opcao, 
          :_destroy # Para remover opções existentes
        ]
      ]
    )
  end

  # Carrega o template e verifica a permissão
  def set_template
    # carrega template com questoes e opcoes em uma só query
    @template = Template.includes(questao_templates: :opcao_templates).find(params[:id])

    unless @template.usuario_id == current_user.id
      redirect_to admin_edit_templates_path, alert: "Você não tem permissão para acessar este template."
      return
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_edit_templates_path, alert: "Template não encontrado."
  end

end