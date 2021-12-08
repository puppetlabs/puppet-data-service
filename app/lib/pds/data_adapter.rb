require_relative 'data_adapter/postgresql'
require_relative 'data_adapter/mock'

module PDS
  module DataAdapter
    def self.new(config)
      raise "Invalid configuration!" unless config.is_a?(Hash)
      # Determine the appropriate implementation class
      implementation = case config['type']
                       when 'postgresql'
                         PDS::DataAdapter::PostgreSQL
                       when 'mock'
                         PDS::DataAdapter::Mock
                       else
                         raise "Unsupported data adapter type '#{config['type']}'!"
                       end

      # Create and return a new instance of the implementation class
      implementation.new(config)
    end

    # Used for raising exceptions
    class Conflict < StandardError; end
  end
end
