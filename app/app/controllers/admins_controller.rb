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
    # No futuro, aqui você faria: @templates = Template.all
    # Por enquanto, usamos dados mockados para preencher a tela:
    @templates = []
  end
end