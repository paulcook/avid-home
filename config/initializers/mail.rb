ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :tls=>true,
   :address => "smtp.gmail.com",
   :port => 587,
   :domain => "avidmanager.com",
   :authentication => :plain,
   :user_name => "support@avidmanager.com",
   :password => "nc44tr4ck3r"  
}