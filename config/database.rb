require 'active_record'
configure :development do
#set :database, 'sqlite:///dev.db'
 set :show_exceptions, true

 ActiveRecord::Base.establish_connection(
                 :adapter => "sqlite3",
                 :database => "dev.db"
                 )
 end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :host     => db.host,
   :username => db.user,
   :password => db.password,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end
=begin
module Mudra
  module Database
    def self.start(env)
      puts "Connecting to #{env} database"
      ActiveRecord::Base.configurations = Configuration["database"]
      ActiveRecord::Base.logger = Logger.new("#{File.dirname(__FILE__)}/../log/#{env}.log")
      ActiveRecord::Base.establish_connection(env.to_s)
      ActiveRecord::Base.connection_pool.instance_variable_set('@size', 100)
    end
  end # Database
end

Mudra::Database.start(ENV['APP_ENV'])
=end 
# Annotate command
#annotate -R config/boot.rb --model-dir models -s
