require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/custom_logger'
require 'logger'
require './lib/openapiing'
require './lib/pds/data_adapter'

# only need to extend if you want special configuration!
class PDSApp < OpenAPIing
  register Sinatra::ConfigFile

  # Set required defaults, then load full config from file.
  # File values, if given, will replace defaults.
  set :logger, Logger.new(STDOUT)
  set :default_content_type, :json
  set :database, { 'adapter' => 'unconfigured' }

  # Users should configure their app settings using a pds.yaml file in one of
  # these locations
  config_file '/etc/puppetlabs/pds/pds.yaml', File.expand_path(File.join(__dir__, 'config', 'pds.yaml'))

  self.configure do |config|
    config.api_version = '1.0.0'
  end
end

# Based on the user-supplied hash 'database', set :data_adapter to an
# appropriate DataAdapter object. This is performed here so that it is
# universally invoked when this file is required.
PDSApp.set :data_adapter, PDS::DataAdapter.new(PDSApp.settings.database)

# include the helpers
Dir["./helpers/*.rb"].each { |file|
  require file
}

# include the models
Dir["./models/*.rb"].each { |file|
  require file
}

# include the api files
Dir["./api/*.rb"].each { |file|
  require file
}
