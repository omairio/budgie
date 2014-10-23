describe TransactionController do
	describe "new" do
		it "returns an empty transaction" do
			Transaction.new.should = {}
		end
	end

	describe "create" do
		before do
			@trans = Transaction.new(transaction_params)
			@trans.user = current_user.id
		end

		it "has amount greater than or equal to zero" do
			@trans.amount.should be >= 0
		end

		it "has a valid date" do
			@trans.date.should be_betweem(Date.today - 100.year, Date.today + 100.year)
		end

		it "has a non-empty category" do
			@trans.category.should_not be_blank
		end 
	end

	describe "update" do
		it "finds a valid transaction" do
			@trans = Transaction.find(params[:id])
			@trans.should_not be_blank
		end
	end

	describe "destroy" do
		before do
			@trans = Transaction.new
		end

		it "correctly destroys a transaction" do
			@trans.destroy
			@trans.should_not exist
		end

	end

end