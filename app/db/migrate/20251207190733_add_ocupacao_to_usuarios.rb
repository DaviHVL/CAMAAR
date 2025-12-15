class AddOcupacaoToUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios, :ocupacao, :string
  end
end
