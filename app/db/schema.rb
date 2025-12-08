# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_08_130507) do
  create_table "departamentos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
  end

  create_table "formulario_respondidos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["formulario_id"], name: "index_formulario_respondidos_on_formulario_id"
    t.index ["usuario_id"], name: "index_formulario_respondidos_on_usuario_id"
  end

  create_table "formulario_turmas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_formulario_turmas_on_formulario_id"
    t.index ["turma_id"], name: "index_formulario_turmas_on_turma_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "so_alunos"
    t.string "titulo"
    t.datetime "updated_at", null: false
  end

  create_table "materia", force: :cascade do |t|
    t.string "codigo"
    t.datetime "created_at", null: false
    t.integer "departamento_id", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.index ["departamento_id"], name: "index_materia_on_departamento_id"
  end

  create_table "opcao_formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "numero_opcao"
    t.integer "questao_formulario_id", null: false
    t.string "texto_opcao"
    t.datetime "updated_at", null: false
    t.index ["questao_formulario_id"], name: "index_opcao_formularios_on_questao_formulario_id"
  end

  create_table "opcao_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "numero_opcao"
    t.integer "questao_template_id", null: false
    t.string "texto_opcao"
    t.datetime "updated_at", null: false
    t.index ["questao_template_id"], name: "index_opcao_templates_on_questao_template_id"
  end

  create_table "questao_formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.text "texto_questao"
    t.string "tipo_resposta"
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_questao_formularios_on_formulario_id"
  end

  create_table "questao_respondidas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_respondido_id", null: false
    t.integer "opcao_formulario_id"
    t.integer "questao_formulario_id", null: false
    t.text "resposta"
    t.datetime "updated_at", null: false
    t.index ["formulario_respondido_id"], name: "index_questao_respondidas_on_formulario_respondido_id"
    t.index ["opcao_formulario_id"], name: "index_questao_respondidas_on_opcao_formulario_id"
    t.index ["questao_formulario_id"], name: "index_questao_respondidas_on_questao_formulario_id"
  end

  create_table "questao_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "template_id", null: false
    t.text "texto_questao"
    t.string "tipo_resposta"
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questao_templates_on_template_id"
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["usuario_id"], name: "index_templates_on_usuario_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "materia_id", null: false
    t.string "num_turma"
    t.string "semestre"
    t.datetime "updated_at", null: false
    t.index ["materia_id"], name: "index_turmas_on_materia_id"
  end

  create_table "usuario_turmas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["turma_id"], name: "index_usuario_turmas_on_turma_id"
    t.index ["usuario_id"], name: "index_usuario_turmas_on_usuario_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.boolean "is_admin"
    t.string "matricula"
    t.string "nome"
    t.string "ocupacao"
    t.string "password_digest"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "formulario_respondidos", "formularios"
  add_foreign_key "formulario_respondidos", "usuarios"
  add_foreign_key "formulario_turmas", "formularios"
  add_foreign_key "formulario_turmas", "turmas"
  add_foreign_key "materia", "departamentos"
  add_foreign_key "opcao_formularios", "questao_formularios"
  add_foreign_key "opcao_templates", "questao_templates"
  add_foreign_key "questao_formularios", "formularios"
  add_foreign_key "questao_respondidas", "formulario_respondidos"
  add_foreign_key "questao_respondidas", "opcao_formularios"
  add_foreign_key "questao_respondidas", "questao_formularios"
  add_foreign_key "questao_templates", "templates"
  add_foreign_key "templates", "usuarios"
  add_foreign_key "turmas", "materia", column: "materia_id"
  add_foreign_key "usuario_turmas", "turmas"
  add_foreign_key "usuario_turmas", "usuarios"
end
