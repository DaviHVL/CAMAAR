class DashboardController < ApplicationController
  before_action :require_login
  layout 'dashboard'

  def index
    @turmas = current_user.turmas.includes(:materia, :formularios)

    @ids_respondidos = current_user.formulario_respondidos.pluck(:formulario_id)
  end
end