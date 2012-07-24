# This is the front/main controller for the Wiki application
# Author: Anil Hemrajani
# Date: Feb, 2007
class PagesController < ApplicationController
  
  layout "wiki" , :except => [ :print ]

  before_filter :login_required, :only=>[:create,:edit,:save,:delete]
  permit "administrator or editor", :only=>[:create,:edit,:save,:delete]
  
  def index
    @pagelist = Page.find(:all,:order=>"name asc")
  end

  def show
    get_content
    if @page.closed? and !(current_user.is_editor? or current_user.is_administrator?)
        flash[:notice] = "That page does not exist."
        redirect_to pages_path and return false
     end
  end
  
  def print
    get_content
  end

  def help
    @pagename = get_pagename params[:f] # need this for other actions
  end
  
  def edit
    get_content
  end
  
  # create new wiki file
  def create
    @pagename = get_pagename params[:f]
    @page = Page.find_by_name(@pagename)
    if @page
       flash[:error] = "File '#{@pagename}' already exists; use Open instead of Create."
       redirect_to :action => :index
    else
      @page = Page.create({:name=>@pagename,:creator_id=>current_user.id})
      redirect_to page_path(@pagename)
    end
  end
  
  # save existing wiki file
  def update
    @pagename = get_pagename params[:f]
    content = params[:c]
    p @pagename
    p content
    @page = Page.find_by_name(@pagename)
    @page.closed = params[:page][:closed]
    @page.content = content
    @page.editor_id = current_user
    @page.save
    redirect_to page_path(@page)
  end
  
  # delete existing wiki file
  def delete
    if params[:f].nil? || params[:f].empty?
       flash[:error] = "File parameter not specified."
       redirect_to :action => :index
    else 
      @pagename = get_pagename params[:f]
      @page = Page.find_by_name(@pagename)
      @page.destroy
      redirect_to :action => :index
    end
  end
    
protected

  def editor_required
    unless current_user.is_admin? or current_user.has_role?("editor")
      flash[:error] = "You do not have permission to view that page."
      redirect_to root_path and return false
    end
  end
  
  private
  def get_pagename(f)
    f = "untitled" if (f.nil? || f.empty?)
    f.gsub(/[^a-zA-Z0-9]+/,"-")
  end

  # load file into @content using param :f; for errors go to index page  
  def get_content
    begin
      @pagename = get_pagename params[:id]
      @page = Page.find(:first,:conditions=>"name='#{@pagename}'")
      @content = @page.content
    rescue
      flash[:error] = "The page you were looking for does not exist."
      redirect_to pages_path
    end
  end
end
