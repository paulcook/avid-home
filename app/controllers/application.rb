# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #include HoptoadNotifier::Catcher
  include AuthenticatedSystem
  include AvidFunctions
  
  rescue_from ActionController::UnknownController, :with=>:render_404
  rescue_from ActionController::UnknownAction, :with=>:render_404
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery #:secret => '01c91d0ee8d81ecaeff07cdc24d401f3'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
protected  
  def rescue_action_in_public(exception)
    case exception
    when ActionController::RoutingError
      parts = request.request_uri.split("/")
      
      if parts[1] and parts[1] == "dynasties" and parts[3] == "seasons"
        begin
          @dynasty = Dynasty.find_by_param(parts[2])
        rescue ActiveRecord::RecordNotFound
          
        end
        if @dynasty.nil?
          @dynasty = Dynasty.find(parts[2])
        end
        if @dynasty
          begin
            @season = @dynasty.seasons.find(parts[4])
          rescue ActiveRecord::RecordNotFound
            
          end
          if @season
            flash[:notice] = "Avid URL's have changed. Please update any Dynasty URLs you use in links or bookmarks."
            redirect_to "http://#{APP_CONFIG['ncaa_url']}/#{@dynasty.to_param}/seasons/#{@season.to_param}" and return false
          else
            flash[:notice] = "Avid URL's have changed. Please update any Dynasty URLs you use in links or bookmarks."
            redirect_to "http://#{APP_CONFIG['ncaa_url']}/dynasties/#{@dynasty.to_param}" and return false
          end
        else
          render_500(exception)
          return false
        end
        
      elsif parts[1] and parts[1] == "dynasties"
        begin
          @dynasty = Dynasty.find_by_param(parts[2])
        rescue ActiveRecord::RecordNotFound
          
        end
        if @dynasty.nil?
          @dynasty = Dynasty.find(parts[2])
        end
        if @dynasty
          flash[:notice] = "Avid URL's have changed. Please update any Dynasty URLs you use in links or bookmarks."
          redirect_to "http://#{APP_CONFIG['ncaa_url']}/dynasties/#{@dynasty.to_param}" and return false
        else
          render_500(exception)
          return false
        end
      elsif parts[1]
        begin
          @dynasty = Dynasty.find_by_param(parts[1])
        rescue ActiveRecord::RecordNotFound
          
        end
        unless @dynasty.nil?
          flash[:notice] = "Avid URL's have changed. Please update any Dynasty URLs you use in links or bookmarks."
          redirect_to "http://#{APP_CONFIG['ncaa_url']}/dynasties/#{@dynasty.to_param}" and return false
        else
          teams = Team.find(:all,:conditions=>"name ~* '#{parts[1].underscore.humanize}'")
          if teams.nil? or teams.empty?
            render_500(exception)
            return false
          end
          flash[:notice] = "Avid 4.0 URL's have changed. Please update any Dynasty URLs you use in links or bookmarks. In the meantime please find your dynasties new home by using the below list of dynasties."
          redirect_to "http://#{APP_CONFIG['ncaa_url']}/search/teams/#{CGI::escape(parts[1].underscore.humanize)}" and return false
        end
      end
    else
      render_500(exception)
    end
  end
  
  def render_404(exception)
    render :layout=>"application",:template=>"errors/404", :status=>404, :locals=>{:error_message=>exception.message}
  end
  
  def render_500(exception)
    unless local_request?
      notify_hoptoad(exception)
      render :layout=>"application",:template=>"errors/500", :status=>500, :locals=>{:error_message=>exception.message}
      return false
    else
      rescue_action_locally(exception)
    end
  end

end
