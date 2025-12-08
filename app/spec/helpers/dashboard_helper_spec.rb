require 'rails_helper'

RSpec.describe DashboardHelper, type: :helper do
  describe '#turma_tem_formulario_pendente?' do
    let(:turma) { Turma.new }
    let(:formulario) { Formulario.new(id: 1) }

    it 'retorna true quando turma tem formulário e não foi respondido' do
      allow(turma).to receive(:formularios).and_return([formulario])
      
      expect(helper.turma_tem_formulario_pendente?(turma, [])).to be_truthy
    end

    it 'retorna false quando turma não tem formulário' do
      allow(turma).to receive(:formularios).and_return([])
      
      expect(helper.turma_tem_formulario_pendente?(turma, [])).to be_falsy
    end

    it 'retorna false quando formulário já foi respondido' do
      allow(turma).to receive(:formularios).and_return([formulario])
      
      expect(helper.turma_tem_formulario_pendente?(turma, [1])).to be_falsy
    end
  end

  describe '#status_formulario' do
    it 'retorna respondido quando formulário está na lista de respondidos' do
      expect(helper.status_formulario(1, [1, 2, 3])).to eq('respondido')
    end

    it 'retorna pendente quando formulário não está respondido' do
      expect(helper.status_formulario(1, [2, 3, 4])).to eq('pendente')
    end

    it 'retorna pendente quando lista de respondidos está vazia' do
      expect(helper.status_formulario(1, [])).to eq('pendente')
    end
  end

  describe '#contar_formularios_pendentes' do
    let(:turma1) { Turma.new }
    let(:turma2) { Turma.new }
    let(:turma3) { Turma.new }
    let(:formulario1) { Formulario.new(id: 1) }
    let(:formulario2) { Formulario.new(id: 2) }
    let(:formulario3) { Formulario.new(id: 3) }

    it 'conta corretamente os formulários pendentes' do
      allow(turma1).to receive(:formularios).and_return([formulario1])
      allow(turma2).to receive(:formularios).and_return([formulario2])
      allow(turma3).to receive(:formularios).and_return([formulario3])

      turmas = [turma1, turma2, turma3]
      ids_respondidos = [1] # Apenas o primeiro foi respondido

      expect(helper.contar_formularios_pendentes(turmas, ids_respondidos)).to eq(2)
    end

    it 'retorna 0 quando todos foram respondidos' do
      allow(turma1).to receive(:formularios).and_return([formulario1])
      allow(turma2).to receive(:formularios).and_return([formulario2])

      turmas = [turma1, turma2]
      ids_respondidos = [1, 2]

      expect(helper.contar_formularios_pendentes(turmas, ids_respondidos)).to eq(0)
    end

    it 'retorna a quantidade total quando nenhum foi respondido' do
      allow(turma1).to receive(:formularios).and_return([formulario1])
      allow(turma2).to receive(:formularios).and_return([formulario2])
      allow(turma3).to receive(:formularios).and_return([formulario3])

      turmas = [turma1, turma2, turma3]
      ids_respondidos = []

      expect(helper.contar_formularios_pendentes(turmas, ids_respondidos)).to eq(3)
    end
  end

  describe '#mensagem_status_formulario' do
    it 'retorna mensagem para status respondido' do
      expect(helper.mensagem_status_formulario('respondido')).to eq('Avaliação Respondida')
    end

    it 'retorna mensagem para status pendente' do
      expect(helper.mensagem_status_formulario('pendente')).to eq('Avaliação Pendente')
    end

    it 'retorna mensagem padrão para status desconhecido' do
      expect(helper.mensagem_status_formulario('outro')).to eq('Status Desconhecido')
    end
  end
end
