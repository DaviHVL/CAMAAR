require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:usuario) { Usuario.create!(nome: "Test User", email: "test@unb.br", password: "pass123", matricula: "1234", ocupacao: "aluno") }

  before do
    post login_path, params: { email: usuario.email, password: 'pass123' }
  end

  describe "GET /dashboard" do
    it "returns http success" do
      get "/dashboard"
      expect(response).to have_http_status(:success)
    end

    it "displays the page content" do
      get "/dashboard"
      expect(response.body).to include("grid")
    end
  end
end
