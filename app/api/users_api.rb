require 'json'

App.add_route('POST', '/v1/users', {
  "resourcePath" => "/Users",
  "summary" => "Create user",
  "nickname" => "create_user",
  "responseClass" => "Array<User>",
  "endpoint" => "/users",
  "notes" => "The body params are required to be a JSON object with an array of users. This endpoint supports bulk operations, you can create one or 1000 users in a single POST request.",
  "parameters" => [
    {
      "name" => "body",
      "description" => "Create user object(s)",
      "dataType" => "Array<ImmutableUserProperties>",
      "paramType" => "body",
    }
    ]}) do
  cross_origin
  authenticate!

  # TODO: validate input
  body_params = request.body.read
  return status 400 if body_params.empty?

  new_users = JSON.parse(body_params)

  begin
    new_users.each { |user| user['status'] = 'active' }
    set_new_timestamps!(new_users)
    users_created = data_adapter.create(:users, resources: new_users)

    if users_created.present?
      status 201
      users_created.to_json
    else
      status 400
      { 'error': 'Bad Request. Unable to create requested users, check for duplicate users' }.to_json
    end
  rescue PDS::DataAdapter::Conflict => e
    status 400
    e.message
  end
end


App.add_route('DELETE', '/v1/users/{username}', {
  "resourcePath" => "/Users",
  "summary" => "Deletes a user",
  "nickname" => "delete_user",
  "responseClass" => "void",
  "endpoint" => "/users/{username}",
  "notes" => "This can only be done by the logged in user.",
  "parameters" => [
    {
      "name" => "username",
      "description" => "The username",
      "dataType" => "String",
      "paramType" => "path",
    },
    ]}) do
  cross_origin
  authenticate!

  # TODO: validate input
  deleted = data_adapter.delete(:users, filters: [['=', 'username', params['username']]])
  if deleted.zero?
    status 404
  else
    status 200
  end
end


App.add_route('GET', '/v1/users', {
  "resourcePath" => "/Users",
  "summary" => "Get all available users",
  "nickname" => "get_all_users",
  "responseClass" => "Array<User>",
  "endpoint" => "/users",
  "notes" => "This can only be done by the logged in user with a superadmin role.",
  "parameters" => [
    ]}) do
  cross_origin
  authenticate!

  users = data_adapter.read(:users)
  users.map { |hash| hash.select { |key,_| key != 'temp-token' }}.to_json
end


App.add_route('GET', '/v1/users/{username}/token', {
  "resourcePath" => "/Users",
  "summary" => "Get API token by username",
  "nickname" => "get_token_by_username",
  "responseClass" => "Token",
  "endpoint" => "/users/{username}/token",
  "notes" => "Retrieve an API token for the user",
  "parameters" => [
    {
      "name" => "username",
      "description" => "The username",
      "dataType" => "String",
      "paramType" => "path",
    },
    ]}) do
  cross_origin
  authenticate!

  # TODO: validate input
  user = data_adapter.read(:users, filters: [['=', 'username', params['username']]])
  if user.empty?
    status 404
  else
    { 'token' => user.first['temp-token']}.to_json
  end
end


App.add_route('GET', '/v1/users/{username}', {
  "resourcePath" => "/Users",
  "summary" => "Get user by username",
  "nickname" => "get_user_by_username",
  "responseClass" => "User",
  "endpoint" => "/users/{username}",
  "notes" => "Retrieve a specific user.",
  "parameters" => [
    {
      "name" => "username",
      "description" => "The username",
      "dataType" => "String",
      "paramType" => "path",
    },
    ]}) do
  cross_origin
  authenticate!

  # TODO: validate input
  users = data_adapter.read(:users, filters: [['=', 'username', params['username']]])
  if users.empty?
    status 404
  else
    users.first.select { |key,_| key != 'temp-token' }.to_json
  end
end


App.add_route('PUT', '/v1/users/{username}', {
  "resourcePath" => "/Users",
  "summary" => "Create a new user or replace an existing user",
  "nickname" => "put_user",
  "responseClass" => "User",
  "endpoint" => "/users/{username}",
  "notes" => "If the username does not exist, it will create it for you. This endpoint does not support bulk operations",
  "parameters" => [
    {
      "name" => "username",
      "description" => "The username",
      "dataType" => "String",
      "paramType" => "path",
    },
    {
      "name" => "body",
      "description" => "Create or edit user object",
      "dataType" => "UNKNOWN_BASE_TYPE",
      "paramType" => "body",
    }
    ]}) do
  cross_origin
  authenticate!

  # TODO: validate input
  body_params = request.body.read
  return status 400 if body_params.empty?

  user = JSON.parse(body_params)
  user['username'] = params['username']
  user['status'] = 'active'

  update_or_set_new_timestamps!(:users, [user])
  data_adapter.upsert(:users, resources: [user])

  if user['created-at'] == user['updated-at']
    status 201
  else
    status 200
  end

  user.to_json
end

