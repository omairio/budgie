class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.float :amount
      t.integer :user_id
      t.string :category
      t.datetime :date
      t.integer :day_spread
      t.float  :per_day
      t.string :description 

      t.timestamps
    end
  end
end
