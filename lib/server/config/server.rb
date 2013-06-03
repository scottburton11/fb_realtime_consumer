require 'bundler/setup'
require 'em-redis'

config['test'] = "Foo"

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  config['redis'] = EM::Protocols::Redis.connect(:host => uri.host, :port => uri.port, :password => uri.password, :user => uri.user)
else
  config['redis'] = EM::Protocols::Redis.connect 
end