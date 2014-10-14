class Transaction < ActiveRecord::Base

	belongs_to :user
	
# 	validates(:amount, { 
# 		presence: true, 
# 		})
# 	validates(:user_id, { 
# 		presence: true, 
# 		})

# 	validates(:date, { 
# 		presence: true, 
# 		})

# # Day spread has a max value of the number of days in a year
# 	validates(:day_spread, { 
# 		presence: true,
# 		in: 1..364
# 		})

# 	validates(:per_day, { 
# 		presence: true, 
# 		})
# 	validates(:category, { 
# 		presence: true, 
# 		length: { maximum: 50 }
# 		})
# 	validates(:description, { 
# 		presence: true, 
# 		length: { maximum: 100 }
# 		})

end
