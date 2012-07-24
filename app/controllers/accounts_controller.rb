class AccountsController < ApplicationController
 layout 'application'
 before_filter :login_required, :except => [:show, :activate,:change_password]
 #before_filter :not_logged_in_required, :only => [:show,:activate]

 def index
   @user = current_user
   @news_items = NewsItem.find(:all,:conditions=>"created_at > '#{1.week.ago}'", :order=>"created_at desc")
   @recent_tickets = Ticket.find(:all, :conditions=>"status != 'closed' and status != 'resolved' and created_at > '#{5.days.ago}'",:limit=>10)
 end
 
 # Activate action
 def show
   redirect_to accounts_path
   return false
 end
 
 def activate
   # Uncomment and change paths to have user logged in after activation - not recommended
    #self.current_user = User.find_and_activate!(params[:id])
    User.find_and_activate!(params[:id])
    flash[:notice] = "Your account has been activated! You can now login."
    redirect_to login_path
  rescue User::ArgumentError
    flash[:notice] = 'There was an error with the activation code. Please try creating a new account.'
    redirect_to new_user_path 
  rescue User::ActivationCodeNotFound
    flash[:notice] = 'Activation code not found. Please try creating a new account.'
    redirect_to new_user_path
  rescue User::AlreadyActivated
    flash[:notice] = 'Your account has already been activated. You can log in below.'
    redirect_to login_path
 end

 def edit
   user_id = params[:id]
   @user = current_user
   if @user.login != user_id
      redirect_to restricted_path
   end
 end
 
 
 def update
    user_id = params[:id]
    @user = current_user
    if @user.login != user_id
       redirect_to restricted_path
    end
    
    if (params[:user][:password] and params[:user][:password_confirmation]) and (!params[:user][:password].empty? and !params[:user][:password_confirmation].empty?)
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
    end
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account details successfully updated."
      redirect_to accounts_path
    else
     render :action => 'edit'      
    end
 end
 
 # Change password action
 def change_password
 return unless request.post?
   if User.authenticate(current_user.login, params[:old_password])
     if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
       current_user.password_confirmation = params[:password_confirmation]
       current_user.password = params[:password]        
   if current_user.save
         flash[:notice] = "Password successfully updated."
         redirect_to root_path #profile_url(current_user.login)
       else
         flash[:error] = "An error occured, your password was not changed."
         render :action => 'edit'
       end
     else
       flash[:error] = "New password does not match the password confirmation."
       @old_password = params[:old_password]
       render :action => 'edit'      
     end
   else
     flash[:error] = "Your old password is incorrect."
     render :action => 'edit'
   end
 end
 
end

