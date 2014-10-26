class AddOriginalQuanitityToTransaction < ActiveRecord::Migration
  def change
  	add_column :transactions, :original_spread, :integer
  end
end
