class AddSpreadTypeToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :spread_type, :string
  end
end
