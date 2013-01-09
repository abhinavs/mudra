require 'rubygems'
require File.join(File.dirname(__FILE__), 'mudra')
set :environment, ENV['APP_ENV'].to_sym
run Mudra::Application
