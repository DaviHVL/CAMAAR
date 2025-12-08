class QuestaoTemplate < ApplicationRecord
  # Chave estrangeira: template_id
  belongs_to :template 
  
  # Associações para opções
  has_many :opcao_templates, dependent: :destroy
  accepts_nested_attributes_for :opcao_templates, allow_destroy: true

  # Validações baseadas no schema
  validates :texto_questao, presence: true
  validates :tipo_resposta, presence: true
end