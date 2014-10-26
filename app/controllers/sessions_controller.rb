class SessionsController < ApplicationController
    include SessionsHelper
    include ApplicationHelper

    # Sign in page
    def new
      if (signed_in?)
          @user = current_user
          if (!@user.date_type.nil?)
            if (@user.date_type == 'All')
                @transactions = all_transactions()
            elsif (@user.date_type == 'Day')
                @transactions = day_transaction(@user.date.strftime("%d/%m/%Y"))
            elsif (@user.date_type == 'Week')
                @transactions = week_transaction(@user.date.strftime("%d/%m/%Y"))
            elsif (@user.date_type == 'Month')
                @transactions = month_transaction(@user.date.strftime("%d/%m/%Y"))
            elsif (@user.date_type == 'Year')
                @transactions = year_transaction(@user.date.strftime("%d/%m/%Y"))
            end
            # redirect_to about_path
          else
            @transactions = day_transaction(@user.date.strftime("%d/%m/%Y"))
          end
      end
    end

    def create
      if (params.has_key?(:choosedate))
          current_user.update_attributes(:date_type => params[:choosedate][:type], :date => params[:choosedate][:date])
          new()
          render 'new'
          return
      end

      id = params[:session][:email]
      user = User.find_by(email: id)
      if (user && user.authenticate(params[:session][:password]))
          sign_in user
      else
          if (!user)
            @error = "Username does not exist"
          elsif (!user.authenticate(params[:session][:password]))
            @error = "Password invalid"
          end
      end
      current_user.update_attributes(:date_type => "Day", :date => Date.today)
      @transactions = day_transaction(current_user.date.strftime("%d/%m/%Y"))
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
