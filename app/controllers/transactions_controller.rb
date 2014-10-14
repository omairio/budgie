class TransactionsController < ApplicationController
  include SessionsHelper

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user_id = current_user.id
    if @transaction.save
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
    params.require(:transaction).permit(:amount, :category, :date, :day_spread)
  end

end
