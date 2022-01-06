require 'pds/helpers/timestamp_helpers'

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
    halt render_error(401, 'Access (Bearer) token is missing or invalid') if token.nil?
    # Munge out auth-method prefix "Bearer " (case-insensitive) if present
    munged_token = token.sub(/^bearer /i, '')
    users = data_adapter.read(:users, filters: [['=', 'temp_token', munged_token]])
    halt render_error(401, 'Access (Bearer) token is missing or invalid') if users.size != 1

    users.first
  end

  def render_error(code, message, details = nil)
    status code
    full_error_message = {
      error: message
    }

    details_hash = {
      details: details
    }

    full_error_message = full_error_message.merge(details_hash) unless details.nil?
    full_error_message.to_json
  end

  # Take an array of resources, and the model constant indicating the type of
  # resource, and return an array of those resources with any missing
  # properties supplied by the model's property defaults.
  def with_defaults(resources, model_const)
    model = Object.new.extend(model_const)
    case resources
    when Array
      resources.map { |rsrc| model.property_defaults.merge(rsrc) }
    when Hash
      model.property_defaults.merge(resources)
    else
      raise "Expected Array or Hash; got #{resources.class}"
    end
  end
end
