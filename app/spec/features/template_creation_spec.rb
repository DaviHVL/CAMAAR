require 'rails_helper'

RSpec.describe "Criação de Template (Admin)", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "permite que um usuário logado crie um template e o veja na listagem" do
    user = Usuario.create!(nome: "Admin Test", email: "admin@unb.br", password: "adminpass", matricula: "8888", ocupacao: "docente")

    # login
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Senha", with: "adminpass"
    click_button "Entrar"

    # ir à página de criação de template
    visit admin_new_template_path

    # preencher o nome do template (campo name: template[nome])
    fill_in "template[nome]", with: "Template de Teste"

    # enviar
    click_button "Criar"

    # expectativas
    expect(page).to have_content("Template 'Template de Teste' criado com sucesso!")
    expect(page).to have_content("Template de Teste")
  end
end
