ENV['APP_ENV'] ||= 'development'

def require_local_lib(path)
  Dir["#{File.dirname(__FILE__)}/#{path}/*.rb"].each {|f| require f }
end

require 'rubygems'
require 'yaml'
Configuration = YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))

require 'bundler'
require 'logger'
require 'sinatra'
require 'sinatra/synchrony'
require 'active_record'
require 'em-synchrony/activerecord'
require 'json'
require 'rack/throttle'
#require 'rack/fiber_pool'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/hash/slice'

require "#{File.dirname(__FILE__)}/database"
require_local_lib('../library')
require_local_lib('../models')

#use Rack::FiberPool, :size => 25
#use Rack::CommonLogger, ActiveRecord::Base.logger

DEFAULT_PAGE_SIZE = 20
MAX_PAGE_SIZE     = 50
