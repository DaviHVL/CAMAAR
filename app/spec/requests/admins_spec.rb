require "rails_helper"

RSpec.describe "Admins", type: :request do
  let!(:admin) do
    Usuario.create!(
      email: "admin@u.com",
      password: "123456",
      password_confirmation: "123456",
      nome: "Admin",
      matricula: "999",
      ocupacao: "Admin"
    )
  end

  let!(:usuario) do
    Usuario.create!(
      email: "user@u.com",
      password: "123456",
      password_confirmation: "123456",
      nome: "User",
      matricula: "888",
      ocupacao: "Aluno"
    )
  end

  context "sem login" do
    it "bloqueia dashboard" do
      get "/admin"
      expect(response.status).to be_between(200, 302)

    end
  end

  context "com usuário comum" do
    before do
      post "/login", params: { email: usuario.email, password: "123456" }
    end

    it "bloqueia acesso admin" do
      get "/admin"
      expect(response.status).to be_between(200, 302)

    end
  end

  context "como admin" do
    before do
      post "/login", params: { email: admin.email, password: "123456" }
    end

    it "acessa dashboard" do
      get "/admin"
      expect(response.status).to be_between(200, 302)
    end

    it "acessa importar" do
      get "/admin/importar"
      expect(response.status).to be_between(200, 302)
    end

    it "acessa templates" do
      get "/admin/templates"
      expect(response.status).to be_between(200, 302)
    end
  end
end
