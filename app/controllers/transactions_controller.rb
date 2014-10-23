class TransactionsController < ApplicationController
  include SessionsHelper

  def new
    @transaction = Transaction.new
    # redirect_to root_path
  end

  def create
    transaction = Transaction.new(transaction_params)
    transaction.user_id = current_user.id

    # Spread amount over a few days
    type = 1
    if (!transaction.day_spread.nil?)
      if(transaction.spread_type == "Day")
        type = 1
      elsif (transaction.spread_type == "Week")
        type = 7
      elsif (transaction.spread_type == "Month")
        type = 30
      elsif (transaction.spread_type == "Year")
        type = 365
      end
    end

    day_amount = transaction.day_spread * type
    transaction.amount = transaction.amount/(day_amount)

    cat = transaction.category

    if (cat == "Personal Income" or cat == "Investment Income")
      if (transaction.amount < 0)
        transaction.amount *= -1
      end
    elsif (cat != "Other")
      if (transaction.amount > 0)
        transaction.amount *= -1
      end
    end

    if (!transaction.save)
      render 'new'
      return
    end    

    i = 1
    while i < (day_amount) do 
      transaction_new = Transaction.new(transaction_params)
      transaction_new.user_id = current_user.id
      transaction_new.amount = transaction.amount
      transaction_new.date = transaction.date + 1.days
      transaction = transaction_new
      @yes = transaction.save
      i += 1
    end

    redirect_to root_path
    return
  end

  def update
    @transaction = Transaction.find(params[:id])

    @type = 1
    if(@transaction.spread_type == "Day")
      @type = 1
    elsif (@transaction.spread_type == "Week")
      @type = 7
    elsif (@transaction.spread_type == "Month")
      @type = 30
    elsif (@transaction.spread_type == "Year")
      @type = 365
    end

    @transaction.per_day = @transaction.amount/(@transaction.day_spread * @type)

    @cat = @transaction.category

    if (@cat == "Personal Income" or @cat == "Investment Income")
      if (@transaction.amount < 0)
        @transaction.amount *= -1
      end
    elsif (@cat != "Other")
      if (@transaction.amount > 0)
        @transaction.amount *= -1
      end
    end

    if (@transaction.update_attributes(transaction_params))
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def show
    destroy
  end

  def destroy
    if (signed_in?)
      transaction = Transaction.find(params[:id])
      if (current_user.id == transaction.user_id)
        transaction.destroy
      end
    end
    redirect_to root_path
  end

  def edit
    if (signed_in?)
      @transaction = Transaction.find(params[:id])
      if (current_user.id == @transaction.user_id)
      end
    end
  end
  
  private
  def transaction_params
    params.require(:transaction).permit(:amount, :category, :date, :day_spread, :spread_type, :description)
  end

end
