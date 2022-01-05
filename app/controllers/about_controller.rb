class AboutController < ApplicationController

  get '/' do
    content_type :html
    erb :"/about.html"
  end

  get '/status' do
    json_response({status: "ok"})
  end

end
