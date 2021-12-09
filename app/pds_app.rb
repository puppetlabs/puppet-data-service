require './lib/openapiing'
require './lib/pds/data_adapter'
require 'sinatra/config_file'
require 'sinatra/custom_logger'
require 'logger'
require "sinatra" # TODO: Should we require everything?
require 'sinatra/activerecord'

# only need to extend if you want special configuration!
class PDSApp < OpenAPIing
  register Sinatra::ConfigFile

  # Set required defaults, then load full config from file.
  # File values, if given, will replace defaults.
  set :logger, Logger.new(STDOUT)

  set :default_content_type, :json
  set 'database', { 'type' => 'postgresql' }
  config_file '/etc/puppetlabs/pds/pds.yaml', File.join(__dir__, 'pds.yaml')

  # Based on the user-supplied hash 'database', set data adapter to an appropriate
  # DataAdapter object
  set(:data_adapter, PDS::DataAdapter.new(settings.database))

  self.configure do |config|
    config.api_version = '1.0.0'
  end
end

# include the helpers
Dir["./helpers/*.rb", "./models/*.rb"].each { |file|
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
