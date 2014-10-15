class TransactionsController < ApplicationController
  include SessionsHelper

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user_id = current_user.id

    # Spread amount over a few days
    @type = 1
    if (!@transaction.day_spread.nil?)
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
    end

    if (@transaction.save)
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update
  end

  def destroy
    if (signed_in?)
      post = Post.find(params[:id])
      if (current_user.id == post.user_id)
        post.destroy
      end
    end
    render 'show'
  end

  def edit
    if (signed_in?)
      post = Post.find(params[:id])
      if (current_user.id == post.user_id)
        post.destroy
      end
    end
  end

  def show
  end

  private
  def transaction_params
    params.require(:transaction).permit(:amount, :category, :date, :day_spread, :spread_type, :description)
  end

end
