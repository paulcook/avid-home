ActionController::Routing::Routes.draw do |map|

  map.resources :tickets, :has_many=>:comments,:member=>{:tag=>:get}
  map.resources :roles

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  
  map.resources :custom_site_parts
  map.resources :custom_websites

  map.resources :news_items
  
  map.resources :support_requests
  map.resources :pages, :collection=>{:help=>:get},:member=>{:print=>:get}
  
  map.resources :users, :has_many=>:roles, :member => { :enable => :put },:collection=>{ :search=>:post }
  map.resource :preferences, :path_prefix=>"/:user_id"
  map.resources :accounts, :member=>{:activate=>:get}
  map.resources :roles, :path_prefix=>"/:user_id"
  map.resources :passwords
  
  map.resource :session
  map.resource :password
  
  map.restricted "/restricted", :controller=>"home",:action=>"restricted"
  
  # Non resource oriented routes
  map.accounts '/account', :controller=>"accounts",:action=>"index"
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:id', :controller => 'accounts', :action => 'activate'
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.reset_password '/reset_password/:id', :controller => 'passwords', :action => 'edit'

  # SHARED ROUTES For Layout
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.about "/about", :controller=>"home",:action=>"about"
  map.help "/help", :controller=>"home",:action=>"help"
  map.dev "/dev",:controller=>"tickets", :action=>"index"
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
