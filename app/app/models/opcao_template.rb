# Representa uma opção de resposta predefinida para uma Questão de Template.
# É utilizada em questões de múltipla escolha (ex: "Concordo totalmente", "Discordo")
# durante a criação de um modelo de avaliação (Template) pelo administrador.
class OpcaoTemplate < ApplicationRecord
  # Associações:
  # - questao_template: A questão "pai" à qual esta opção pertence.
  belongs_to :questao_template
  
  # Validações:
  # - texto_opcao: O texto visível da opção (Obrigatório).
  # - numero_opcao: A ordem ou valor numérico da opção para ordenação (Obrigatório).
  validates :texto_opcao, presence: true
  validates :numero_opcao, presence: true 
end