# Representa o "molde" ou estrutura base de um questionário de avaliação.
# É criado por um administrador e contém o conjunto de perguntas (QuestaoTemplate)
# que serão futuramente copiadas para criar os Formulários reais enviados às turmas.
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

  # Constrói a estrutura inicial de objetos aninhados necessária para renderizar
  # o formulário de criação "nested" na view.
  #
  # Inicializa uma QuestaoTemplate vazia e, dentro dela, uma OpcaoTemplate vazia,
  # garantindo que o usuário veja pelo menos um campo de pergunta ao abrir a tela "Novo".
  #
  # Args: Nenhum
  #
  # Retorno:
  #   - OpcaoTemplate: O último objeto instanciado na cadeia (instância vazia).
  #
  # Efeitos Colaterais:
  #   - Altera o estado do objeto em memória adicionando associações vazias.
  #   - Não salva nada no banco de dados.
  def build_initial_structure
    questao = questao_templates.build
    questao.opcao_templates.build
  end
end