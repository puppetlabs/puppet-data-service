require_relative '../data_adapter'
require_relative 'base'
require "active_record"

module PDS
  module DataAdapter
    class PostgreSQL < PDS::DataAdapter::Base
      def create(entity_type, resources:)
        # TODO: implement uniqueness check(s)
        # TODO: validate input
        # TODO
      end

      def read(entity_type, filters: [])
        logger.debug "Reading #{entity_type} with filter #{filters}"

        if filters.any?
          filters.each do |filter|
            field_name = filter[1]
            expected_field_value =  filter[2]
            logger.debug "field_name: #{field_name}, expected_field_value: #{expected_field_value}"

            found = User.find_by(field_name => expected_field_value)
            return [found].compact
          end
        else
          return User.all
        end
      end

      def upsert(entity_type, resources:)
        # TODO: implement uniqueness check(s)
        # TODO: validate input
        # TODO
      end

      def delete(entity_type, filters: [])
        # TODO: implement filter
        if filters.empty?
          return "Invalid #{entity_type} ID"
        else
          entity_klass = entity_type.camelize.constantize
          entity_klass.destroy(filters[0])
        end
      end

      def type
        :postgresql
      end

      private

      # Models

      class Changelog < ActiveRecord::Base; end

      class HieraData < ActiveRecord::Base
        validates_presence_of :level
        validates_presence_of :key
      end

      class Node < ActiveRecord::Base
        validates_presence_of :name
      end

      class User < ActiveRecord::Base
        validates_presence_of :username
      end
    end
  end
end
