# Representa a resposta individual dada por um usuário para uma única questão.
# É a menor unidade de informação de uma avaliação preenchida.
#
# Armazena o vínculo entre a pergunta feita (QuestaoFormulario) e o
# formulário preenchido (FormularioRespondido), contendo a escolha do usuário.
class QuestaoRespondida < ApplicationRecord
  # Associações:
  
  # - formulario_respondido: O registro "pai" que agrupa todas as respostas deste envio.
  belongs_to :formulario_respondido
  
  # - questao_formulario: A definição da pergunta que foi respondida.
  belongs_to :questao_formulario
  
  # - opcao_formulario: A alternativa específica selecionada pelo usuário.
  #   Configurado como `optional: true` porque, em casos de perguntas dissertativas
  #   (texto livre), não existe uma opção selecionada (o valor fica nulo e a resposta vai em outra coluna).
  belongs_to :opcao_formulario, optional: true
end