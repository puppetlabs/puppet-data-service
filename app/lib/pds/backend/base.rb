module PDS
  module Backend

    # This is an abstract base class documenting the required methods that
    # PDS::Backend::Implementation classes must provide.
    class Base

      # @return Symbol an identifier indicating the type of backend
      def type
        raise "Not implemented!"
      end
    end
  end
end
