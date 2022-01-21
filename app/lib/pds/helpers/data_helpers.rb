require 'securerandom'

module PDS
  module Helpers
    module DataHelpers
      # Set updated-at key of each submitted resource to Time.now. Add a
      # created-at key if it isn't already present.
      #
      # @param resources [Array] an array of resources as submitted by a user
      def timestamp!(resources)
        now = Time.now.iso8601
        resources.each do |rsrc|
          rsrc['updated-at'] = now
          rsrc['created-at'] ||= now
        end
      end

      # Ensure each submitted resource has created-at and updated-at keys. If
      # the resource already exists in the backend, set the created-at key to
      # the existing value for the resource. Set the updated-at key to the
      # current time.
      #
      # @param entity_type [Symbol] the type of resources.
      # @param resources [Array] an array of resources as submitted by a user
      def update_timestamps!(entity_type, resources)
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
          current = data_adapter.read(entity_type, filters: filters).first

          rsrc['created-at'] = current['created-at'] unless current.nil?
          timestamp!([rsrc])
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
