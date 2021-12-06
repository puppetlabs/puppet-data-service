require_relative '../backend'
require_relative 'base'

module PDS
  module Backend
    class PostgreSQL < 
      def initialize(config)
        @config = config
      end

      def type
        :postgresql
      end
    end
  end
end
