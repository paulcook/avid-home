class UsersController < ApplicationController
 layout 'application'
 before_filter :not_logged_in_required, :only => [:new, :create] 
 before_filter :login_required, :only => [:edit, :update, :show]
 before_filter :check_administrator_role, :only => [:index, :edit, :update, :destroy, :enable]
 
 def index
   @users = User.paginate :page=>params[:page], :order=>'login asc'
 end
 
 def search
   search_conditions = Array.new
   if params[:login] and !params[:login].empty?
     search_conditions << "login ~* '#{params[:login]}' "
   end
   if params[:email] and !params[:email].empty?
     search_conditions << "login ~* '#{params[:email]}' "
   end
   unless search_conditions.empty?
     @users = User.paginate :page=>params[:page], :order=>'login asc', :conditions=>search_conditions.join(" and ")
   else
     flash[:notice] = "Search parameters were empty."
     @users = User.paginate :page=>params[:page], :order=>'login asc'
   end
   respond_to do |format|
     format.html { render :action=>:index }
   end
 end
 
 #This show action only allows users to view their own profile
 def show
   @user = User.find_by_param(params[:id])
 end
   
 # render new.rhtml
 def new
   @user = User.new
 end

 def create
   cookies.delete :auth_token
   @user = User.new(params[:user])
   @user.password = params[:user][:password]
   @user.password_confirmation = params[:user][:password_confirmation]
   @user.save!
   #Uncomment to have the user logged in after creating an account - Not Recommended
   #self.current_user = @user
 flash[:notice] = "Thanks for signing up! Please check your email to activate your account before logging in."
   redirect_to login_path    
 rescue ActiveRecord::RecordInvalid
   flash[:error] = "There was a problem creating your account."
   render :action => 'new'
 end
 
 def edit
   @user = User.find(:first,:conditions=>"login='#{params[:id]}'")
   @user.password = ""
 end
 
 def update
   @user = User.find(:first,:conditions=>"login='#{params[:id]}'")
   donator = @user.donator
   subscriber = @user.subscriber
   
   @user.donator = params[:user][:dontar]
   @user.donated_on = params[:user][:dontated_on] unless params[:user][:dontated_on].nil?
   @user.subscriber = params[:user][:subscriber]
   @user.subscriber_until = params[:user][:subscriber_until] unless params[:user][:subscriber_until].nil?
   @user.subscribed_on = params[:user][:subscribed_on] unless params[:user][:subscribed_on].nil?
   if (params[:user][:password] and params[:user][:password_confirmation]) and (!params[:user][:password].empty? and !params[:user][:password_confirmation].empty?)
     @user.password = params[:user][:password]
     @user.password_confirmation = params[:user][:password_confirmation]
   end
   
   if @user.update_attributes(params[:user])
     if params[:user][:donator].to_i == 1 and donator == 0
       @user.donated_on = Date.today
       @user.toggle!(:donator)
     end
     
     if params[:user][:donator].to_i == 0 and donator == 1
        @user.donated_on = nil
        @user.toggle!(:donator)
      end
    
      if params[:user][:subscriber].to_i == 1 and subscriber == 0
        @user.subscriber_until = @user.subscribed_on.to_time.next_year.to_date
        @user.save
      elsif params[:user][:subscriber].to_i == 0 and subscriber == 1
        @user.subscribed_on = nil
        @user.subscriber_until = nil
        @user.save
      end
       
     flash[:notice] = "User updated"
     redirect_to edit_user_path(@user)
   else
     render :action => 'edit'
   end
 end
 
 def destroy
   @user = User.find(params[:id])
   if @user.update_attribute(:enabled, false)
     flash[:notice] = "User disabled"
   else
     flash[:error] = "There was a problem disabling this user."
   end
   redirect_to :action => 'index'
 end

 def enable
   @user = User.find(params[:id])
   if @user.update_attribute(:enabled, true)
     flash[:notice] = "User enabled"
   else
     flash[:error] = "There was a problem enabling this user."
   end
     redirect_to :action => 'index'
 end

end