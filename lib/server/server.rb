$: << ".."

require 'json'
require 'grape'
require 'goliath'
require 'em-redis'

require_relative '../app'
require_relative './api'


class Server < Goliath::API

  use Goliath::Rack::Params

  def response(env)
    API.call(env)
  end
end
