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
        model = entity_klass(entity_type)
        begin
          model.insert_all(resources)
          resources
        rescue
          raise PDS::DataAdapter::Conflict
        end
      end

      def read(entity_type, filters: [])
        logger.debug "Reading #{entity_type} with filter #{filters}"
        model = entity_klass(entity_type)

        if filters.empty?
          models2api(model.all)
        else
          models2api(model.where(filters2where(filters)))
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
        logger.debug "Deleting #{entity_type} with filter #{filters}"
        model = entity_klass(entity_type)

        deleted = if filters.empty?
                    model.destroy_all
                  else
                    model.destroy_by(filters2where(filters))
                  end

        deleted.size
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

      def filters2where(filters)
        # Reduce to [clauses, parameters]
        clauses = filters.reduce([[], []]) do |memo,filter|
          case filter[0]
          when '='
            memo[0] << "#{filter[1]} = ?"
            memo[1] << filter[2]
          else
            raise "Invalid filter: '#{filter}'"
          end

          memo
        end

        # Combine clauses by and-ing together, return ActiveRecord where argument.
        [clauses[0].join(' and '), *clauses[1]]
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
