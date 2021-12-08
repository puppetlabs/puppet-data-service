require_relative '../data_adapter'
require_relative 'base'
require "sinatra/activerecord"

module PDS
  module DataAdapter
    class PostgreSQL < PDS::DataAdapter::Base
      def initialize(config)
        @config = config
      end

      def create(entity_type, resources: nil)
        # TODO: implement uniqueness check(s)
        # TODO: validate input
        # TODO
      end

      def read(entity_type, filter: [])
        PDSApp.logger.debug "Reading #{entity_type} with filter #{filter}"
        User.all
      end

      def upsert(entity_type, resources: nil)
        # TODO: implement uniqueness check(s)
        # TODO: validate input
        # TODO
      end

      def delete(entity_type, filter: [])
        # TODO: implement filter
        # TODO
      end

      def type
        :postgresql
      end
    end
  end
end
