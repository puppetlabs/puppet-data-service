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
  set 'database', { 'type' => 'unconfigured' }
  config_file '/etc/puppetlabs/pds/pds.yaml', File.join(__dir__, 'pds.yaml')

  # Based on the user-supplied hash 'database', set data adapter to an appropriate
  # DataAdapter object
  set(:data_adapter, PDS::DataAdapter.new(settings.database))

  self.configure do |config|
    config.api_version = '1.0.0'
  end

  helpers do
    # Syntactic sugar. We're using the settings object to store this globally,
    # but it's not really a setting. So, make it cleaner elsewhere in code.
    def data_adapter
      settings.data_adapter
    end
  end
end

# include the api files
Dir["./api/*.rb"].each { |file|
  require file
}
