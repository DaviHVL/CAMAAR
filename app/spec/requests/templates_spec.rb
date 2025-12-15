require 'rails_helper'

RSpec.describe "TemplatesController", type: :request do
  let(:admin) { Usuario.create!(nome: "Admin", email: "adm@t.com", matricula: "99", ocupacao: "admin", password: "123", password_confirmation: "123", is_admin: true) }
  
  before { post login_path, params: { email: admin.email, password: "123" } }

  describe "POST /templates" do
    context "Caminho Triste (Dados Inválidos)" do
      it "não cria o template e re-renderiza o form" do
        expect {
          post templates_path, params: { template: { nome: "" } }
        }.not_to change(Template, :count)

        expect(response).to have_http_status(:unprocessable_entity) 
        expect(response.body).to include("error") 
      end
    end
  end
  
  describe "PATCH /templates/:id" do
    let(:template) { Template.create!(nome: "Original", usuario: admin) }
    
    it "não atualiza com dados inválidos" do
      patch template_path(template), params: { template: { nome: "" } }
      expect(template.reload.nome).to eq("Original")
    end
  end
end