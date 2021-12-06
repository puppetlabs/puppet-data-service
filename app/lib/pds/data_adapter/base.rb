module PDS
  module DataAdapter

    # This is an abstract base class documenting the required methods that
    # PDS::DataAdapter::Implementation classes must provide.
    class Base

      # @return Symbol an identifier indicating the type of DataAdapter
      def type
        raise "Not implemented!"
      end
    end
  end
end
