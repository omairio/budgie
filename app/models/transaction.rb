class Transaction < ActiveRecord::Base

	belongs_to :user

	# VALID_TRANSACTION_REGEX = /\A[a-zA-z]+\z/i

	# Order by descending order
	default_scope -> { order('created_at DESC') }

	validates(:amount, {
				presence: true,
				numericality: {only_float: true}
	})
	validates(:user_id, {
				presence: true,
	})

	validates(:date, {
				presence: true,
	})

	# Day spread has a max value of the number of days in a year
	validates(:day_spread, {
				presence: true,
				numericality: {greater_than: 0, less_than: 365}
	})

	validates(:per_day, {
				presence: true,
	})
	validates(:category, {
				presence: true,
				length: { maximum: 50 }
	})
	validates(:description, {
				length: { maximum: 100 }
	})

end
