class AdminsController < ApplicationController
  before_action :require_login
  layout 'dashboard' 

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
    # 1. Busca o template pelo ID passado na URL (params[:id])
    @template = Template.find(params[:id])
    
    # 2. Verifica se o template pertence ao usuário logado (boa prática de segurança)
    # Assumindo que o template tem a coluna usuario_id e a associação belongs_to :usuario
    if @template.usuario_id != current_user.id
      redirect_to admin_edit_templates_path, alert: "Você não tem permissão para excluir este template."
      return
    end

    template_name = @template.nome # Salva o nome para a mensagem de feedback

    @template.destroy
    
    # 3. Redireciona de volta para a lista
    redirect_to admin_edit_templates_path, notice: "Template '#{template_name}' excluído com sucesso."
  end

  private

  def template_params
    params.require(:template).permit(:nome) 
  end
end