module PDS
  module DataAdapter
    # This is an abstract base class documenting the required methods that
    # PDS::DataAdapter::Implementation classes must provide.
    class Base
      def initialize
        raise "Cannot initialize an abstract PDS::DataAdapter::Base class"
      end

      def create(entity , filter: nil)
        raise NotImplementedError
      end

      def read(entity , filter: nil)
        raise NotImplementedErrors
      end

      def upsert(entity , filter: nil)
        raise NotImplementedError
      end

      def delete(entity , filter: nil)
        raise NotImplementedError
      end

      # @return Symbol an identifier indicating the type of DataAdapter
      def type
        raise NotImplementedError
      end
    end
  end
end
