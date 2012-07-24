class SupportRequestsController < ApplicationController
  
  def show
    @support_request = SupportRequest.find(params[:id])
  end
  
  def new
    @support_request = SupportRequest.new
  end
  
  def create
    @support_request = SupportRequest.new(params[:support_request])
    
    if @support_request.save
      SupportRequestNotifier.deliver_sent(@support_request)
      flash[:notice] = "Your support request has been submitted and the Avid staff has been notified.  Thank You."
      redirect_to help_path
    else
      render :action=>:new
    end
  end
end
