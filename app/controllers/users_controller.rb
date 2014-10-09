class UsersController < ApplicationController
  include SessionsHelper
  def new
  end

  def edit
  	if (!signed_in?)
  		redirect_to root_path
  	else
  		@user = current_user
  	end
  end

  def update
  end

  private
  def user_params
  	 params.require(:user).permit(:first_name, :last_name, :email, 
                                   :password, :password_confirmation)
  end
end
