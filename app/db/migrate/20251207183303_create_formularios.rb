class CreateFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :formularios do |t|
      t.string :titulo
      t.boolean :so_alunos

      t.timestamps
    end
  end
end
