require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  let(:user) { Usuario.create!(nome: "Teste", email: "teste@t.com", matricula: "123", password: "123", password_confirmation: "123", ocupacao: "aluno") }

  before do
    post login_path, params: { email: user.email, password: "123" }
  end

  describe "GET /password/edit" do
    it "acessa a página de edição com sucesso" do
      get edit_password_path 
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /password" do
    context "Happy Path (Sucesso)" do
      it "atualiza a senha com sucesso" do
        patch password_path, params: { usuario: { password: "newpass", password_confirmation: "newpass" } }
        expect(response).to have_http_status(:redirect) 
        expect(flash[:notice]).to be_present
      end
    end

    context "Sad Path (Falha)" do
      it "não atualiza se as senhas não batem (Cobre o 'else' do update)" do
        patch password_path, params: { usuario: { password: "123", password_confirmation: "456" } }
        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
  end
end