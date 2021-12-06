require './lib/openapiing'
require './lib/pds/data_adapter'
require 'sinatra/config_file'

# only need to extend if you want special configuration!
class PDSApp < OpenAPIing
  register Sinatra::ConfigFile

  # Set required defaults, then load full config from file.
  # File values, if given, will replace defaults.
  set('database', { 'type' => 'unconfigured' })
  config_file('/etc/puppetlabs/pds/pds.yaml', File.join(__dir__, 'pds.yaml'))

  # Based on the user-supplied hash 'database', set data adapter to an appropriate
  # DataAdapter object
  set(:data_adapter, PDS::DataAdapter.new(settings.database))

  self.configure do |config|
    config.api_version = '1.0.0'
  end
end

# include the api files
Dir["./api/*.rb"].each { |file|
  require file
}
