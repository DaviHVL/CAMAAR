class AdminsController < ApplicationController
  before_action :require_login
  layout 'dashboard' 

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
    # Lógica para carregar dados (formulários, templates)
    @forms_to_send = [ 
      { name: "Estudos Em", semester: "2024.1", code: "CIC1024", checked: true }, 
      # ...
    ]
  end

  # --- Funcionalidade de Templates (Manual) ---
  def edit_templates
    @templates = Template.all.order(created_at: :desc)
  end

  def new_template
    @template = Template.new
  end

  def create_template
    @template = Template.new(template_params)
    @template.usuario_id = current_user.id
    
    if @template.save
      redirect_to admin_edit_templates_path, notice: "Template '#{@template.nome}' criado com sucesso!"
    else
      flash.now[:alert] = "Erro ao criar o template. Verifique se o nome foi preenchido corretamente."
      render :new_template, status: :unprocessable_entity
    end
  end

  def destroy_template
    @template = Template.find(params[:id])
    
    if @template.usuario_id != current_user.id
      redirect_to admin_edit_templates_path, alert: "Você não tem permissão para excluir este template."
      return
    end

    template_name = @template.nome 
    @template.destroy
    
    redirect_to admin_edit_templates_path, notice: "Template '#{template_name}' excluído com sucesso."
  end

  private

  def template_params
    params.require(:template).permit(:nome) 
  end
end