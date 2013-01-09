require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# converted to modular app, specs don't work at the moment!

describe "mudra" do
  before(:each) do
    App.delete_all
    @app_name = 'app1'
    @description = 'test description'
    @guid = rand(1000)
    post '/v1/apps', {
      :name  => @app_name,
      :description => @description,
      :guid => @guid }.to_json

    @app = Yajl::Parser.parse(last_response.body)
    @app_id = @app['id']

  end

  describe "POST on /apps" do
    it "should create a new app" do
      last_response.should be_ok, last_response.body

      get "/apps/#{@app_id}", nil, {"HTTP_AUTHORIZATION" => "Basic " + Base64::encode64("#{@app[:app_key]}:")
      attributes = Yajl::Parser.parse(last_response.body)
      attributes["name"].should         == @app_name
      attributes["description"].should  == @description
      attributes["guid"].should         == @guid
      attributes["status"].should       == App::ACTIVE
    end
  end

end
