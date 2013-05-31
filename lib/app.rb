require 'bundler/setup'
require 'goliath'

class App < Goliath::API

  use Goliath::Rack::Params

  def response(env)
    logger.info params
    [200, {}, :success]
  end
end
