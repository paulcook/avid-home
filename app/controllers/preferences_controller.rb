class PreferencesController < ApplicationController
  
  before_filter :login_required
  before_filter :initialize_user
  before_filter :admin_or_user_required
  
  def show
    
  end
  
  def edit
    
  end
  
  def update
    preferences = @user.preferences
    Preferences::OPTIONS.each_key do |key|
      if params[key]
        preferences[key.to_sym] = params[key.to_sym].to_i
      else
        preferences[key.to_sym] = 0
      end
    end
    @user.preferences_will_change!
    @user.preferences = preferences
    
    if @user.save!
      flash[:notice] = "Preferences updated"
      redirect_to edit_preferences_path(@user)
    else
      render :action=>:edit
    end
  end
  
protected
  def initialize_user
    @user = User.find_by_login(params[:user_id])
  end
  
  def admin_or_user_required
    unless current_user.is_admin? or current_user.id == @user.id
      redirect_to restricted_path and return false
    end
  end
  
end
