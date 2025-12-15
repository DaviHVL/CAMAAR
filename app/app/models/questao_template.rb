# Representa a definição de uma pergunta dentro de um Template de avaliação.
# Serve como o "molde" que será copiado para criar as QuestaoFormulario
# quando o template for distribuído para uma turma.
class QuestaoTemplate < ApplicationRecord
  # Associações:
  # - template: O modelo de avaliação "pai" ao qual esta questão pertence.
  belongs_to :template 
  
  # - opcao_templates: As alternativas de resposta (caso seja uma questão de múltipla escolha).
  #   A opção `dependent: :destroy` garante que, ao apagar a questão, as opções também sejam removidas.
  has_many :opcao_templates, dependent: :destroy

  # Permite que o controller (AdminsController) receba e salve os dados das opções
  # junto com os dados da questão em uma única submissão de formulário.
  accepts_nested_attributes_for :opcao_templates, allow_destroy: true

  # Validações:
  # - texto_questao: O enunciado da pergunta (Obrigatório).
  # - tipo_resposta: Define o formato do input (ex: 'Radio', 'Text') (Obrigatório).
  validates :texto_questao, presence: true
  validates :tipo_resposta, presence: true
end