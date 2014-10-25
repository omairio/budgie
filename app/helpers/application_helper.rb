module ApplicationHelper
	def day_transaction(cdate)
		current_user.transactions.where(date: Date.parse(cdate))
	end

	def week_transaction(cdate)
		start_date = Date.parse(cdate)
		end_date = start_date + 1.weeks
		current_user.transactions.where(date: start_date..end_date)
		# current_user.transactions.where("strftime('%Y', date) + 0 = ? and strftime('%m', date) + 0 = ?", Date.today.year, month)
	end

	def month_transaction(cdate)
		start_date = Date.parse(cdate)
		end_date = start_date + 1.months
		current_user.transactions.where(date: start_date..end_date)
		# current_user.transactions.where("strftime('%Y', date) + 0 = ? and strftime('%m', date) + 0 = ?", Date.today.year, month)
	end

	def year_transaction(cdate)
		start_date = Date.parse(cdate)
		end_date = start_date + 1.years
		current_user.transactions.where(date: start_date..end_date)
		# current_user.transactions.where("strftime('%Y', date) + 0 = ?", year)
	end

	def all_transactions()
		current_user.transactions
	end

	def get_total()
		@total = 0
		@transaction_list = Array.new()
		@date_list = Array.new()
		date_hash = Hash.new(0)
		@category_list = Array.new()
		category_hash = Hash.new(0)

		if (!current_user.date_type.nil?)
			if (current_user.date_type == 'All')
				@transactions = all_transactions()
			elsif (current_user.date_type == 'Day')
				@transactions = day_transaction(current_user.date.strftime("%d/%m/%Y"))
			elsif (current_user.date_type == 'Week')
				@transactions = week_transaction(current_user.date.strftime("%d/%m/%Y"))
			elsif (current_user.date_type == 'Month')
				@transactions = month_transaction(current_user.date.strftime("%d/%m/%Y"))
			elsif (current_user.date_type == 'Year')
				@transactions = year_transaction(current_user.date.strftime("%d/%m/%Y"))
			end
			# redirect_to about_path
		else
			@transactions = day_transaction(current_user.date.strftime("%d/%m/%Y"))
		end

		if(current_user.date_type == "Week")
			i = 0
			while (i < 7) do
				@date_list << (current_user.date + i.days).strftime("%a")
				date_hash[@date_list.last] = 0
				i += 1
			end
		elsif (current_user.date_type == "Month")
			i = 0
			while (i <= 31) do
				# @date_list << (current_user.date + i.days).strftime("%B")[0..2] + (current_user.date + i.days).strftime(" %d")
				@date_list << (current_user.date + i.days).strftime("%d/%m")
				date_hash[@date_list.last] = 0
				i += 1
			end
		elsif (current_user.date_type == "Year")
			i = 0
			while (i <= 11) do
				@date_list << (current_user.date + i.months).strftime("%b")
				date_hash[@date_list.last] = 0
				i += 1
			end

		end
		@transactions.each do |t|

			if (current_user.date_type == 'Day')
				@date_list << ""
				@transaction_list << t.amount
			elsif (current_user.date_type == "Week")
				date_hash[t.date.strftime("%a")] += t.amount
			elsif (current_user.date_type == "Month")
				date_hash[t.date.strftime("%d/%m")] += t.amount
			elsif (current_user.date_type == "Year")
				date_hash[t.date.strftime("%b")] += t.amount
			end
			@total += t.amount
		end

		date_hash.keys.each do |k|
			@transaction_list << date_hash[k]
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
