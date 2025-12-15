# Componente visual responsável por renderizar o "card" de resumo de uma avaliação no Dashboard.
# Exibe informações concisas da disciplina (Matéria, Professor, Semestre) e contém
# o botão de ação para responder ao formulário (ou ver o status).
class EvaluationCardComponent < ViewComponent::Base
  
  # Inicializa o componente com os dados acadêmicos e de navegação.
  # Prepara as variáveis que serão exibidas no template do card.
  #
  # Args:
  #   - turma: (String/Object) Identificador da turma (ex: "A", "01").
  #   - materia: (String) O nome da disciplina (ex: "Engenharia de Software").
  #   - professor: (String | nil) Nome do docente. Se nil, aplica um valor padrão.
  #   - semestre: (String) O período letivo (ex: "2024.1").
  #   - formulario_id: (Integer | nil) ID do formulário associado (para gerar link de resposta).
  #   - turma_id: (Integer | nil) ID da turma no banco (para contexto do link).
  #
  # Retorno: Uma nova instância do componente EvaluationCardComponent.
  #
  # Efeitos Colaterais:
  #   - Define variáveis de instância para uso na view.
  #   - Aplica a string "Professor não atribuído" caso o argumento professor seja nulo.
  def initialize(turma:, materia:, professor:, semestre:, formulario_id: nil, turma_id: nil)
    @turma = turma
    @materia = materia
    @professor = professor || "Professor não atribuído"
    @semestre = semestre
    @formulario_id = formulario_id
    @turma_id = turma_id
  end
end