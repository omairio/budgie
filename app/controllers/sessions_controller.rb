class SessionsController < ApplicationController
   include SessionsHelper


   # Sign in page
   def new
      if (signed_in?)
         @user = current_user
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
      render 'new'
   end

   # Sign out
   def destroy
      sign_out
      @message = "Successfully logged out"
      render 'new'
   end
end
