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
			# amount = t.amount/((current_user.date - t.end_date).to_i)

			start_date = current_user.date
			end_date = start_date
			temp = 0

			if (current_user.date_type == 'Day' or current_user.date_type == "All")
				@date_list << ""
				
				if (current_user.date_type == "All")
					@date_transaction_list << t.amount
					temp += t.amount
				else
					@date_transaction_list << t.per_day
					temp += t.per_day
				end
				
			elsif (current_user.date_type == "Week")
				end_date = start_date + 1.weeks
				format = "%a"
			elsif (current_user.date_type == "Month")
				end_date = start_date + 1.months
				format = "%d/%m"
			elsif (current_user.date_type == "Year")
				end_date = start_date + 1.years
				format = "%b"
			end

			if (start_date != end_date)

				i = 0
				if (t.date <= start_date and start_date <= t.end_date)
					while (i < (t.end_date - start_date).to_i)
						date_hash[(start_date + i.days).strftime(format)] += t.per_day
						temp += t.per_day
						i += 1
					end
				elsif (t.date >= start_date and t.end_date <= end_date)
					while (i < (t.end_date - t.date).to_i)
						date_hash[(t.date + i.days).strftime(format)] += t.per_day
						temp += t.per_day
						i += 1
					end
				elsif (t.date <= end_date and end_date <= t.end_date)
					while (i < (end_date - t.date).to_i)
						date_hash[(t.date + i.days).strftime(format)] += t.per_day
						temp += t.per_day
						i += 1
					end
				end
			end

			if (temp < 0)
				@category_hash[t.category] -= temp
			else 
				@category_hash[t.category] += temp
			end

			@total += temp
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
