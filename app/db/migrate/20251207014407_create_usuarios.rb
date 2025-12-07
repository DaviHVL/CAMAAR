class CreateUsuarios < ActiveRecord::Migration[8.1]
  def change
    create_table :usuarios do |t|
      t.string :email
      t.string :password_digest
      t.string :nome
      t.string :matricula
      t.boolean :is_admin

      t.timestamps
    end
  end
end
