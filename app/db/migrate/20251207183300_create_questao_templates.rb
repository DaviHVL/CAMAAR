class CreateQuestaoTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :questao_templates do |t|
      t.text :texto_questao
      t.string :tipo_resposta
      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
