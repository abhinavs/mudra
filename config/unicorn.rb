# worker_processes 128
timeout 10
preload_app true

apppath = "#{File.dirname(__FILE__)}/../mudra"

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end
#listen '/tmp/unicorn.sock', :backlog => 2048

after_fork do |server, worker|

end

before_exec do |server|
  #ENV['BUNDLE_GEMFILE'] = "#{apppath}/current/Gemfile"
  ENV['BUNDLE_GEMFILE'] = "#{apppath}/Gemfile"
end

#if ENV["APP_ENV"] == "development"
#    worker_processes 1
#else
#    worker_processes 3
#end

#timeout 30

