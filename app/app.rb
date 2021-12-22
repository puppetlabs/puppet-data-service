# Enable easy use of `require` for content in lib/
libdir = File.expand_path(File.join(__dir__, 'lib'))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'sinatra/base'
require 'sinatra/custom_logger'
require "sinatra/reloader"
require 'openapiing'
require 'pds/data_adapter'
require 'logger'
require 'yaml'

# only need to extend if you want special configuration!
class App < OpenAPIing
  helpers Sinatra::CustomLogger

  # Set required defaults, then load full config from file.
  # File values, if given, will replace defaults.
  set :logger, Logger.new(STDOUT)
  set :default_content_type, :json

  # Users should configure their app settings using a pds.yaml file in one of
  # these locations
  searchpath = [
    '/etc/puppetlabs/pds-server/pds.yaml',
    File.expand_path(File.join(__dir__, 'config', 'pds.yaml')),
  ]

  configpath = searchpath.find { |f| File.exist?(f) }
  set :config, configpath.nil? ? {} : YAML.load_file(configpath)

  self.configure do |config|
    config.api_version = '1.0.0'
  end

  # When debugging, return detailed response information
  after do
    logger.debug { "Response: #{response.body}" }
  end

  # Automatically reload modified files in development
  if App.environment == :development
    register Sinatra::Reloader
  end
end

# Based on the user-supplied hash 'database', set :data_adapter to an
# appropriate DataAdapter object. This is performed here so that it is
# universally invoked when this file is required.
App.set :data_adapter, PDS::DataAdapter.new(App)

# include the helpers
Dir["./helpers/*.rb"].each { |file| require file }

# include the api files
Dir["./api/*.rb"].each { |file| require file }
