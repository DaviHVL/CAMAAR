require 'rails_helper'

RSpec.describe "Listagem de Templates (Admin)", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "mostra templates existentes e o link para criar novo template" do
    admin = Usuario.create!(nome: "Admin Lista", email: "admin2@unb.br", password: "adminpass", matricula: "7777", ocupacao: "docente")

    # criar alguns templates
    Template.create!(nome: "Template A", usuario: admin)
    Template.create!(nome: "Template B", usuario: admin)

    # login
    visit login_path
    fill_in "Email", with: admin.email
    fill_in "Senha", with: "adminpass"
    click_button "Entrar"

    # visitar a página de listagem de templates
    visit admin_edit_templates_path

    expect(page).to have_content("Gerenciamento - Templates")
    expect(page).to have_content("Template A")
    expect(page).to have_content("Template B")

    # botão para criar novo template
    expect(page).to have_link(nil, href: new_template_path)
  end
end
