class HomeController < ApplicationController
  
  caches_action :index
  
  def index
    
  end
  
  def about
    
  end
  
  def help
    @pages = Page.find(:all, :order=>"name asc")
    @support_request = SupportRequest.new
  end
  
protected
  def skip_main_page
    if logged_in?
      if flash[:notice]
        flash[:notice] = flash[:notice]
      end
      if flash[:error]
        flash[:error] = flash[:error]
      end
      redirect_to accounts_path
      return false
    end
  end
end
