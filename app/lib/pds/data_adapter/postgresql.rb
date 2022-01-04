require 'active_record'
require 'composite_primary_keys'
require 'active_support/inflector'
require 'pds/data_adapter'
require 'pds/data_adapter/base'
require 'pds/model/node'
require 'pds/model/user'
require 'pds/model/hiera_datum'

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
          # The insert_all! method requires that all inserted elements have the
          # same keys. Ensure all resources have the same keys by mapping each
          # to its merge with a defaults hash, which will set any missing
          # keys to default values.
          with_defaults = resources.map { |rsrc| model.property_defaults.merge(rsrc) }
          model.insert_all!(with_defaults.map { |rsrc| model.to_attributes(rsrc) })
          with_defaults
        rescue ActiveRecord::RecordNotUnique
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
        with_defaults = resources.map { |rsrc| model.property_defaults.merge(rsrc) }
        model.upsert_all(with_defaults.map { |rsrc| model.to_attributes(rsrc) })
        with_defaults
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
        extend PDS::Model::HieraDatum

        self.primary_key = ['level', 'key']
        validates_presence_of :level
        validates_presence_of :key
      end

      class Node < PDSRecord
        extend PDS::Model::Node

        self.primary_key = "name"
        validates_presence_of :name

        def self.resource_defaults
          {'classes' => [], 'code-environment' => nil, 'data' => {}}
        end
      end

      class User < PDSRecord
        extend PDS::Model::User

        self.primary_key = "username"
        validates_presence_of :username, :email
        validates :username, :email, uniqueness: true
        validates :role, inclusion: { in: ['operator', 'administrator'], message: "%{value} is not a valid role" }
      end
    end
  end
end
