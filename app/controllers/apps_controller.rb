class AppsController < ApplicationController

  post '/v1/apps' do
    manage_resource App.new(params.slice(*App.accessible_keys)),
      :status => 201 do |app|
      app.save!
    end
  end

  get '/v1/apps/:app_id' do
    authenticate_app!
    manage_resource @app
  end

  put '/v1/apps/:app_id' do
    authenticate_app!
    manage_resource @app do |app|
      attributes = params.slice(*App.accessible_keys).reject {|k,v| k == "guid"}
      app.update_attributes!(attributes)
    end
  end

  delete '/v1/apps/:app_id' do
    authenticate_app!
    manage_resource @app, :response => {"response" => "ok"} do |app|
      app.mark_as_deleted
    end
  end

end
