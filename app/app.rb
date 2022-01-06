# Enable easy use of `require` for content in lib/
libdir = File.expand_path(File.join(__dir__, 'lib'))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'sinatra/base'
require 'sinatra/cross_origin'
require 'sinatra/custom_logger'
require "sinatra/reloader"
require 'committee'
require 'pds/data_adapter'
require 'logger'
require 'yaml'

Logger.class_eval { alias :write :'<<' }

# only need to extend if you want special configuration!
class App < Sinatra::Base
  register Sinatra::CrossOrigin
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

  # Load config parameters from a file, if it exists
  configpath = searchpath.find { |f| File.exist?(f) }
  set :config, configpath.nil? ? {} : YAML.load_file(configpath)

  # Configure logging and OpenAPI spec enforcement
  configure do |config|
    committee_opts = {
      prefix: '/v1',
      schema_path: 'openapi.yaml',
      query_hash_key: 'committee.query_hash',
      parse_response_by_content_type: true,
      error_handler: -> (ex, env) { logger.error ex.as_json },
    }

    use Rack::CommonLogger, logger
    use Committee::Middleware::RequestValidation, committee_opts
    use Committee::Middleware::ResponseValidation, committee_opts
  end

  before do
    authenticate!
  end

  after do
    logger.debug { "Response: #{response.body.first}" }
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
