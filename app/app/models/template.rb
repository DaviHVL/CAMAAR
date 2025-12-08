class Template < ApplicationRecord
  # Associações principais
  belongs_to :usuario # Chave estrangeira: usuario_id
  
  # O nome do modelo de Questão é QuestaoTemplate, e a associação usa o plural snake_case
  has_many :questao_templates, dependent: :destroy

  # Permite que o template processe dados para Questões aninhadas
  # Deve usar o nome da associação no plural snake_case
  accepts_nested_attributes_for :questao_templates, allow_destroy: true 

  # Validação do nome do template (coluna na tabela templates é 'nome')
  validates :nome, presence: true
end