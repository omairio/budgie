module ApplicationHelper
	def day_transaction(cdate)
		cdate = Date.parse(cdate)
		current_user.transactions.where('date <= ? AND ? <= end_date', cdate, cdate)
	end

	def week_transaction(cdate)
		start_date = Date.parse(cdate)
		end_date = start_date + 1.weeks
		current_user.transactions.where('(date <= ? AND ? <= end_date) OR (date <= ? AND ? <= end_date) OR (date >= ? AND end_date <= ?)', start_date, start_date, end_date, end_date, start_date, end_date)
		# current_user.transactions.where("strftime('%Y', date) + 0 = ? and strftime('%m', date) + 0 = ?", Date.today.year, month)
	end

	def month_transaction(cdate)
		start_date = Date.parse(cdate)
		end_date = start_date + 1.months
		current_user.transactions.where('(date <= ? AND ? <= end_date) OR (date <= ? AND ? <= end_date) OR (date >= ? AND end_date <= ?)', start_date, start_date, end_date, end_date, start_date, end_date)
		# current_user.transactions.where("strftime('%Y', date) + 0 = ? and strftime('%m', date) + 0 = ?", Date.today.year, month)
	end

	def year_transaction(cdate)
		start_date = Date.parse(cdate)
		end_date = start_date + 1.years
		current_user.transactions.where('(date <= ? AND ? <= end_date) OR (date <= ? AND ? <= end_date) OR (date >= ? AND end_date <= ?)', start_date, start_date, end_date, end_date, start_date, end_date)
		# current_user.transactions.where("strftime('%Y', date) + 0 = ?", year)
	end

	def all_transactions()
		current_user.transactions
	end

	def get_total()
		@total = 0
		if (!current_user.date_type.nil?)
			@date_transaction_list = Array.new()
			@date_list = Array.new()
			date_hash = Hash.new(0)
			@category_transaction_list = Array.new()
			@category_hash = Hash.new(0)

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
			amount = t.amount/((current_user.date - t.end_date).to_i)
			if (current_user.date_type == 'Day' or current_user.date_type == "All")
				@date_list << ""
				amount = t.amount
				@date_transaction_list << amount
			elsif (current_user.date_type == "Week")

				date_hash[t.date.strftime("%a")] += amount
			elsif (current_user.date_type == "Month")
				date_hash[t.date.strftime("%d/%m")] += amount
			elsif (current_user.date_type == "Year")
				date_hash[t.date.strftime("%b")] += amount
			end

			if (amount < 0)
				@category_hash[t.category] -= amount
			else 
				@category_hash[t.category] += amount
			end
	

			@total += amount
		end

		date_hash.keys.each do |k|
			@date_transaction_list << date_hash[k]
		end

		# @category_hash.keys.each do |c| 
		# 	@category_transaction_list << @category_hash[c]
		# end

		@total
	end

	def get_categories()
		["Personal Income", "Investment Income", "Food", "Home", 
			"Travel", "Vehicle", "Financial & Profession", "Leisure",
			"Education", "Gadgets & Devices", "Clothes", "Health", "Personal Care",
			"Phone & Internet", "Holidays", "Gambling", "Pets", "Giving to others",
			"Other"]
	end

	def get_spread_types()
		["Day", "Week", "Month", "Year"]
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
