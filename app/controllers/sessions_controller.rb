class SessionsController < ApplicationController
   include SessionsHelper
   include ApplicationHelper

   # Sign in page
   def new
      if (signed_in?)
         @user = current_user
         @transactions = day_transaction()
      end
   end

   def create
      id = params[:session][:email]
      user = User.find_by(email: id)
      if (user && user.authenticate(params[:session][:password]))
         @error = "Poop"
         sign_in user
      else
         if (!user)
            @error = "Username does not exist"
         elsif (!user.authenticate(params[:session][:password]))
            @error = "Password invalid"
         end
      end
      @new_session = 'cool'
      render 'new'
   end

   # Sign out
   def destroy
      if (signed_in?)
         sign_out
         @message = "Successfully logged out"
      end
      redirect_to root_path
   end
end
