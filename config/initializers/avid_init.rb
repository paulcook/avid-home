APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/avid-shared/shared_paths.yml")[RAILS_ENV]

require "avid_string"
require 'liquid'

AUTHORIZATION_MIXIN = "object roles"
LOGIN_REQUIRED_REDIRECTION = "#{APP_CONFIG['site_url']}/sessions/new"
PERMISSION_DENIED_REDIRECTION = "#{APP_CONFIG['site_url']}/sessions/new"

# The method your auth scheme uses to store the location to redirect back to
STORE_LOCATION_METHOD = :store_location
