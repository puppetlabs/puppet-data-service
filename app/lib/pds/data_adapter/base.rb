module PDS
  module DataAdapter
    # This is an abstract base class documenting the required methods that
    # PDS::DataAdapter::Implementation classes must provide.
    class Base
      def initialize
        raise "Cannot initialize an abstract PDS::DataAdapter::Base class"
      end

      def create
        raise NotImplementedError
      end

      def read
        raise NotImplementedErrors
      end

      def upsert
        raise NotImplementedError
      end

      def delete
        raise NotImplementedError
      end

      # @return Symbol an identifier indicating the type of DataAdapter
      def type
        raise "Not implemented!"
      end
    end
  end
end
