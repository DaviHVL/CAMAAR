# Serviço responsável por processar e salvar as respostas de um formulário.
#
# Encapsula a lógica de recepção dos parâmetros de resposta, criação do registro
# de "Formulário Respondido" e a persistência individual de cada "Questão Respondida".
class FormResponseService
  
  # Inicializa o serviço com os dados do contexto da resposta.
  #
  # Args:
  #   - user (Usuario): O aluno/usuário que está respondendo.
  #   - formulario (Formulario): O objeto do formulário sendo respondido.
  #   - respostas_params (Hash): Um hash onde a chave é o ID da questão e o valor é a resposta.
  #     Ex: { "12" => "4", "13" => "Texto da resposta" }
  #
  # Retorno: Instância do FormResponseService.
  #
  # Efeitos Colaterais: Apenas atribuição de variáveis de instância.
  def initialize(user, formulario, respostas_params)
    @user = user
    @formulario = formulario
    @respostas_params = respostas_params
  end

  # Executa a lógica principal de salvamento dentro de uma transação.
  # Garante a integridade dos dados: se uma resposta falhar, nada é salvo.
  #
  # Args: Nenhum
  #
  # Retorno:
  #   - O resultado da execução do bloco (geralmente a coleção de respostas processadas).
  #   - Levanta exceção (ActiveRecord::RecordInvalid) se houver erro de validação (tratado no controller).
  #
  # Efeitos Colaterais:
  #   - Cria registro na tabela 'formulario_respondidos'.
  #   - Cria múltiplos registros na tabela 'questao_respondidas'.
  def call
    ActiveRecord::Base.transaction do
      resposta_geral = create_general_response
      process_answers(resposta_geral) if @respostas_params.present?
    end
  end

  private

  # Cria o registro pai que vincula o usuário ao formulário.
  #
  # Args: Nenhum
  #
  # Retorno: Instância de FormularioRespondido persistida.
  #
  # Efeitos Colaterais: Insere um registro no banco de dados.
  def create_general_response
    FormularioRespondido.create!(
      formulario: @formulario,
      usuario: @user
    )
  end

  # Itera sobre o hash de parâmetros para processar cada resposta individualmente.
  #
  # Args:
  #   - resposta_geral (FormularioRespondido): O objeto pai criado anteriormente.
  #
  # Retorno: A coleção (Hash) que foi iterada.
  #
  # Efeitos Colaterais: Chama o método save_answer repetidamente.
  def process_answers(resposta_geral)
    @respostas_params.each do |questao_id, valor|
      save_answer(resposta_geral, questao_id, valor)
    end
  end

  # Encontra a questão correspondente e salva a resposta específica.
  #
  # Args:
  #   - resposta_geral (FormularioRespondido): O vínculo com o formulário pai.
  #   - questao_id (Integer/String): O ID da questão que está sendo respondida.
  #   - valor (String/Integer): O conteúdo da resposta (ID da opção ou texto).
  #
  # Retorno: Boolean (true se salvo com sucesso).
  #
  # Efeitos Colaterais:
  #   - Realiza consulta ao banco (QuestaoFormulario.find).
  #   - Cria registro na tabela 'questao_respondidas'.
  def save_answer(resposta_geral, questao_id, valor)
    questao = QuestaoFormulario.find(questao_id)
    nova_resposta = QuestaoRespondida.new(
      formulario_respondido: resposta_geral,
      questao_formulario: questao
    )

    assign_value(nova_resposta, questao.tipo_resposta, valor)
    nova_resposta.save!
  end

  # Define onde o valor da resposta será armazenado com base no tipo da questão.
  #
  # Args:
  #   - resposta_obj (QuestaoRespondida): O objeto em memória sendo construído.
  #   - tipo (String): O tipo da questão (ex: 'Radio', 'Text').
  #   - valor (String/Integer): O dado enviado pelo usuário.
  #
  # Retorno: O valor atribuído.
  #
  # Efeitos Colaterais:
  #   - Modifica os atributos do objeto 'resposta_obj' em memória.
  #   - Se for 'Radio', preenche 'opcao_formulario_id'.
  #   - Se for outro tipo, preenche 'resposta' (campo de texto livre).
  def assign_value(resposta_obj, tipo, valor)
    if tipo == 'Radio'
      resposta_obj.opcao_formulario_id = valor
    else
      resposta_obj.resposta = valor
    end
  end
end