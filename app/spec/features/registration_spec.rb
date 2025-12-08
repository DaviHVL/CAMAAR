require 'rails_helper'

RSpec.describe "Cadastro de Usuário", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "permite que um visitante crie uma conta com sucesso" do
    visit cadastro_path

    fill_in "Nome Completo", with: "Usuário Teste"
    fill_in "Email Institucional", with: "teste@unb.br"
    fill_in "Matrícula", with: "123456"
    fill_in "Senha", with: "minhasenha"
    fill_in "Confirme a Senha", with: "minhasenha"

    click_button "Cadastrar"

    expect(page).to have_content("Cadastro realizado com sucesso!")
    expect(current_path).to eq(root_path)
    expect(Usuario.find_by(email: "teste@unb.br")).to be_present
  end

  it "exibe erro quando dados inválidos são enviados" do
    visit cadastro_path

    fill_in "Nome Completo", with: ""
    fill_in "Email Institucional", with: ""
    fill_in "Matrícula", with: ""
    fill_in "Senha", with: "123"
    fill_in "Confirme a Senha", with: "456"

    click_button "Cadastrar"

    expect(page).to have_content("Não foi possível realizar o cadastro.")
    # form should re-render on :new
    expect(page).to have_current_path(cadastro_path)
  end
end
