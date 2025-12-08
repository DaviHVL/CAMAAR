require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  let(:usuario) { Usuario.create!(nome: "Test User", email: "test@unb.br", password: "pass123", matricula: "1234", ocupacao: "aluno") }
  let(:formulario) { Formulario.create!(titulo: "Formulário Teste") }
  let(:departamento) { Departamento.create!(nome: "Ciência da Computação") }
  let(:materia) { Materia.create!(nome: "Programação", codigo: "CIC001", departamento: departamento) }
  let(:turma) { Turma.create!(num_turma: "01", semestre: "2025.1", materia: materia) }

  before do
    post login_path, params: { email: usuario.email, password: 'pass123' }
  end

  describe "GET /formularios/:id" do
    it "returns http success" do
      get "/formularios/#{formulario.id}"
      expect(response).to have_http_status(:success)
    end

    it "displays the formulario title" do
      get "/formularios/#{formulario.id}"
      expect(response.body).to include(formulario.titulo)
    end
  end

  describe "POST /formularios/:id/responder" do
    it "returns http success when responding to formulario" do
      post "/formularios/#{formulario.id}/responder", params: { turma_id: turma.id, respostas: {} }
      expect(response).to have_http_status(:found)
    end
  end
end
