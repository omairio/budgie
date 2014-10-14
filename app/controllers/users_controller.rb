class UsersController < ApplicationController
  include SessionsHelper

  def new
  	@user = User.new
  end

  def edit
  	if (signed_in?)
      @user = current_user
    else
      redirect_to root_path
    end
  end

  def update
  end

  def create
   @user = User.new(user_params)   
   if (@user.save)
    redirect_to root_path
  else
    render 'new'
  end
end

def destroy
  if (signed_in)
    sign_out
    User.find(params[:id]).destroy
    redirect_to root_path
  end

end

def 
  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, 
     :password, :password_confirmation)
  end
end
