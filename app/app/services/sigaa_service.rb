require 'json'

class SigaaService
  def initialize(classes_path, members_path)
    @classes_path = classes_path
    @members_path = members_path
  end

  def call
    import_classes if File.exist?(@classes_path)
    
    import_members if File.exist?(@members_path)
  end

  private

  def import_classes
    file_content = File.read(@classes_path)
    data = JSON.parse(file_content)

    data.each do |entry|
      dept_code = entry['code'][0..2] 
      
      departamento = Departamento.find_or_create_by!(nome: dept_code) # Usando o código como nome provisório

      materia = Materia.find_or_create_by!(codigo: entry['code']) do |m|
        m.nome = entry['name']
        m.departamento = departamento
      end

      Turma.find_or_create_by!(
        num_turma: entry['class']['classCode'],
        semestre: entry['class']['semester'],
        materia: materia
      )
    end
  end

  def import_members
    file_content = File.read(@members_path)
    data = JSON.parse(file_content)

    data.each do |entry|
      materia = Materia.find_by(codigo: entry['code'])
      next unless materia # Pula se a matéria não existir

      turma = Turma.find_by(
        num_turma: entry['classCode'],
        semestre: entry['semester'],
        materia: materia
      )
      next unless turma # Pula se a turma não existir

      if entry['docente']
        process_user(entry['docente'], turma, 'Professor')
      end

      entry['dicente']&.each do |student_data|
        process_user(student_data, turma, 'Aluno')
      end
    end
  end

  def process_user(user_data, turma, ocupacao_padrao)
    usuario = Usuario.find_or_initialize_by(matricula: user_data['usuario'])

    if usuario.new_record?
      usuario.nome = user_data['nome']
      usuario.email = user_data['email']
      usuario.ocupacao = ocupacao_padrao

      usuario.password = user_data['usuario'] 
      usuario.password_confirmation = user_data['usuario']
      usuario.is_admin = false
      usuario.save!
    end

    UsuarioTurma.find_or_create_by!(
      usuario: usuario,
      turma: turma
    )
  end
end