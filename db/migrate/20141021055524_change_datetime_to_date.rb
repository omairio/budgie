class ChangeDatetimeToDate < ActiveRecord::Migration
	def change
		def up
			change_column :transactions, :date, :date
		end

		def down
			change_column :transactions, :date, :datetime
		end
	end
end
