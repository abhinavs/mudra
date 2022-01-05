ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

require './lib/mudra_record'
require './lib/mudra_key_generator'
require './app/controllers/application_controller'
require_all 'app'
