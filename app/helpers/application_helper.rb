module ApplicationHelper
	def day_transaction()
		current_user.transactions.where(date: Date.parse(Date.today.strftime("%d-%m-%Y")))
	end

	def month_transaction(month)
		current_user.transactions.where("strftime('%Y', date) + 0 = ? and strftime('%m', date) + 0 = ?", Date.today.year, month)
	end

	def year_transaction(year)
		current_user.transactions.where("strftime('%Y', date) + 0 = ?", year)
	end

	def all_transactions()
		current_user.transactions
	end

	def get_total()
		@total = 0
		@transactions = day_transaction
		@transactions.each do |t|
			@total += t.amount
		end
		@total
	end

	def full_title(page_title)
		base_title = "Budgie"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
