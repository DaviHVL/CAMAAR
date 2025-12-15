# Representa uma questão individual dentro de um formulário ativo.
# É criada (geralmente como cópia de uma QuestaoTemplate) quando um formulário
# é distribuído para uma turma, tornando-se independente do template original.
class QuestaoFormulario < ApplicationRecord
  # Associações:
  # - formulario: O questionário ao qual esta pergunta pertence.
  belongs_to :formulario

  # - opcao_formularios: As alternativas de resposta disponíveis (para questões de múltipla escolha).
  #   A opção `dependent: :destroy` garante que as opções sejam apagadas se a questão for excluída.
  has_many :opcao_formularios, dependent: :destroy

  # - questao_respondidas: O conjunto de respostas dadas pelos usuários para esta pergunta específica.
  has_many :questao_respondidas
end