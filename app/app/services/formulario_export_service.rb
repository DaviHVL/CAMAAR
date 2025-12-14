require 'csv'

# Service Object responsável pela exportação dos dados de um formulário para o formato CSV.
#
# Encapsula a lógica de formatação de colunas, cabeçalhos dinâmicos (baseados nas perguntas)
# e a consolidação das respostas dos alunos em linhas.
class FormularioExportService
  
  # Inicializa o serviço preparando os dados necessários.
  # Carrega as questões ordenadas por ID para garantir que as colunas do CSV
  # sigam sempre a mesma ordem lógica.
  #
  # Args:
  #   - formulario (Formulario): A instância do formulário cujos dados serão exportados.
  #
  # Retorno: Instância do FormularioExportService.
  #
  # Efeitos Colaterais: Atribui variáveis de instância (@formulario e @questoes).
  def initialize(formulario)
    @formulario = formulario
    @questoes = @formulario.questao_formularios.order(:id)
  end

  # Executa a geração do conteúdo CSV.
  # Cria a estrutura do arquivo, adiciona o cabeçalho e itera sobre todas as respostas.
  #
  # Args: Nenhum
  #
  # Retorno:
  #   - String: O conteúdo textual completo do CSV gerado.
  #
  # Efeitos Colaterais:
  #   - Dispara consultas ao banco de dados (via responses_scope).
  #   - Não altera dados no banco.
  def call
    CSV.generate(headers: true) do |csv|
      csv << headers

      responses_scope.each do |resposta_geral|
        csv << build_row(resposta_geral)
      end
    end
  end

  private

  # Constrói a primeira linha do CSV (Cabeçalho).
  # Combina colunas fixas ('Matrícula', 'Nome') com as perguntas do formulário.
  #
  # Args: Nenhum
  #
  # Retorno:
  #   - Array<String>: Lista de títulos das colunas.
  #
  # Efeitos Colaterais: Nenhum.
  def headers
    ['Matrícula', 'Nome'] + @questoes.map(&:texto_questao)
  end

  # Define o escopo de busca das respostas no banco de dados.
  # Utiliza 'includes' (Eager Loading) para carregar Usuário, Questões Respondidas
  # e Opções de uma só vez, evitando o problema de N+1 queries.
  #
  # Args: Nenhum
  #
  # Retorno:
  #   - ActiveRecord::Relation: Coleção de objetos FormularioRespondido.
  #
  # Efeitos Colaterais: Executa a query SQL otimizada.
  def responses_scope
    @formulario.formulario_respondidos
               .includes(:usuario, questao_respondidas: :opcao_formulario)
  end

  # Monta uma única linha de dados para o CSV, correspondente a um aluno.
  #
  # Args:
  #   - resposta_geral (FormularioRespondido): O objeto contendo o vínculo Usuario-Formulario.
  #
  # Retorno:
  #   - Array: Os valores da linha (Matrícula, Nome, Resposta 1, Resposta 2...).
  #
  # Efeitos Colaterais: Processamento de dados em memória.
  def build_row(resposta_geral)
    respostas_map = map_answers(resposta_geral)
    usuario = resposta_geral.usuario

    row = [usuario.matricula, usuario.nome]

    @questoes.each do |questao|
      row << extract_value(respostas_map[questao.id])
    end

    row
  end

  # Cria um Hash de mapeamento para acesso rápido às respostas.
  # Transforma a lista de respostas em um dicionário onde a Chave é o ID da Questão.
  # Isso evita ter que fazer um .find dentro do loop de colunas.
  #
  # Args:
  #   - resposta_geral (FormularioRespondido): O objeto pai das respostas.
  #
  # Retorno:
  #   - Hash: { questao_id => objeto_QuestaoRespondida }.
  #
  # Efeitos Colaterais: Nenhum.
  def map_answers(resposta_geral)
    resposta_geral.questao_respondidas.index_by(&:questao_formulario_id)
  end

  # Extrai o texto legível da resposta, lidando com diferentes tipos de pergunta.
  #
  # Args:
  #   - resposta (QuestaoRespondida | nil): O objeto resposta (pode ser nulo se o aluno pulou).
  #
  # Retorno:
  #   - String: O texto da opção escolhida (se for Multipla Escolha).
  #   - String: O texto digitado (se for Dissertativa).
  #   - nil: Se não houver resposta.
  #
  # Efeitos Colaterais: Nenhum.
  def extract_value(resposta)
    resposta&.opcao_formulario&.texto_opcao || resposta&.resposta
  end
end