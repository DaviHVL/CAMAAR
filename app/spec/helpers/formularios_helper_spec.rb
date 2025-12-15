require 'rails_helper'

RSpec.describe FormulariosHelper, type: :helper do
  describe '#formato_tipo_resposta' do
    it 'formata texto como Resposta Aberta' do
      expect(helper.formato_tipo_resposta('texto')).to eq('Resposta Aberta')
    end

    it 'formata multipla_escolha como Múltipla Escolha' do
      expect(helper.formato_tipo_resposta('multipla_escolha')).to eq('Múltipla Escolha')
    end

    it 'humaniza tipos desconhecidos' do
      expect(helper.formato_tipo_resposta('outro_tipo')).to eq('Outro tipo')
    end
  end

  describe '#classe_tipo_resposta' do
    it 'retorna classe azul para tipo texto' do
      expect(helper.classe_tipo_resposta('texto')).to eq('bg-blue-50 border-blue-200')
    end

    it 'retorna classe roxa para multipla_escolha' do
      expect(helper.classe_tipo_resposta('multipla_escolha')).to eq('bg-purple-50 border-purple-200')
    end

    it 'retorna classe cinza para tipos desconhecidos' do
      expect(helper.classe_tipo_resposta('desconhecido')).to eq('bg-gray-50 border-gray-200')
    end
  end

  describe '#formulario_tem_questoes?' do
    it 'retorna true quando formulário tem questões' do
      formulario = Formulario.create!(titulo: "Teste")
      QuestaoFormulario.create!(texto_questao: "Pergunta 1", tipo_resposta: "texto", formulario: formulario)
      
      expect(helper.formulario_tem_questoes?(formulario)).to be_truthy
    end

    it 'retorna false quando formulário não tem questões' do
      formulario = Formulario.create!(titulo: "Teste Vazio")
      
      expect(helper.formulario_tem_questoes?(formulario)).to be_falsy
    end
  end
end
