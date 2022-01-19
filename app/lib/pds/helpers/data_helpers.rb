module PDS
  module Helpers
    module DataHelpers
      # @param entity_type [Symbol] the type of resources. Not used; passed for
      #   consistency with #update_or_set_new_timestamps!
      # @param resources [Array] an array of resources as submitted by a user
      def set_new_timestamps!(resources)
        resources.each { |rsrc| rsrc['created-at'] = rsrc['updated-at'] = Time.now.iso8601 }
      end

      # @param entity_type [Symbol] the type of resources.
      # @param resources [Array] an array of resources as submitted by a user
      def update_or_set_new_timestamps!(entity_type, resources)
        timestamp = Time.now.iso8601
        resources.each do |rsrc|
          filters = case entity_type
                    when :users
                      [['=', 'username', rsrc['username']]]
                    when :nodes
                      [['=', 'name', rsrc['name']]]
                    when :hiera_data
                      [['=', 'level', rsrc['level']],
                       ['=', 'key', rsrc['key']]]
                    else
                      raise "Invalid entity type: #{entity_type}"
                    end

          # The #data_adapter method must be defined elsewhere for this mixin
          # to work properly
          current = data_adapter.read(entity_type, filters: filters)

          rsrc['updated-at'] = timestamp
          if current.empty?
            rsrc['created-at'] = timestamp
          else
            rsrc['created-at'] = current.first['created-at']
          end
        end
      end

      def set_user_tokens!(user_candidates)
        user_candidates.each do |candidate|
          new_token = SecureRandom.uuid.upcase
          candidate['temp-token'] = new_token if candidate['temp-token'].nil?
        end
      end
    end
  end
end
