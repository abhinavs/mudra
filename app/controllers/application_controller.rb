require 'sinatra/base' # Your file should require sinatra/base instead of sinatra; otherwise, all of Sinatra’s DSL methods are imported into the main namespace
require 'sinatra/json'
require 'sinatra/activerecord'
require "sinatra/reloader"

class ApplicationController < Sinatra::Base
  DEFAULT_PAGE_SIZE = 10
  MAX_PAGE_SIZE     = 30

  register Sinatra::CrossOrigin
  register Sinatra::ActiveRecordExtension

  configure :development do
    register Sinatra::Reloader
  end

  configure do
    enable :cross_origin

    set :allow_origin, "*" # allows any origin(domain) to send fetch requests to your API
    #set :allow_methods, [:get, :post, :patch, :delete, :options] # allows these HTTP verbs
    set :allow_methods, [:get, :options] # allows these HTTP verbs
    set :allow_credentials, true
    set :max_age, 1728000
    set :expose_headers, ['Content-Type']

    set :server, :puma

    root_dir = "#{File.dirname(__FILE__)}/../../"
    set :root, root_dir
    set :database_file, File.join(root, "config/database.yml")

    set :public_folder, File.join(root, "/public")
    set :views, File.join(root, "app/views")
  end

  options '*' do
    response.headers["Allow"] = "HEAD,GET,POST,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    200
  end

  mime_type :json, "application/json"

  before { content_type :json }
  before { if ['/', '/v1/apps'].include?(request.env['PATH_INFO']) then pass end; authenticate_app! }

  helpers do

    def throw_unauthenticated_response
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, json_response(:error => "unauthorized")])
    end

    def authenticate_app!
      throw_unauthenticated_response unless authenticated_app?
    end

    def authenticated_app?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      if @auth.provided? && @auth.basic? && @auth.credentials
	@app = App.valid_app(@auth.username)
	return false unless @app
	return false if params[:app_id].present? &&
	  !@app.authorized?(params[:app_id])

	return true if params[:user_id].blank?
	@user = User.get_by_app_id_and_user_id(@app.id, params[:user_id])
	@user ? true : false
      else
	false
      end
    end

    not_found { throw :halt, [404, json_response({:error => 'not_found'})] }

    def json_response(object)
      if object.nil?
        not_found
      elsif object.is_a?(Array)
	object.map { |element| element.attrs }.to_json
      else
	object.to_json
      end
    end

    def valid_record(record, options={})
      options = {:status => 200, :response => record}.merge(options)
      status(options[:status])
      json_response(options[:response])
    end

    def invalid_record(record)
      throw :halt, [422, json_response(:errors => record.errors.full_messages)]
    end

    def manage_resource(resource, options={})
      raise Sinatra::NotFound unless resource
      yield(resource) if block_given?
      valid_record(resource, options)
    rescue ActiveRecord::RecordInvalid => e
      invalid_record(e.record)
    end

    def paginate(ar_relation)
      if params[:max_id].present?
	ar_relation = ar_relation.where('id < ?', params[:max_id])
      end

      if params[:limit].blank?
	limit = DEFAULT_PAGE_SIZE
      else
	limit = params[:limit].to_i > MAX_PAGE_SIZE ?
	  MAX_PAGE_SIZE : params[:limit]
      end

      ar_relation.limit(limit).all
    end


  end
end
