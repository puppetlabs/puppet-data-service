require_relative '../data_adapter'
require_relative 'base'

module PDS
  module DataAdapter
    class PostgreSQL < PDS::DataAdapter::Base
      def initialize(config)
        @config = config
      end

      def type
        :postgresql
      end
    end
  end
end
