require 'rails_helper'

RSpec.describe SigaaService do
  # Mock do classes.json
  let(:classes_json) do
    [
      {
        "code": "CIC0097",
        "name": "BANCOS DE DADOS",
        "class": { "classCode": "TA", "semester": "2021.2", "time": "35T45" }
      }
    ].to_json
  end

  # Mock do class_members.json
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

  let(:classes_path) { 'spec/fixtures/files/classes.json' }
  let(:members_path) { 'spec/fixtures/files/members.json' }

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
    it 'importa turmas e matricula usuários corretamente' do
      service = SigaaService.new(classes_path, members_path)

      # Verificações
      expect { service.call }.to change(Materia, :count).by(1)
        .and change(Turma, :count).by(1)
        .and change(Usuario, :count).by(2) # 1 Aluno + 1 Prof
        .and change(UsuarioTurma, :count).by(2) # 2 matrículas

      # Verifica se os dados foram salvos corretamente
      materia = Materia.find_by(codigo: 'CIC0097')
      expect(materia.nome).to eq('BANCOS DE DADOS')

      aluno = Usuario.find_by(matricula: '190012345')
      prof = Usuario.find_by(matricula: '111222333')
      turma = Turma.first

      expect(aluno.turmas).to include(turma)
      expect(prof.turmas).to include(turma)
    end
  end
end