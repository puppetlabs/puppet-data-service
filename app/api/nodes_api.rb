require 'json'

App.add_route('POST', '/v1/nodes', {
  "resourcePath" => "/Nodes",
  "summary" => "Create new node(s)",
  "nickname" => "create_node",
  "responseClass" => "Array<Node>",
  "endpoint" => "/nodes",
  "notes" => "The body params are required to be a JSON object with an array of node's data. This endpoint supports bulk operations, you can create one or 1000 nodedata in a single POST request.",
  "parameters" => [
    {
      "name" => "body",
      "description" => "Create node object(s)",
      "dataType" => "Array<ImmutableNodeProperties>",
      "paramType" => "body",
    }
    ]}) do
  cross_origin

  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  nodes = JSON.parse(body_params)

  begin
    set_new_timestamps!(nodes)
    nodes_created = data_adapter.create(:nodes, resources: nodes)

    status 201
    nodes_created.to_json
  rescue PDS::DataAdapter::Conflict => e
    render_error(400, 'Bad Request. Unable to create requested nodes, check for duplicate nodes', e.message)
  end
end


App.add_route('DELETE', '/v1/nodes/{name}', {
  "resourcePath" => "/Nodes",
  "summary" => "Deletes a node",
  "nickname" => "delete_node",
  "responseClass" => "void",
  "endpoint" => "/nodes/{name}",
  "notes" => "This can only be done by the logged in user.",
  "parameters" => [
    {
      "name" => "name",
      "description" => "The node name to be fetched or modified. Use node1 for testing.",
      "dataType" => "String",
      "paramType" => "path",
    },
    ]}) do
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


App.add_route('GET', '/v1/nodes', {
  "resourcePath" => "/Nodes",
  "summary" => "Get all available nodes",
  "nickname" => "get_all_nodes",
  "responseClass" => "Array<Node>",
  "endpoint" => "/nodes",
  "notes" => "This can only be done by the logged in user.",
  "parameters" => [
    ]}) do
  cross_origin
  # the guts live here

  nodes = data_adapter.read(:nodes)
  nodes.to_json
end


App.add_route('GET', '/v1/nodes/{name}', {
  "resourcePath" => "/Nodes",
  "summary" => "Get node by node name",
  "nickname" => "get_node_by_name",
  "responseClass" => "Node",
  "endpoint" => "/nodes/{name}",
  "notes" => "Retrieve a specific node.",
  "parameters" => [
    {
      "name" => "name",
      "description" => "The node name to be fetched or modified. Use node1 for testing.",
      "dataType" => "String",
      "paramType" => "path",
    },
    ]}) do
  cross_origin

  # TODO: validate input
  nodes = data_adapter.read(:nodes, filters: [['=', 'name', params['name']]])
  if nodes.empty?
    render_error(404, 'Node not found')
  else
    nodes.first.to_json
  end
end


App.add_route('PUT', '/v1/nodes/{name}', {
  "resourcePath" => "/Nodes",
  "summary" => "Create a new node or replace an existing node",
  "nickname" => "put_node_by_name",
  "responseClass" => "Node",
  "endpoint" => "/nodes/{name}",
  "notes" => "If the node name does not exist, it will create it for you. This endpoint does not support bulk operations",
  "parameters" => [
    {
      "name" => "name",
      "description" => "The node name to be fetched or modified. Use node1 for testing.",
      "dataType" => "String",
      "paramType" => "path",
    },
    {
      "name" => "body",
      "description" => "Create or edit node object",
      "dataType" => "UNKNOWN_BASE_TYPE",
      "paramType" => "body",
    }
    ]}) do
  cross_origin

  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  node = JSON.parse(body_params)
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