require 'active_record'
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

# Annotate command
#annotate -R config/boot.rb --model-dir models -s
