# Representa o modelo de Formulário, contendo as definições das questões.
# É a entidade central que conecta as perguntas (QuestaoFormulario), 
# as turmas onde foi aplicado (FormularioTurma) e as respostas dos alunos (FormularioRespondido).
class Formulario < ApplicationRecord
  has_many :questao_formularios, dependent: :destroy
  has_many :formulario_respondidos, dependent: :destroy
  has_many :formulario_turmas
  has_many :turmas, through: :formulario_turmas

  # Gera uma string formatada em CSV contendo os dados consolidados das respostas.
  # Delega a complexidade de formatação para o serviço FormularioExportService.
  #
  # Args: Nenhum
  #
  # Retorno:
  #   - String: O conteúdo textual do CSV gerado (cabeçalhos + linhas de resposta).
  #
  # Efeitos Colaterais:
  #   - Realiza consultas ao banco de dados (via Service) para buscar questões e respostas associadas.
  #   - Não altera dados no banco.
  def gerar_csv
    FormularioExportService.new(self).call
  end
end