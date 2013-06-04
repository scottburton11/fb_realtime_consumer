require 'bundler/setup'
require 'em-redis'
require 'amqp'

config['test'] = "Foo"

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  config['redis'] = EM::Protocols::Redis.connect(:host => uri.host, :port => uri.port, :password => uri.password, :user => uri.user)
else
  config['redis'] = EM::Protocols::Redis.connect 
end

if ENV["CLOUDAMQP_URL"]
  config['queue'] = AMQP.connect(ENV["CLOUDAMQP_URL"])
else
  config['queue'] = AMQP.connect
end

config['channel'] = AMQP::Channel.new(config['queue'])
config['exchange'] = config['channel'].fanout("hyfn8.facebook.publish")
