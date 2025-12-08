require 'rails_helper'

RSpec.describe "Gerenciamento de Templates (exclusão)", type: :request do
  it "permite que o dono do template exclua o template" do
    owner = Usuario.create!(nome: "Dono", email: "dono@unb.br", password: "pass123", matricula: "1111", ocupacao: "docente")
    template = Template.create!(nome: "Para Deletar", usuario: owner)

    # login como owner
    post login_path, params: { email: owner.email, password: 'pass123' }
    expect(session[:user_id]).to eq(owner.id)

    delete admin_template_delete_path(template)
    expect(response).to redirect_to(admin_edit_templates_path)

    follow_redirect!
    expect(response.body).to include("excluído com sucesso")
    expect(Template.find_by(id: template.id)).to be_nil
  end

  it "não permite que outro usuário exclua o template" do
    owner = Usuario.create!(nome: "Dono2", email: "dono2@unb.br", password: "pass123", matricula: "2222", ocupacao: "docente")
    other = Usuario.create!(nome: "Outro", email: "outro@unb.br", password: "pass123", matricula: "3333", ocupacao: "docente")
    template = Template.create!(nome: "Nao Permitir", usuario: owner)

    # login como outro usuário
    post login_path, params: { email: other.email, password: 'pass123' }
    expect(session[:user_id]).to eq(other.id)

    delete admin_template_delete_path(template)
    expect(response).to redirect_to(admin_edit_templates_path)

    follow_redirect!
    expect(response.body).to include("Você não tem permissão para acessar este template")
    expect(Template.find_by(id: template.id)).to be_present
  end
end
