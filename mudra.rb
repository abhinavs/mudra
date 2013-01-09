$:.<< File.dirname(__FILE__)

require File.join(File.dirname(__FILE__), 'config', 'boot')

module Mudra
  class Application < Sinatra::Base

    use Rack::Throttle::Daily,    :max => 1000  # requests
    use Rack::Throttle::Hourly,   :max => 100   # requests
    #use Rack::Throttle::Interval, :min => 1   # seconds

    mime_type :json, "application/json"
    configure { set :public_folder, File.join(File.dirname(__FILE__), 'public') }
    before { content_type :json }
    before { authenticate_app! }

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
        if object.is_a?(Array)
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

    get '/' do
      content_type :html
      erb :about
    end

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

    post '/v1/users/:user_id/credit' do
      authenticate_app!
      manage_resource @user.create_credit_transaction(params)
    end

    post '/v1/users/:user_id/debit' do
      authenticate_app!
      manage_resource @user.create_debit_transaction(params)
    end

    get '/v1/users/:user_id/transactions' do
      authenticate_app!
      manage_resource paginate(@user.all_transactions)
    end

    get '/v1/transactions' do
      authenticate_app!
      manage_resource paginate(@app.all_transactions)
    end
 end
end
