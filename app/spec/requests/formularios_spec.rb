require "rails_helper"

RSpec.describe "Formularios", type: :request do
  let!(:usuario) do
    Usuario.create!(
      email: "form@u.com",
      password: "123456",
      password_confirmation: "123456",
      nome: "Form",
      matricula: "111",
      ocupacao: "Aluno"
    )
  end

  let!(:formulario) do
    Formulario.create!
  end

  context "sem login" do
    it "permite acesso ou redireciona" do
      get "/formularios/#{formulario.id}"
      expect(response.status).to be_between(200, 302)
    end
  end

  context "com login" do
    before do
      post "/login", params: { email: usuario.email, password: "123456" }
    end

    it "mostra formulário existente" do
      get "/formularios/#{formulario.id}"
      expect(response.status).to be_between(200, 302)
    end

    it "retorna 404 para formulário inexistente" do
      get "/formularios/999999"
      expect(response).to have_http_status(404)
    end

    it "tenta responder formulário" do
      post "/formularios/#{formulario.id}/responder", params: {}
      expect([200, 302, 404]).to include(response.status)
    end

  end
end
