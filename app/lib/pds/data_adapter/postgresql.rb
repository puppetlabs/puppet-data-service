require 'active_record'
require 'composite_primary_keys'
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
          model.insert_all(resources.map { |rsrc| model.to_attributes(rsrc) })
          resources
        rescue
          raise PDS::DataAdapter::Conflict
        end
      end

      def read(entity_type, filters: [])
        logger.debug "Reading #{entity_type} with filter #{filters}"
        model = entity_klass(entity_type)

        if filters.empty?
          model.all.map { |record| record.to_resource }
        else
          model.where(where(filters)).map { |record| record.to_resource }
        end
      end

      def upsert(entity_type, resources:)
        model = entity_klass(entity_type)
        # TODO: validate input
        model.upsert_all(resources.map { |rsrc| model.to_attributes(rsrc) })
        resources
      end

      def delete(entity_type, filters: [])
        logger.debug "Deleting #{entity_type} with filter #{filters}"
        model = entity_klass(entity_type)

        deleted = if filters.empty?
                    model.destroy_all
                  else
                    model.destroy_by(where(filters))
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

      def where(filters)
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

      # Abstract base model to define resource-to-record transformation methods
      class PDSRecord < ActiveRecord::Base
        self.abstract_class = true

        def self.to_attributes(resource)
          resource.transform_keys { |k| k.gsub('-', '_').to_sym }
        end

        def to_resource
          attributes.transform_keys { |k| k.to_s.gsub('_', '-') }
        end
      end

      class Changelog < PDSRecord; end

      class HieraDatum < PDSRecord
        self.primary_key = ['level', 'key']
        validates_presence_of :level
        validates_presence_of :key
      end

      class Node < PDSRecord
        self.primary_key = "name"
        validates_presence_of :name
      end

      class User < PDSRecord
        self.primary_key = "username"
        validates_presence_of :username
      end
    end
  end
end
