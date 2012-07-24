class NewsItemsController < ApplicationController
  
  before_filter :login_required, :except=>[:index,:show]
  before_filter :check_administrator_role, :except=>[:index,:show]
  
  def index
    @news_items = NewsItem.find(:all, :order=>"created_at desc")
  end
  
  def new
    @news_item = NewsItem.new
  end
  
  def edit
    @news_item = NewsItem.find(params[:id])
  end
  
  def create
    @news_item = NewsItem.new(params[:news_item])
    
    respond_to do |format|
      if @news_item.save
        flash[:notice] = "News item created."
        format.html { redirect_to news_items_path }
      else
        format.html { render :action=>:new }
      end
    end
  end
  
  def update
    @news_item = NewsItem.find(params[:id])
    
    respond_to do |format|
      if @news_item.update_attributes(params[:news_item])
        flash[:notice] = "News item updated."
        format.html { redirect_to news_items_path }
      else
        format.html { render :action=>:edit }
      end
    end
  end
  
  def destroy
    @news_item = NewsItem.find(params[:id])
    
    if @news_item.destroy
      flash[:notice] = "News Item deleted."
    else
      flash[:error] = "News item was not deleted."
    end
    
    redirect_to news_items_path
  end

end
