class ChangeUserTypeToDateType < ActiveRecord::Migration
  def change
  	rename_column :users, :type, :date_type
  end
end
