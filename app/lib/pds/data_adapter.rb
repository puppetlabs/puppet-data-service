
module PDS
  module DataAdapter
    def self.new(config)
      raise "Invalid configuration!" unless config.is_a?(Hash)
      # Determine and configure the appropriate implementation class
      implementation = case config['adapter']
                       when 'postgresql'
                         load_postgresql_adapter
                         PDS::DataAdapter::PostgreSQL
                       when 'mock'
                         load_mock_adapter
                         PDS::DataAdapter::Mock
                       else
                         raise "Unsupported data adapter '#{config['adapter']}'!"
                       end

      # Create and return a new instance of the implementation class
      implementation.new(config)
    end

    # Used for raising exceptions
    class Conflict < StandardError; end

    private

    def self.load_mock_adapter
      require_relative 'data_adapter/mock'
    end

    def self.load_postgresql_adapter
      require_relative 'data_adapter/postgresql'
      ActiveRecord::Migrator.migrations_paths = ['db/postgresql/migrate']
      PDSApp.register Sinatra::ActiveRecordExtension
    end
  end
end
