module PDS
  module DataAdapter
    # This is an abstract base class documenting the required methods that
    # PDS::DataAdapter::Implementation classes must provide.
    class Base
      # Valid entity types:
      #   - :users
      #   - :nodes
      #   - :hiera_data

      # @parama config [Hash] configuration needed to initialize the DataAdapter
      def initialize(config)
        raise NotImplementedError
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @param resources [Array] an array of resources to create
      def create(entity_type, resources:)
        raise NotImplementedError
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @param filter [Array] an array of filters to apply
      # @return [Array] an array of resources
      def read(entity_type, filter: nil)
        raise NotImplementedError
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @param resources [Array] an array of resources to upsert
      def upsert(entity_type, resources:)
        raise NotImplementedError
      end

      # @param entity_type [Symbol] the entity type to operate on
      # @return [Integer] the number of resources deleted
      def delete(entity_type, filter: nil)
        raise NotImplementedError
      end

      # @return [Symbol] an identifier indicating the type of DataAdapter
      def type
        raise NotImplementedError
      end
    end
  end
end
