require 'json'


PDSApp.add_route('POST', '/v1/hiera-data', {
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
  # the guts live here

  {"message" => "yes, it worked"}.to_json
end


PDSApp.add_route('DELETE', '/v1/hiera-data/{level}/{key}', {
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

  {"message" => "yes, it worked"}.to_json
end


PDSApp.add_route('GET', '/v1/hiera-data', {
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

  {"message" => "yes, it worked"}.to_json
end


PDSApp.add_route('GET', '/v1/hiera-data/{level}/{key}', {
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

  {"message" => "yes, it worked"}.to_json
end


PDSApp.add_route('PUT', '/v1/hiera-data/{level}/{key}', {
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

  {"message" => "yes, it worked"}.to_json
end

