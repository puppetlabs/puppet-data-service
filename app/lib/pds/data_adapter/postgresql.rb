require 'active_record'
require 'active_support/inflector'
require_relative '../data_adapter'
require_relative 'base'

module PDS
  module DataAdapter
    class PostgreSQL < PDS::DataAdapter::Base

      include ActiveSupport::Inflector

      def create(entity_type, resources:)
        # TODO: implement uniqueness check(s)
        # TODO: validate input
        # TODO
      end

      def read(entity_type, filters: [])
        logger.debug "Reading #{entity_type} with filter #{filters}"
        model = entity_klass(entity_type)

        if filters.any?
          filters.each do |filter|
            field_name = filter[1]
            expected_field_value =  filter[2]
            logger.debug "field_name: #{field_name}, expected_field_value: #{expected_field_value}"

            found = model.find_by(field_name => expected_field_value)
            return models2api([found].compact)
          end
        else
          return models2api(model.all)
        end
      end

      def upsert(entity_type, resources:)
        model = entity_klass(entity_type)
        # TODO: implement uniqueness check(s)
        # TODO: validate input
        model.upsert_all(resources.map { |rsrc| api2table_keys(rsrc) })
        resources
      end

      def delete(entity_type, filters: [])
        # TODO: implement filter
        if filters.empty?
          return "Invalid #{entity_type} ID"
        else
          model = entity_klass(entity_type)
          model.destroy(filters[0])
        end
      end

      def type
        :postgresql
      end

      private

      def entity_klass(entity_type)
        entity_type.to_s
                   .singularize
                   .camelize
                   .prepend(self.class.to_s + '::')
                   .constantize
      end

      # @param array [Array]
      def models2api(array)
        array.map { |model| table2api_keys(model.attributes) }
      end

      def api2table_keys(hash)
        hash.transform_keys { |k| k.gsub('-', '_').to_sym }
      end

      def table2api_keys(hash)
        hash.transform_keys { |k| k.to_s.gsub('_', '-') }
      end

      # Models

      class Changelog < ActiveRecord::Base; end

      class HieraData < ActiveRecord::Base
        validates_presence_of :level
        validates_presence_of :key
      end

      class Node < ActiveRecord::Base
        self.primary_key = "name"
        validates_presence_of :name
      end

      class User < ActiveRecord::Base
        self.primary_key = "username"
        validates_presence_of :username
      end
    end
  end
end
