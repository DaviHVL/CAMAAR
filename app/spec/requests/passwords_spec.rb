require "rails_helper"

RSpec.describe "Passwords", type: :request do
  let!(:usuario) do
    Usuario.create!(
      email: "p@u.com",
      password: "123456",
      password_confirmation: "123456",
      nome: "Pass",
      matricula: "666",
      ocupacao: "Aluno"
    )
  end

  it "bloqueia edição sem login" do
    get "/password/edit"
    expect(response).to have_http_status(:redirect)
  end

  context "logado" do
    before do
      post "/login", params: { email: usuario.email, password: "123456" }
    end

    it "acessa edição" do
      get "/password/edit"
      expect(response).to have_http_status(:success)
    end

    it "tenta atualizar senha inválida" do
      patch "/password", params: { password: "", password_confirmation: "" }
      expect(response.status).to be_between(400, 422)
    end
  end
end
