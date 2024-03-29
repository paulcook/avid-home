# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

if RUBY_VERSION >= "1.9.3"
  module Gem
    def self.source_index
      sources
    end

    def self.cache
      sources
    end

    SourceIndex = Specification

    class SourceList
      # If you want vendor gems, this is where to start writing code.
      def search( *args ); []; end
      def each( &block ); end
      include Enumerable
    end
  end
end


Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
 
  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  
  # Add additional load paths for your own custom dirs
  config.plugin_paths = ["#{RAILS_ROOT}/vendor/plugins","#{RAILS_ROOT}/avid-shared/plugins"]
  config.load_paths += %W( #{RAILS_ROOT}/avid-shared/lib #{RAILS_ROOT}/avid-shared/models )
  
  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_avidmanager_session',
    :secret      => '34c2c18e98857dc369a9c0b31de5d371e2d173180570e405314388f2bd3d48ede37bc2ed98cdd80118e548fd6920e90de539ebb89d21f2ad9508ce4cec45632e'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  #config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  config.active_record.schema_format = :sql

  # Activate observers that should always be running
  config.active_record.observers = :user_observer
end
ActiveRecord::Base.verification_timeout = 60
