require 'pds/data_adapter'
require 'pds/data_adapter/base'
require 'date'

module PDS
  module DataAdapter
    class Mock < PDS::DataAdapter::Base
      def initialize(app)
        super
        logger.info 'Loading mock DataAdapter'
        @data = sample_data
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @param resources [Array] an array of resources to create
      def create(entity_type, resources:)
        # TODO: implement uniqueness check(s)
        conflict = resources.any? do |resource|
          @data[entity_type].any? do |existing|
            resource_eql?(entity_type, resource, existing)
          end
        end

        # TODO: return more meaningful information
        raise PDS::DataAdapter::Conflict if conflict

        # All's well, add the resources
        @data[entity_type].push(*resources)
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @param filter [Array] an array of filters to apply
      # @return [Array] an array of resources
      def read(entity_type, filters: [])
        logger.debug "Reading #{entity_type} with filters #{filters}"

        resources = @data[entity_type]

        # Apply each filter to the resource collection, selecting only those
        # resources that match all the filters
        filters.reduce(resources) do |memo, filter|
          memo.select { |resource| matches_filter?(resource, filter) }
        end
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @param resources [Array] an array of resources to upsert
      def upsert(entity_type, resources:)
        resources.each do |resource|
          existing_index = @data[entity_type].find_index { |e| resource_eql?(entity_type, resource, e) }
          if existing_index.nil?
            @data[entity_type].push(resource)
          else
            @data[entity_type][existing_index] = resource
          end
        end

        # TODO: define a return value
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @return [Integer] the number of resources deleted
      def delete(entity_type, filters: [])
        # If there are no filters, delete everything
        if filters.empty?
          deleted = @data[entity_type].size
          @data[entity_type].clear
          return deleted
        end

        # If there are filters, delete resources that match them
        filters.reduce(0) do |deleted, filter|
          @data[entity_type].delete_if do |resource|
            matches_filter?(resource, filter) && deleted += 1
          end
          deleted
        end
      end

      # @return [Symbol] an identifier indicating the type of DataAdapter
      def type
        :mock
      end

      private

      def matches_filter?(resource, filter)
        case filter[0]
        when '='
          resource[filter[1]] == filter[2]
        else
          raise "Invalid filter: #{filter}"
        end
      end

      def resource_eql?(entity_type, a, b)
        case entity_type
        when :users
          a['username'] == b['username']
        when :nodes
          a['name'] == b['name']
        when :hiera_data
          a['level'] == b['level'] && a['key'] == b['key']
        else
          raise "Invalid entity type: #{entity_type}"
        end
      end

      # @return [Hash] a set of sample data used to create new mock DataAdapters.
      def sample_data
        {
          :users => [
            { 'username'   => 'user1',
              'email'      => 'user1@example.com',
              'role'       => 'administrator',
              'status'     => 'active',
              'temp_token' => 'abc123',
              'created-at' => DateTime.parse('2021-12-06T11:52:01-08:00'),
              'updated-at' => DateTime.parse('2021-12-06T11:52:01-08:00'),
            },
            { 'username'   => 'user2',
              'email'      => 'user2@example.com',
              'role'       => 'operator',
              'status'     => 'active',
              'temp_token' => 'def456',
              'created-at' => DateTime.parse('2021-12-06T11:52:01-08:00'),
              'updated-at' => DateTime.parse('2021-12-06T11:52:01-08:00'),
            },
          ],
          :nodes => [
            { 'name'             => 'node1.example.com',
              'code-environment' => 'development',
              'classes'          => ['policy::base'],
              'data'     => {},
              'created-at'       => DateTime.parse('2021-12-06T11:52:01-08:00'),
              'updated-at'       => DateTime.parse('2021-12-06T11:52:01-08:00'),
            },
            { 'name'             => 'node2.example.com',
              'code-environment' => 'production',
              'classes'          => ['policy::base'],
              'data'     => {},
              'created-at'       => DateTime.parse('2021-12-06T11:52:01-08:00'),
              'updated-at'       => DateTime.parse('2021-12-06T11:52:01-08:00'),
            },
          ],
          :hiera_data => [
            { 'level'      => 'common',
              'key'        => 'pds::color',
              'value '     => 'orange',
              'created-at' => DateTime.parse('2021-12-06T11:52:01-08:00'),
              'updated-at' => DateTime.parse('2021-12-06T11:52:01-08:00'),
            },
            { 'level'      => 'common',
              'key'        => 'pds::distance',
              'value '     => '5k',
              'created-at' => DateTime.parse('2021-12-06T11:52:01-08:00'),
              'updated-at' => DateTime.parse('2021-12-06T11:52:01-08:00'),
            },
          ],
        }
      end
    end
  end
end
