module ApplicationHelper
	def day_transaction()
		current_user.transactions.where(date: Date.parse(Date.today.strftime("%d-%m-%Y")))
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
