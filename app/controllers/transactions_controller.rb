class TransactionsController < ApplicationController
  include SessionsHelper

  def new
    @transaction = Transaction.new
  end

  def create
    if (signed_in?)
    end
  end

  def update
  end

  def destroy
  end

  def edit
  end
end
