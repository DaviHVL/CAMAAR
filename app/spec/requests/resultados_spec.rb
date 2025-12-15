require 'rails_helper'

RSpec.describe "Resultados", type: :request do
  let(:user) { Usuario.create!(nome: "User", email: "res@t.com", matricula: "99", password: "123", password_confirmation: "123", ocupacao: "admin", is_admin: true) }

  before do
    post login_path, params: { email: user.email, password: "123" }
  end

  describe "GET /resultados" do
    it "carrega a página com sucesso" do
      get resultados_path
      expect(response).to have_http_status(:success)
    end
  end
end