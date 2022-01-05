require 'json'


App.post('/v1/hiera-data') do
  cross_origin

  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  body = JSON.parse(body_params)
  hiera_data = body['resources']

  begin
    set_new_timestamps!(hiera_data)
    data_adapter.create(:hiera_data, resources: hiera_data)
    status 201
    hiera_data.to_json
  rescue PDS::DataAdapter::Conflict => e
    render_error(400, 'Bad Request. Unable to create requested hiera-data, check for duplicate hiera-data', e.message)
  end
end


App.delete('/v1/hiera-data/{level}/{key}') do
  cross_origin
  # the guts live here

  # TODO: validate input
  deleted = data_adapter.delete(:hiera_data, filters: [['=', 'level', params['level']], ['=', 'key', params['key']]])
  if deleted.zero?
    render_error(404, 'Hiera data not found for the given level and key')
  else
    status 204
  end
end


App.get('/v1/hiera-data') do
  cross_origin
  # the guts live here

  # TODO: validate input
  filters = []
  filters << ['=', 'level', params['level']] unless params['level'].nil?
  hiera_data = data_adapter.read(:hiera_data, filters: filters)
  hiera_data.to_json
end


App.get('/v1/hiera-data/{level}/{key}') do
  cross_origin
  # the guts live here

  # TODO: validate input
  hiera_data = data_adapter.read(:hiera_data, filters: [['=', 'level', params['level']], ['=', 'key', params['key']]])
  if hiera_data.empty?
    render_error(404, 'Hiera data not found for the given level and key')
  else
    hiera_data.first.to_json
  end
end


App.put('/v1/hiera-data/{level}/{key}') do
  cross_origin
  # the guts live here

  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  hiera_data = JSON.parse(body_params)
  hiera_data['level'] = params['level']
  hiera_data['key'] = params['key']
  update_or_set_new_timestamps!(:hiera_data, [hiera_data])
  data_adapter.upsert(:hiera_data, resources: [hiera_data])

  if hiera_data['created-at'] == hiera_data['updated-at']
    status 201
  else
    status 200
  end

  hiera_data.to_json
end

