require 'rails_helper'

RSpec.describe "Exportar Resultados CSV", type: :request do
  it "retorna um CSV com os resultados do formulário" do
    # Criar usuário e dados do formulário
    usuario = Usuario.create!(nome: "Aluno CSV", email: "csv@unb.br", password: "pass123", matricula: "4444", ocupacao: "discente")

    formulario = Formulario.create!(titulo: "Form CSV", so_alunos: true)
    q1 = QuestaoFormulario.create!(formulario: formulario, texto_questao: "Pergunta Texto", tipo_resposta: 'texto')
    q2 = QuestaoFormulario.create!(formulario: formulario, texto_questao: "Pergunta MC", tipo_resposta: 'multipla_escolha')
    op = OpcaoFormulario.create!(questao_formulario: q2, texto_opcao: "Opção A", numero_opcao: 1)

    # Responder o formulário
    fr = FormularioRespondido.create!(formulario: formulario, usuario: usuario)
    QuestaoRespondida.create!(formulario_respondido: fr, questao_formulario: q1, resposta: "Resposta teste")
    QuestaoRespondida.create!(formulario_respondido: fr, questao_formulario: q2, opcao_formulario: op)

    # Log in via sessions#create to set the session
    post login_path, params: { email: usuario.email, password: 'pass123' }
    expect(response).to redirect_to(root_path)

    # Request CSV
    get baixar_resultado_path(formulario, format: :csv)

    expect(response).to have_http_status(:ok)
    expect(response.content_type).to include('text/csv')

    csv = response.body
    expect(csv).to include('Matrícula,Nome,Pergunta Texto,Pergunta MC')
    expect(csv).to include('4444,Aluno CSV,Resposta teste,Opção A')
  end
end
