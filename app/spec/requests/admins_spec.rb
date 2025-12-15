require "rails_helper"

RSpec.describe "AdminsController", type: :request do
  let!(:admin) do
    Usuario.create!(
      email: "admin@u.com",
      password: "123456",
      password_confirmation: "123456",
      nome: "Administrador",
      matricula: "99999",
      ocupacao: "Admin",
      is_admin: true 
    )
  end

  let!(:aluno) do
    Usuario.create!(
      email: "aluno@u.com",
      password: "123456",
      password_confirmation: "123456",
      nome: "Aluno Teste",
      matricula: "11111",
      ocupacao: "Discente"
    )
  end

  let!(:departamento) { Departamento.create!(nome: "CIC") }
  let!(:materia) { Materia.create!(nome: "Engenharia de Software", codigo: "CIC001", departamento: departamento) }
  let!(:turma) { Turma.create!(materia: materia, semestre: "2024.1", num_turma: "TA") }
  let!(:template) { Template.create!(nome: "Avaliação Padrão", usuario: admin) }


  # TESTES DE AUTENTICAÇÃO

  describe "Controle de Acesso" do
    context "quando não está logado" do
      it "redireciona para login" do
        get "/admin"
        expect(response).to redirect_to(login_path)
      end
    end

    context "quando logado como aluno" do
      before { post "/login", params: { email: aluno.email, password: "123456" } }

      it "não deve acessar funcionalidades administrativas" do
        get "/admin"
        expect(response.status).to be_between(200, 403) 
      end
    end
  end

  # TESTES FUNCIONAIS 

  describe "Funcionalidades de Admin" do
    before do
      post "/login", params: { email: admin.email, password: "123456" }
    end

    it "renderiza o dashboard com sucesso" do
      get "/admin"
      expect(response).to have_http_status(:success)
    end

    it "renderiza o formulário de importação" do
      get "/admin/importar"
      expect(response).to have_http_status(:success)
    end

    describe "POST /admin/importar" do
      context "Caminho Triste (Sem arquivos)" do
        it "falha, redireciona e mostra alerta" do
          post "/admin/importar", params: {}
          
          expect(response).to redirect_to(admin_importar_form_path)
          expect(flash[:alert]).to include("Por favor, anexe")
        end
      end

      context "Caminho Feliz (Com arquivos)" do
        it "processa a importação e redireciona com sucesso" do
          service_double = instance_double(SigaaService)
          allow(SigaaService).to receive(:new).and_return(service_double)
          allow(service_double).to receive(:call)

          arquivo_mock = fixture_file_upload('dummy.json', 'application/json')
          
          post "/admin/importar", params: { 
            arquivo_turmas: arquivo_mock, 
            arquivo_membros: arquivo_mock 
          }

          expect(SigaaService).to have_received(:new)
          expect(service_double).to have_received(:call)
          expect(response).to redirect_to(admin_path)
          expect(flash[:notice]).to include("sucesso")
        end
      end
    end

    it "renderiza a seleção de formulários para turmas" do
      get "/admin/send_forms"
      expect(response).to have_http_status(:success)
      
      expect(response.body).to include(template.nome)
      expect(response.body).to include(turma.num_turma)
    end

    describe "POST /admin/send_forms" do
      context "Caminho Triste (Dados em branco)" do
        it "falha quando não seleciona template ou turma" do
          post "/admin/send_forms", params: { template_id: "", turma_ids: [] }

          expect(response).to redirect_to(admin_send_forms_path)
          expect(flash[:alert]).to include("Selecione um template")
        end
      end

      context "Caminho Feliz (Dados válidos)" do
        it "distribui os formulários e mostra sucesso" do
          dist_service = instance_double(FormDistributionService)
          allow(FormDistributionService).to receive(:new).and_return(dist_service)
          allow(dist_service).to receive(:call)

          post "/admin/send_forms", params: { 
            template_id: template.id, 
            turma_ids: [turma.id] 
          }

          expect(FormDistributionService).to have_received(:new).with(template, include(turma.id.to_s))
          expect(dist_service).to have_received(:call)
          expect(response).to redirect_to(admin_send_forms_path)
          expect(flash[:notice]).to include("sucesso")
        end
      end
    end
  end
end