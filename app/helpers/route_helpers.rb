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
    token = request.env['HTTP_AUTHORIZATION']
    halt 403 if token.nil?
    users = data_adapter.read(:users, filters: [['=', 'temp_token', token]])
    halt 403 if users.size != 1

    users.first
  end
end
