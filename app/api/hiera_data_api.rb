require 'json'
require 'uri'
require 'pds/model/hiera_datum'

App.post('/v1/hiera-data') do
  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  body = JSON.parse(body_params)
  new_hiera_data = with_defaults(body['resources'], PDS::Model::HieraDatum)

  begin
    timestamp!(new_hiera_data)
    data_adapter.create(:hiera_data, resources: new_hiera_data)
    status 201
    new_hiera_data.to_json
  rescue PDS::DataAdapter::Conflict => e
    render_error(400, 'Bad Request. Unable to create requested hiera-data, check for duplicate hiera-data', e.message)
  end
end


App.delete('/v1/hiera-data/{level}/{key}') do
  # TODO: validate input
  level = URI.decode_www_form_component(params['level'])
  key = URI.decode_www_form_component(params['key'])

  deleted = data_adapter.delete(:hiera_data, filters: [['=', 'level', level], ['=', 'key', key]])
  if deleted.zero?
    render_error(404, 'Hiera data not found for the given level and key')
  else
    status 204
  end
end


App.get('/v1/hiera-data') do
  # TODO: validate input

  filters = []
  if params['level']
    level = URI.decode_www_form_component(params['level'])
    filters << ['=', 'level', level]
  end

  hiera_data = data_adapter.read(:hiera_data, filters: filters)
  hiera_data.to_json
end


App.get('/v1/hiera-data/{level}/{key}') do
  # TODO: validate input
  level = URI.decode_www_form_component(params['level'])
  key = URI.decode_www_form_component(params['key'])

  hiera_data = data_adapter.read(:hiera_data, filters: [['=', 'level', level], ['=', 'key', key]])
  if hiera_data.empty?
    render_error(404, 'Hiera data not found for the given level and key')
  else
    hiera_data.first.to_json
  end
end


App.put('/v1/hiera-data/{level}/{key}') do
  # TODO: validate input
  level = URI.decode_www_form_component(params['level'])
  key = URI.decode_www_form_component(params['key'])
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  body = JSON.parse(body_params)

  hiera_datum = with_defaults(body, PDS::Model::HieraDatum)
  hiera_datum['level'] = level
  hiera_datum['key'] = key

  update_timestamps!(:hiera_data, [hiera_datum])
  data_adapter.upsert(:hiera_data, resources: [hiera_datum])

  if hiera_datum['created-at'] == hiera_datum['updated-at']
    status 201
  else
    status 200
  end

  hiera_datum.to_json
end

