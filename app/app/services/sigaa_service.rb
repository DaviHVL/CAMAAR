require 'json'

# Service Object responsável pela importação de dados acadêmicos (SIGAA).
# Processa arquivos JSON contendo Turmas e Membros para popular o banco de dados
# com Departamentos, Matérias, Turmas e Usuários (Docentes e Discentes).
class SigaaService
  
  # Inicializa o serviço com os caminhos dos arquivos a serem processados.
  #
  # Args:
  #   - classes_path (String): Caminho absoluto ou relativo para o arquivo JSON de turmas.
  #   - members_path (String): Caminho absoluto ou relativo para o arquivo JSON de membros.
  #
  # Retorno: Instância do SigaaService.
  #
  # Efeitos Colaterais: Apenas atribuição de variáveis de instância.
  def initialize(classes_path, members_path)
    @classes_path = classes_path
    @members_path = members_path
  end

  # Método principal que orquestra o fluxo de importação.
  # Verifica a existência dos arquivos e dispara os métodos de processamento específicos.
  #
  # Args: Nenhum
  #
  # Retorno: nil (O retorno é a saída do último puts, irrelevante para a lógica).
  #
  # Efeitos Colaterais:
  #   - Imprime logs no console (puts).
  #   - Dispara a criação de registros no banco de dados (via métodos privados).
  def call
    puts ">>> INICIANDO SERVIÇO SIGAA <<<"
    
    if File.exist?(@classes_path)
      puts "> Arquivo de Turmas encontrado. Processando..."
      import_classes 
    else
      puts "> ERRO: Arquivo de Turmas NÃO encontrado no caminho: #{@classes_path}"
    end
    
    if File.exist?(@members_path)
      puts "> Arquivo de Membros encontrado. Processando..."
      import_members 
    else
      puts "> ERRO: Arquivo de Membros NÃO encontrado no caminho: #{@members_path}"
    end
    
    puts ">>> SERVIÇO FINALIZADO <<<"
  end

  private

  # Lê o JSON de turmas e cria a estrutura acadêmica básica.
  #
  # Args: Nenhum
  #
  # Retorno: A coleção iterada ou nil em caso de erro.
  #
  # Efeitos Colaterais:
  #   - Lê arquivos do disco (File.read).
  #   - Cria ou encontra registros de: Departamento, Materia e Turma.
  #   - Imprime logs de progresso.
  def import_classes
    file_content = File.read(@classes_path)
    data = JSON.parse(file_content)
    puts "> Lendo #{data.size} matérias do JSON..."

    data.each do |entry|
      # Dept Code
      dept_code = entry['code'][0..2] 
      dep = Departamento.find_or_create_by!(nome: dept_code)

      # Matéria
      mat = Materia.find_or_create_by!(codigo: entry['code']) do |m|
        m.nome = entry['name']
        m.departamento = dep
      end
      puts "  - Matéria Processada: #{mat.nome} (#{mat.codigo})"

      # Turma
      turma = Turma.find_or_create_by!(
        num_turma: entry['class']['classCode'],
        semestre: entry['class']['semester'],
        materia: mat
      )
      puts "  - Turma Criada/Encontrada: #{turma.num_turma} - #{turma.semestre}"
    end
  rescue => e
    puts "CRASH EM IMPORT_CLASSES: #{e.message}"
  end

  # Lê o JSON de membros e popula os usuários e matrículas.
  #
  # Args: Nenhum
  #
  # Retorno: A coleção iterada ou nil em caso de erro.
  #
  # Efeitos Colaterais:
  #   - Lê arquivos do disco.
  #   - Realiza consultas ao banco para encontrar Matérias e Turmas existentes.
  #   - Chama process_user para criar Docentes e Discentes.
  def import_members
    file_content = File.read(@members_path)
    data = JSON.parse(file_content)
    puts "> Lendo #{data.size} grupos de membros..."

    data.each do |entry|
      puts "> Verificando grupo: #{entry['code']} - Turma #{entry['classCode']}"

      materia = Materia.find_by(codigo: entry['code'])
      unless materia
        puts "  [PULADO] Matéria #{entry['code']} não existe no banco."
        next
      end

      turma = Turma.find_by(
        num_turma: entry['classCode'],
        semestre: entry['semester'],
        materia: materia
      )
      unless turma
        puts "  [PULADO] Turma #{entry['classCode']} não encontrada para esta matéria."
        next
      end

      # Docente
      if entry['docente']
        puts "  -> Processando Docente..."
        process_user(entry['docente'], turma, 'docente')
      end

      # Discentes
      if entry['dicente']
        puts "  -> Processando #{entry['dicente'].size} Discentes..."
        entry['dicente'].each do |student_data|
          process_user(student_data, turma, 'discente')
        end
      end
    end
  rescue => e
    puts "CRASH EM IMPORT_MEMBERS: #{e.message}"
  end

  # Método auxiliar para persistir um usuário e vinculá-lo a uma turma.
  #
  # Args:
  #   - user_data (Hash): Dados do usuário vindos do JSON (nome, usuario, email).
  #   - turma (Turma): Objeto da turma onde o usuário será vinculado.
  #   - ocupacao_padrao (String): 'docente' ou 'discente'.
  #
  # Retorno:
  #   - UsuarioTurma: Se o salvamento for bem-sucedido.
  #   - nil: Se houver erro de validação.
  #
  # Efeitos Colaterais:
  #   - Cria ou Atualiza registros na tabela Usuario.
  #   - Cria registros na tabela UsuarioTurma (Matrícula).
  #   - Imprime erros de validação caso ocorram.
  def process_user(user_data, turma, ocupacao_padrao)
    usuario = Usuario.find_or_initialize_by(matricula: user_data['usuario'])
    
    usuario.nome = user_data['nome']
    usuario.email = user_data['email']
    usuario.ocupacao = ocupacao_padrao
    usuario.password = user_data['usuario'] 
    usuario.password_confirmation = user_data['usuario']
    usuario.is_admin = false if usuario.new_record?
    
    if usuario.save
      print "." # Imprime um pontinho para cada sucesso
      UsuarioTurma.find_or_create_by!(usuario: usuario, turma: turma)
    else
      puts "\n  [ERRO AO SALVAR USER] #{usuario.nome}: #{usuario.errors.full_messages.join(', ')}"
    end
  end
end