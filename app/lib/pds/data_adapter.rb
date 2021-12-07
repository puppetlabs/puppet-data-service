require_relative 'data_adapter/postgresql'
require_relative 'data_adapter/mock'

module PDS
  module DataAdapter
    def self.new(config, logger: nil)
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
      implementation.new(config, logger: logger)
    end
  end
end
