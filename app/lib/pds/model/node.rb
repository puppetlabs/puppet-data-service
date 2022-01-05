require 'pds/model'

module PDS
  module Model
    module Node
      include PDS::Model

      def property_defaults
        {'classes' => [], 'code-environment' => nil, 'data' => {}}
      end
    end
  end
end
