class UsersController < ApplicationController

  #post '/v1/:app_id/users'
  post '/v1/users' do
    authenticate_app!
    manage_resource @app.users.build(params.slice(*User.accessible_keys)),
      :status => 201 do |user|
      user.save!
    end
  end

  get '/v1/users/:user_id' do
    authenticate_app!
    manage_resource @user
  end

  get '/v1/users/:user_id/current_balance' do
    authenticate_app!
    json_response({:current_balance => @user.current_balance})
  end

  put '/v1/users/:user_id' do
    authenticate_app!
    manage_resource @user do |user|
      attributes = params.slice(*App.accessible_keys).reject {|k,v| k == "user_uid"}
      user.update_attributes!(attributes)
    end
  end

  delete '/v1/users/:user_id' do
    authenticate_app!
    manage_resource @user, :response => {"response" => "ok"} do |user|
      user.mark_as_deleted
    end
  end

  get '/v1/users' do
    authenticate_app!
    manage_resource paginate(@app.users)
  end

end
