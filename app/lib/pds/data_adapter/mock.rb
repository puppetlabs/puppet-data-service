require_relative '../data_adapter'
require_relative 'base'
require 'date'

module PDS
  module DataAdapter
    class Mock < PDS::DataAdapter::Base
      def initialize(config)
        logger.info 'Loading mock DataAdapter'
        @data = sample_data
        true
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @param resources [Array] an array of resources to create
      def create(entity_type, resources:)
        # TODO: implement uniqueness check(s)
        # TODO: validate input
        @data[entity_type].push(*resources)
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @param filter [Array] an array of filters to apply
      # @return [Array] an array of resources
      def read(entity_type, filter: [])
        logger.debug "Reading #{entity_type} with filter #{filter}"

        dat = @data[entity_type]

        filter.reduce(dat) do |memo, fil|
          case fil[0]
          when '='
            memo.select { |entity| entity[fil[1]] == fil[2] }
          else
            raise "Invalid filter: #{fil}"
          end
        end
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @param resources [Array] an array of resources to upsert
      def upsert(entity_type, resources:)
        # TODO: implement uniqueness check(s)
        # TODO: validate input
        @data[entity_type].push(*resources)
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @return [Integer] the number of resources deleted
      def delete(entity_type, filter: [])
        # TODO: implement filter
        size = @data[entity_type].size
        @data[entity_type].clear
        size
      end

      # @return [Symbol] an identifier indicating the type of DataAdapter
      def type
        raise NotImplementedError
      end

      private

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
              'trusted-data'     => {},
              'created-at'       => DateTime.parse('2021-12-06T11:52:01-08:00'),
              'updated-at'       => DateTime.parse('2021-12-06T11:52:01-08:00'),
            },
            { 'name'             => 'node2.example.com',
              'code-environment' => 'production',
              'classes'          => ['policy::base'],
              'trusted-data'     => {},
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
