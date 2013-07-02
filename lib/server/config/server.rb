require 'bundler/setup'
require 'em-redis'


if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  config['redis'] = EM::Protocols::Redis.connect(:host => uri.host, :port => uri.port, :password => uri.password, :user => uri.user)
else
  config['redis'] = EM::Protocols::Redis.connect 
end


config['queue'] = ENV['REALTIME_SOURCE_QUEUE'] || "realtime:fb:source"

config['verify_token'] = ENV['verify_token'] || "test-app-123"