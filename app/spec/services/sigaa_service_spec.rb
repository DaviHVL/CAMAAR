require 'rails_helper'
require 'fileutils'

RSpec.describe SigaaService do
  let(:classes_json) do
    [
      {
        "code": "CIC0097",
        "name": "BANCOS DE DADOS",
        "class": { "classCode": "TA", "semester": "2021.2", "time": "35T45" }
      }
    ].to_json
  end

  let(:members_json) do
    [
      {
        "code": "CIC0097",
        "classCode": "TA",
        "semester": "2021.2",
        "dicente": [
          {
            "nome": "Aluno Teste",
            "matricula": "190012345",
            "usuario": "190012345",
            "email": "aluno@teste.com",
            "ocupacao": "dicente"
          }
        ],
        "docente": {
          "nome": "Prof Teste",
          "usuario": "111222333",
          "email": "prof@unb.br",
          "ocupacao": "docente"
        }
      }
    ].to_json
  end

  let(:classes_path) { 'spec/fixtures/files/classes_test.json' }
  let(:members_path) { 'spec/fixtures/files/members_test.json' }

  before do
    FileUtils.mkdir_p('spec/fixtures/files')
    File.write(classes_path, classes_json)
    File.write(members_path, members_json)
  end

  after do
    File.delete(classes_path) if File.exist?(classes_path)
    File.delete(members_path) if File.exist?(members_path)
  end

  describe '#call' do
    # CAMINHO FELIZ 
    context 'quando os arquivos são válidos' do
      it 'importa turmas e matricula usuários corretamente' do
        service = SigaaService.new(classes_path, members_path)

        expect { service.call }.to change(Materia, :count).by(1)
          .and change(Turma, :count).by(1)
          .and change(Usuario, :count).by(2)
          .and change(UsuarioTurma, :count).by(2)

        materia = Materia.find_by(codigo: 'CIC0097')
        expect(materia.nome).to eq('BANCOS DE DADOS')

        aluno = Usuario.find_by(matricula: '190012345')
        prof = Usuario.find_by(matricula: '111222333')
        turma = Turma.first

        expect(aluno.turmas).to include(turma)
        expect(prof.turmas).to include(turma)
      end
    end

    # CAMINHOS TRISTES 
    context 'Caminhos Tristes (Erros e Validações)' do
      it 'lida graciosamente quando os arquivos NÃO existem' do
        service = SigaaService.new('caminho/fake/turmas.json', 'caminho/fake/membros.json')
        
        expect { service.call }.not_to raise_error
        
        expect(Materia.count).to eq(0)
      end

      it 'aciona o rescue quando o JSON está corrompido' do
        File.write(classes_path, "{ json: quebrado, sem_fechar_chave")
        
        service = SigaaService.new(classes_path, members_path)
        
        expect { service.call }.not_to raise_error
      end

      it 'ignora membros de turmas que não existem no banco' do
        File.delete(classes_path) 
        
        service = SigaaService.new(classes_path, members_path)
        
        # Executa
        service.call
        
        expect(Usuario.count).to eq(0)
      end
    end
  end
end