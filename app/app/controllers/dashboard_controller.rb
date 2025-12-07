class DashboardController < ApplicationController
  before_action :require_login
  layout 'dashboard' 

  def index
    @turmas = current_user.turmas.includes(:materia)
  end
end