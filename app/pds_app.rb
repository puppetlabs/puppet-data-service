require './lib/openapiing'
require 'sinatra/config_file'

# only need to extend if you want special configuration!
class PDSApp < OpenAPIing
  register Sinatra::ConfigFile

  # Set some defaults, then load a config file.
  disable('backend')
  config_file('/etc/puppetlabs/pds/pds.yaml', File.join(__dir__, 'pds.yaml'))

  self.configure do |config|
    config.api_version = '1.0.0'
  end
end

# include the api files
Dir["./api/*.rb"].each { |file|
  require file
}
