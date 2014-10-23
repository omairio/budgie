class AddDateAndTypeToSession < ActiveRecord::Migration
  def change
  	add_column :users, :date, :date
  	add_column :users, :type, :string
  end
end
