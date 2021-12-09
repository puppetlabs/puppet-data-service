
module PDS
  module DataAdapter
    def self.new(app)
      database_config = app.settings.config.dig('database')
      implementation = app.settings.config.dig('database', 'adapter')

      # Create and return a new instance of the implementation class
      case implementation
      when 'postgresql'
        load_postgresql_adapter(app)
        PDS::DataAdapter::PostgreSQL.new(database_config)
      when 'mock'
        load_mock_adapter(app)
        PDS::DataAdapter::Mock.new(database_config)
      else
        raise "Unsupported data adapter '#{implementation}'!"
      end
    end

    # Used for raising exceptions
    class Conflict < StandardError; end

    private

    def self.load_mock_adapter(app)
      require_relative 'data_adapter/mock'
    end

    def self.load_postgresql_adapter(app)
      require_relative 'data_adapter/postgresql'

      # Set migrations_paths to a directory specific to the PostgreSQL adapter
      ActiveRecord::Migrator.migrations_paths = ['db/postgresql/migrate']

      app.register Sinatra::ActiveRecordExtension

      # Now that the ActiveRecordExtension has been registered, calling set on
      # :database will have the effect of loading the config, and connecting to
      # the database.
      app.set :database, app.settings.config['database']
    end
  end
end
