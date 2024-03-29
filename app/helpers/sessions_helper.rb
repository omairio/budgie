module SessionsHelper
   def sign_in(user)
      remember_token = User.new_remember_token
      cookies.permanent[:remember_token] = {
         value: remember_token,
         expires: 1.year.from_now.utc
      }
      user.update_attribute(:remember_token, User.encrypt(remember_token))
      self.current_user = user
      current_user.update_attributes(:date => Date.today, :date_type => 'All')
   end

   def sign_out
      if (!current_user.nil?)
         current_user.update_attribute(:remember_token,
            User.encrypt(User.new_remember_token))
      end
      cookies.delete(:remember_token)
      self.current_user = nil
   end

   def current_user=(user)
      @current_user = user
   end

   def current_user
      remember_token = User.encrypt(cookies[:remember_token])
      @current_user ||= User.find_by(remember_token: remember_token)
   end

   def signed_in?
      !current_user.nil?
   end

end
