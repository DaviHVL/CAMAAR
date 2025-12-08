class OpcaoTemplate < ApplicationRecord
  # Chave estrangeira: questao_template_id
  belongs_to :questao_template
  
  # Coluna na tabela é 'texto_opcao'
  validates :texto_opcao, presence: true
  validates :numero_opcao, presence: true # Se você for usar 'numero_opcao'
end