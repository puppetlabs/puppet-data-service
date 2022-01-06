require 'pds/model'

module PDS
  module Model
    module User
      include PDS::Model

      def property_defaults
        {'status' => 'active', 'email' => nil}
      end
    end
  end
end
