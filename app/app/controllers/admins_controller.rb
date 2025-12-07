class AdminsController < ApplicationController
  before_action :require_login
  layout 'dashboard' 

  def dashboard
  end

  def import_form
  end
end