require_relative '../app.rb'
require_relative '../lib/pds/helpers/timestamp_helpers'

App.helpers do
  include PDS::Helpers::TimestampHelpers

  # Syntactic sugar. We're using the settings object to store this globally,
  # but it's not really a setting. So, make it cleaner elsewhere in code.
  def data_adapter
    settings.data_adapter
  end

  # Authorization filter
  # @return [Hash] user object for authorized user
  def authenticate!
    # Development aid: disable authentication
    if (settings.config['authenticate'] == false)
      logger.warn('Authentication disabled! Permitting request without authenticating')
      return true
    end

    token = request.env['HTTP_AUTHORIZATION']
    halt 403 if token.nil?
    # Munge out auth-method prefix "Bearer " (case-insensitive) if present
    munged_token = token.sub(/^bearer /i, '')
    users = data_adapter.read(:users, filters: [['=', 'temp_token', munged_token]])
    halt 403 if users.size != 1

    users.first
  end
end
