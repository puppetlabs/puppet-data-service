require 'json'
require 'pds/model/node'

App.post('/v1/nodes') do
  cross_origin

  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  body = JSON.parse(body_params)
  new_nodes = with_defaults(body['resources'], PDS::Model::Node)

  begin
    set_new_timestamps!(new_nodes)
    nodes_created = data_adapter.create(:nodes, resources: new_nodes)

    status 201
    nodes_created.to_json
  rescue PDS::DataAdapter::Conflict => e
    render_error(400, 'Bad Request. Unable to create requested nodes, check for duplicate nodes', e.message)
  end
end


App.delete('/v1/nodes/{name}') do
  cross_origin
  # the guts live here

  # TODO: validate input
  deleted = data_adapter.delete(:nodes, filters: [['=', 'name', params['name']]])
  if deleted.zero?
    render_error(404, 'Node not found')
  else
    status 204
  end
end


App.get('/v1/nodes') do
  cross_origin
  # the guts live here

  nodes = data_adapter.read(:nodes)
  nodes.to_json
end


App.get('/v1/nodes/{name}') do
  cross_origin

  # TODO: validate input
  nodes = data_adapter.read(:nodes, filters: [['=', 'name', params['name']]])
  if nodes.empty?
    render_error(404, 'Node not found')
  else
    nodes.first.to_json
  end
end


App.put('/v1/nodes/{name}') do
  cross_origin

  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  body = JSON.parse(body_params)

  node = with_defaults(body, PDS::Model::Node)
  node['name'] = params['name']

  update_or_set_new_timestamps!(:nodes, [node])
  data_adapter.upsert(:nodes, resources: [node])

  if node['created-at'] == node['updated-at']
    status 201
  else
    status 200
  end

  node.to_json
end
