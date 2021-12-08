require_relative '../pds_app.rb'

PDSApp.helpers do
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

      current = data_adapter.read(entity_type, filters: filters)

      rsrc['updated-at'] = timestamp
      if current.empty?
        rsrc['created-at'] = timestamp
      else
        rsrc['created-at'] = current.first['created-at']
      end
    end
  end
end
