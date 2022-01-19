require 'json'
require 'pds/model/user'

App.post('/v1/users') do
  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  body = JSON.parse(body_params)
  new_users = with_defaults(body['resources'], PDS::Model::User)

  begin
    set_new_timestamps!(new_users)
    set_user_tokens!(new_users)

    users_created = data_adapter.create(:users, resources: new_users)
    status 201
    users_created.to_json
  rescue PDS::DataAdapter::Conflict => e
    render_error(400, 'Bad Request. Unable to create requested users, check for duplicate users', e.message)
  end
end


App.delete('/v1/users/{username}') do
  # TODO: validate input
  deleted = data_adapter.delete(:users, filters: [['=', 'username', params['username']]])
  if deleted.zero?
    render_error(404, 'User not found')
  else
    status 204
  end
end


App.get('/v1/users') do
  users = data_adapter.read(:users)
  users.map { |hash| hash.select { |key,_| key != 'temp-token' }}.to_json
end


App.get('/v1/users/{username}/token') do
  # TODO: validate input
  user = data_adapter.read(:users, filters: [['=', 'username', params['username']]])
  if user.empty?
    render_error(404, 'User not found')
  else
    { 'token' => user.first['temp-token']}.to_json
  end
end


App.get('/v1/users/{username}') do
  # TODO: validate input
  users = data_adapter.read(:users, filters: [['=', 'username', params['username']]])
  if users.empty?
    render_error(404, 'User not found')
  else
    users.first.select { |key,_| key != 'temp-token' }.to_json
  end
end


App.put('/v1/users/{username}') do
  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  body = JSON.parse(body_params)

  user = with_defaults(body, PDS::Model::User)
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

