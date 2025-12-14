# Representa a concretização de uma avaliação respondida por um usuário.
# Atua como a entidade "pai" que agrupa todas as respostas individuais (QuestaoRespondida)
# de um aluno para um determinado formulário.
class FormularioRespondido < ApplicationRecord
  # Associações:
  # - formulario: O questionário base que foi respondido.
  # - usuario: O aluno ou professor que submeteu as respostas.
  belongs_to :formulario
  belongs_to :usuario

  # As respostas específicas para cada pergunta do formulário.
  # A opção `dependent: :destroy` garante que, se a resposta geral for excluída,
  # as respostas das questões individuais também sejam removidas do banco.
  has_many :questao_respondidas, dependent: :destroy
  
  # Configuração que permite criar/salvar o objeto FormularioRespondido e 
  # seus objetos filhos (QuestaoRespondida) em uma única transação.
  # Essencial para o funcionamento do FormResponseService.
  accepts_nested_attributes_for :questao_respondidas
end