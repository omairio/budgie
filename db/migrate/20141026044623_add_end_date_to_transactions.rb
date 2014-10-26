class AddEndDateToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :end_date, :date
  end
end
