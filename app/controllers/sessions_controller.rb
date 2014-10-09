class SessionsController < ApplicationController
   include SessionsHelper
   def new
      redirect_to root_path
   end
   def create
      @error=''
      id = params[:session][:email]
      user = User.find_by(email: id)
      if (user && user.authenticate(params[:session][:password]))
         sign_in user
         redirect_to root_path
      else
         if (!user)
            @error = "You don't belong here, do you?"
         elsif (!user.authenticate(params[:session][:password]))
            @error = "Tsk tsk."
         end
         redirect_to root_path
      end

   end
   def destroy
      sign_out
      redirect_to root_path
   end
end
