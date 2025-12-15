require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { Usuario.create!(nome: "User", email: "user@t.com", matricula: "10", ocupacao: "aluno", password: "123", password_confirmation: "123") }

  describe "POST /password_resets (Solicitar Link)" do
    context "Happy Path (Sucesso)" do
      it "envia email e redireciona se o usuário existe" do
        expect {
          post password_resets_path, params: { email: user.email }
        }.to change { ActionMailer::Base.deliveries.size }.by(1)

        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to include("Email enviado")
      end
    end

    context "Sad Path (Falha)" do
      it "renderiza new se o email não existe" do
        post password_resets_path, params: { email: "naoexiste@t.com" }
        expect(flash[:alert]).to be_present
        expect(response).not_to be_redirect 
      end
    end
  end

  describe "GET /password_resets/:token/edit (Acessar Link)" do
    context "Edge Case (Concern: valid_reset_token?)" do
      it "redireciona se o usuário não solicitou reset (reset_digest nil)" do
        user.update_column(:reset_digest, nil)
        
        get edit_password_reset_path("token_aleatorio"), params: { email: user.email }
        
        expect(response).to redirect_to(new_password_reset_path)
      end
    end
  end

  describe "PATCH /password_resets/:token (Redefinir Senha)" do
    let(:token) { "token_valido_123" }

    before do
      user.update_columns(
        reset_digest: BCrypt::Password.create(token),
        reset_sent_at: Time.zone.now
      )
    end

    context "Happy Path (Sucesso)" do
      it "atualiza a senha, limpa o digest e loga o usuário" do
        patch password_reset_path(token), params: { 
          email: user.email, 
          usuario: { password: "nova_senha", password_confirmation: "nova_senha" } 
        }

        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to include("sucesso")

        expect(user.reload.authenticate("nova_senha")).to be_truthy
        
        expect(user.reset_digest).to be_nil
      end
    end

    context "Sad Path (Token Expirado)" do
      it "redireciona para new se o token expirou" do
        user.update_column(:reset_sent_at, 3.hours.ago)
        
        patch password_reset_path(token), params: { email: user.email, usuario: { password: "new", password_confirmation: "new" } }
        
        expect(response).to redirect_to(new_password_reset_path)
        expect(flash[:alert]).to include("inválido ou expirado")
      end
    end

    context "Sad Path (Senha Inválida)" do
      it "renderiza edit se a senha for inválida (não confere)" do
        patch password_reset_path(token), params: { 
          email: user.email, 
          usuario: { password: "123", password_confirmation: "456" } 
        }
        
        expect(response).to have_http_status(:unprocessable_entity)
        
        expect(response.body).to include("Nova Senha") 
      end
    end
    
    context "Sad Path (Usuário não encontrado)" do
       it "redireciona se o email na URL não bater com o token do usuário" do
        patch password_reset_path(token), params: { email: "outro@email.com", usuario: { password: "new", password_confirmation: "new" } }
        
        expect(response).to redirect_to(new_password_reset_path)
      end
    end
  end
end