require 'json'


App.add_route('POST', '/v1/hiera-data', {
  "resourcePath" => "/HieraData",
  "summary" => "Create new Hiera data value(s)",
  "nickname" => "create_hiera_data",
  "responseClass" => "Array<HieraValue>",
  "endpoint" => "/hiera-data",
  "notes" => "The body params are required to be a JSON object with an array of Hieradata. This endpoint supports bulk operations, you can create one or 1000 hieradata in a single POST request.",
  "parameters" => [
    {
      "name" => "body",
      "description" => "Create new Hiera data value(s)",
      "dataType" => "Array<ImmutableHieraValueProperties>",
      "paramType" => "body",
    }
    ]}) do
  cross_origin

  # TODO: validate input
  body_params = request.body.read
  return status 400 if body_params.empty?

  hiera_data = JSON.parse(body_params)

  begin
    set_new_timestamps!(hiera_data)
    data_adapter.create(:hiera_data, resources: hiera_data)
    status 201
    hiera_data.to_json
  rescue PDS::DataAdapter::Conflict => e
    status 400
    { 'error': 'Bad Request. Unable to create requested hiera-data, check for duplicate hiera-data', 'details': e.message }.to_json
  end
end


App.add_route('DELETE', '/v1/hiera-data/{level}/{key}', {
  "resourcePath" => "/HieraData",
  "summary" => "Deletes a Hieradata object",
  "nickname" => "delete_hiera_data_object",
  "responseClass" => "void",
  "endpoint" => "/hiera-data/{level}/{key}",
  "notes" => "Permanently removes the Hiera object that matches the level/key ID",
  "parameters" => [
    {
      "name" => "level",
      "description" => "The Hiera level",
      "dataType" => "String",
      "paramType" => "path",
    },
    {
      "name" => "key",
      "description" => "The Hiera key",
      "dataType" => "String",
      "paramType" => "path",
    },
    ]}) do
  cross_origin
  # the guts live here

  # TODO: validate input
  deleted = data_adapter.delete(:hiera_data, filters: [['=', 'level', params['level']], ['=', 'key', params['key']]])
  if deleted.zero?
    status 404
  else
    status 200
  end
end


App.add_route('GET', '/v1/hiera-data', {
  "resourcePath" => "/HieraData",
  "summary" => "Get all hiera data available in the system",
  "nickname" => "get_hiera_data",
  "responseClass" => "Array<HieraValue>",
  "endpoint" => "/hiera-data",
  "notes" => "Get all Hiera data",
  "parameters" => [
    {
      "name" => "level",
      "description" => "(Optional) This will filter by Hiera level (URL encoded), e.g. &#39;level%2Fone%2Fglobal&#39;",
      "dataType" => "String",
      "allowableValues" => "",
      "paramType" => "query",
    },
    ]}) do
  cross_origin
  # the guts live here

  # TODO: validate input
  filters = []
  filters << ['=', 'level', params['level']] unless params['level'].nil?
  hiera_data = data_adapter.read(:hiera_data, filters: filters)
  hiera_data.to_json
end


App.add_route('GET', '/v1/hiera-data/{level}/{key}', {
  "resourcePath" => "/HieraData",
  "summary" => "Get a specific hiera value",
  "nickname" => "get_hiera_data_with_level_and_key",
  "responseClass" => "HieraValue",
  "endpoint" => "/hiera-data/{level}/{key}",
  "notes" => "Get Hiera data that matches the given {level} and {key}",
  "parameters" => [
    {
      "name" => "level",
      "description" => "The Hiera level",
      "dataType" => "String",
      "paramType" => "path",
    },
    {
      "name" => "key",
      "description" => "The Hiera key",
      "dataType" => "String",
      "paramType" => "path",
    },
    ]}) do
  cross_origin
  # the guts live here

  # TODO: validate input
  hiera_data = data_adapter.read(:hiera_data, filters: [['=', 'level', params['level']], ['=', 'key', params['key']]])
  if hiera_data.empty?
    status 404
  else
    hiera_data.first.to_json
  end
end


App.add_route('PUT', '/v1/hiera-data/{level}/{key}', {
  "resourcePath" => "/HieraData",
  "summary" => "Upserts a specific hiera object",
  "nickname" => "upsert_hiera_data_with_level_and_key",
  "responseClass" => "HieraValue",
  "endpoint" => "/hiera-data/{level}/{key}",
  "notes" => "If the hieradata with the compound ID {level} and {key} does not exist, it will create it for you. This endpoint does not support bulk operations",
  "parameters" => [
    {
      "name" => "level",
      "description" => "The Hiera level",
      "dataType" => "String",
      "paramType" => "path",
    },
    {
      "name" => "key",
      "description" => "The Hiera key",
      "dataType" => "String",
      "paramType" => "path",
    },
    {
      "name" => "body",
      "description" => "Create or edit a Hiera value at a specified level and key",
      "dataType" => "UNKNOWN_BASE_TYPE",
      "paramType" => "body",
    }
    ]}) do
  cross_origin
  # the guts live here

  # TODO: validate input
  hiera_data = JSON.parse(request.body.read)
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

