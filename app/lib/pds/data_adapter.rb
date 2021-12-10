module PDS
  module DataAdapter

    # Used for raising exceptions
    class Conflict < StandardError; end

    def self.new(app)
      database_config = app.settings.config.dig('database')
      implementation = app.settings.config.dig('database', 'adapter')

      # Create and return a new instance of the implementation class
      case implementation
      when 'postgresql'
        load_postgresql_adapter(app)
        PDS::DataAdapter::PostgreSQL.new(app)
      when 'mock'
        load_mock_adapter(app)
        PDS::DataAdapter::Mock.new(app)
      else
        raise "Unsupported data adapter '#{implementation}'!"
      end
    end

    private

    def self.load_mock_adapter(app)
      require_relative 'data_adapter/mock'
    end

    def self.load_postgresql_adapter(app)
      require 'sinatra/activerecord'
      require_relative 'data_adapter/postgresql'

      # Configure ActiveRecord rake tasks to use adapter-specific db paths
      if defined?(ActiveRecord::Tasks::DatabaseTasks)
        ActiveRecord::Tasks::DatabaseTasks.db_dir = 'db/postgresql'
        ActiveRecord::Migrator.migrations_paths = ['db/postgresql/migrate']
      end

      app.register Sinatra::ActiveRecordExtension

      # Now that the ActiveRecordExtension has been registered, calling set on
      # :database will have the effect of loading the config, and connecting to
      # the database.
      app.set :database, app.settings.config['database']
    end
  end
end
