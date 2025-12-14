# Representa uma opção de resposta disponível para uma questão de um formulário.
# (Ex: "Sim", "Não", "Talvez").
#
# Geralmente é criada como uma cópia de uma `OpcaoTemplate` quando um template
# é distribuído para uma turma, garantindo que o histórico do formulário
# se mantenha intacto mesmo se o template original for alterado.
class OpcaoFormulario < ApplicationRecord
  # Associações:
  # - questao_formulario: A questão específica à qual esta opção pertence.
  belongs_to :questao_formulario
end