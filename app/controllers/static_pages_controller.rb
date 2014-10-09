class StaticPagesController < ApplicationController
	include SessionsHelper
	def home
		if (signed_in?)
			@user = current_user
		end
	end

	def about
	end

	def transactions
	end

	def account
	end
end
