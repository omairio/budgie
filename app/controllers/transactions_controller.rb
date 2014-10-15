class TransactionsController < ApplicationController
  include SessionsHelper

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user_id = current_user.id
    @type = 1
    if(@spread_type == 1)
      @type = 1
    elsif (@spread_type == 2)
      @type = 7
    elsif (@spread_type == 3)
      @type = 30
    elsif (@spread_type == 4)
      @type = 365
    end
    @transaction.per_day = @transaction.amount/(@transaction.day_spread * @type)
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
  end

  def show
  end

  private
  def transaction_params
    params.require(:transaction).permit(:amount, :category, :date, :day_spread, :spread_type, :description)
  end

end
