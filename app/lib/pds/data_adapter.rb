require_relative 'data_adapter/postgresql'

module PDS
  module DataAdapter
    def self.new(config)
      raise "Invalid configuration!" unless config.is_a?(Hash)
      # Determine the appropriate implementation class
      implementation = case config['type']
                       when 'postgresql'
                         PDS::DataAdapter::PostgreSQL
                       else
                         raise "Unsupported data adapter type '#{config['type']}'!"
                       end

      # Create and return a new instance of the implementation class
      implementation.new(config)
    end
  end
end
