class TransactionsController < ApplicationController
  include SessionsHelper

  def new
    @new_transaction = Transaction.new
    # redirect_to root_path
  end

  def create
    @new_transaction = Transaction.new(transaction_params)
    @new_transaction.user_id = current_user.id

    # Spread amount over a few days
    @new_transaction.end_date = @new_transaction.date
    @new_transaction.per_day = 0
    @new_transaction.original_spread = @new_transaction.day_spread
    
    if (!@new_transaction.save)
      render 'new'
      return
    end

    if (!@new_transaction.day_spread.nil?)
      if(@new_transaction.spread_type == "Day")
        @new_transaction.end_date += @new_transaction.day_spread.days
      elsif (@new_transaction.spread_type == "Week")
        @new_transaction.end_date += @new_transaction.day_spread.weeks
      elsif (@new_transaction.spread_type == "Month")
        @new_transaction.end_date += @new_transaction.day_spread.months
      elsif (@new_transaction.spread_type == "Year")
        @new_transaction.end_date += @new_transaction.day_spread.years
      end
    else
      render 'new'
      return
    end

    
    cat = @new_transaction.category

    if (cat == "Personal Income" or cat == "Investment Income")
      if (@new_transaction.amount < 0)
        @new_transaction.amount *= -1
      end
    elsif (cat != "Other")
      if (@new_transaction.amount > 0)
         @new_transaction.amount *= -1
      end
    end

    @new_transaction.day_spread = (@new_transaction.end_date - @new_transaction.date).to_i
    @new_transaction.per_day = @new_transaction.amount/(@new_transaction.day_spread)

    if (!@new_transaction.save)
      render 'new'
      return
    end

    redirect_to root_path
    return
  end

  def update
    @new_transaction = Transaction.find(params[:id])

    if (!@new_transaction.update_attributes(transaction_params))
      return
    end

    @new_transaction.date = params[:transaction][:date]
    @new_transaction.end_date = @new_transaction.date

    @new_transaction.spread_type = params[:transaction][:spread_type]
    @new_transaction.day_spread = params[:transaction][:day_spread]
    @new_transaction.original_spread = @new_transaction.day_spread
 
    if(@new_transaction.spread_type == "Day")
      @new_transaction.end_date += @new_transaction.day_spread.days
    elsif (@new_transaction.spread_type == "Week")
      @new_transaction.end_date += @new_transaction.day_spread.weeks
    elsif (@new_transaction.spread_type == "Month")
      @new_transaction.end_date += @new_transaction.day_spread.months
    elsif (@new_transaction.spread_type == "Year")
      @new_transaction.end_date += @new_transaction.day_spread.years
    end

    @new_transaction.day_spread = (@new_transaction.end_date - @new_transaction.date).to_i
    @new_transaction.per_day = @new_transaction.amount/(@new_transaction.day_spread)


    if (@new_transaction.category == "Personal Income" or @new_transaction.category == "Investment Income")
      if (@new_transaction.amount < 0)
        @new_transaction.amount *= -1
      end
    elsif (@new_transaction.category != "Other")
      if (@new_transaction.amount > 0)
        @new_transaction.amount *= -1
      end
    end

    if (!@new_transaction.update_attributes(end_date: @new_transaction.end_date, per_day: @new_transaction.per_day, day_spread: @new_transaction.day_spread))
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
