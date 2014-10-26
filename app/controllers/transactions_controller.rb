class TransactionsController < ApplicationController
  include SessionsHelper

  def new
    @new_transaction = Transaction.new
    # redirect_to root_path
  end

  def create
    transaction = Transaction.new(transaction_params)
    transaction.user_id = current_user.id

    # Spread amount over a few days
    transaction.end_date = transaction.date
    transaction.per_day = 0

    if (!transaction.save)
      @new_transaction = Transaction.new
      new()
      render 'new'
      return
    end

    if (!transaction.day_spread.nil?)
      if(transaction.spread_type == "Day")
        transaction.end_date += transaction.day_spread.days
      elsif (transaction.spread_type == "Week")
        transaction.end_date += transaction.day_spread.weeks
      elsif (transaction.spread_type == "Month")
        transaction.end_date += transaction.day_spread.months
      elsif (transaction.spread_type == "Year")
        transaction.end_date += transaction.day_spread.years
      end
    else
      @new_transaction = Transaction.new
      new()
      render 'new'
      return
    end

    
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

    transaction.day_spread = (transaction.end_date - transaction.date).to_i
    transaction.per_day = transaction.amount/(transaction.day_spread)

    if (!transaction.save)
      @new_transaction = Transaction.new
      new()
      render 'new'
      return
    end

    redirect_to root_path
    return
  end

  def update
    transaction = Transaction.find(params[:id])

    if (!transaction.update_attributes(transaction_params))
      return
    end

    transaction.date = params[:transaction][:date]
    transaction.end_date = transaction.date

    transaction.spread_type = params[:transaction][:spread_type]
    transaction.day_spread = params[:transaction][:day_spread]

    # if (transaction.end_date.nil?)
    #   redirect_to about_path
    #   return
    # end

    if(transaction.spread_type == "Day")
      transaction.end_date += transaction.day_spread.days
    elsif (transaction.spread_type == "Week")
      transaction.end_date += transaction.day_spread.weeks
    elsif (transaction.spread_type == "Month")
      transaction.end_date += transaction.day_spread.months
    elsif (transaction.spread_type == "Year")
      transaction.end_date += transaction.day_spread.years
    end

    transaction.day_spread = (transaction.end_date - transaction.date).to_i
    transaction.per_day = transaction.amount/(transaction.day_spread)


    if (transaction.category == "Personal Income" or transaction.category == "Investment Income")
      if (transaction.amount < 0)
        transaction.amount *= -1
      end
    elsif (transaction.category != "Other")
      if (transaction.amount > 0)
        transaction.amount *= -1
      end
    end

    if (!transaction.update_attributes(end_date: transaction.end_date, per_day: transaction.per_day, day_spread: transaction.day_spread))
      edit()
      render 'edit'
      return
    end
    redirect_to root_path
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
