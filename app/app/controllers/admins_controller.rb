class AdminsController < ApplicationController
  before_action :require_login
  layout 'dashboard' 
  before_action :set_template, only: [:edit_template, :update_template, :destroy_template]
  skip_before_action :require_login, only: [:create_template]

  def dashboard
  end

  def import_form
  end

  def send_forms
    # Lógica para carregar dados (formulários, templates)
    @forms_to_send = [ 
      { name: "Estudos Em", semester: "2024.1", code: "CIC1024", checked: true }, 
      # ...
    ]
  end

  def edit_templates
    # Busca todos os templates criados no banco de dados
    @templates = Template.all.order(created_at: :desc)
  end

  def new_template
    # Inicializa um novo objeto Template vazio
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