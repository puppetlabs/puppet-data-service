require_relative 'backend/postgresql'

module PDS
  module Backend
    def self.new(config)
      raise "Invalid configuration!" unless config.is_a?(Hash)
      # Determine the appropriate implementation class
      implementation = case config['type']
                       when 'postgresql'
                         PDS::Backend::PostgreSQL
                       else
                         raise "Unsupported backend type '#{config['type']}'!"
                       end

      # Create and return a new instance of the implementation class
      implementation.new(config)
    end
  end
end
