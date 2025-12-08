require 'json'

class SigaaService
  def initialize(classes_path, members_path)
    @classes_path = classes_path
    @members_path = members_path
  end

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