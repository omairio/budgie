module TransactionsHelper
	def day_transaction()
		current_user.transactions.where(date: Date.parse(Date.today.strftime("%d-%m-%Y")))
	end
end
