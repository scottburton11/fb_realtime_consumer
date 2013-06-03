config['test'] = "Foo"

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  config['redis'] = EM::Protocols::Redis.connect.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  config['redis'] = EM::Protocols::Redis.connect 
end