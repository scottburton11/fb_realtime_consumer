require 'bundler/setup'
require 'grape'
require 'yajl'
require 'goliath'

class App < Goliath::API

  use Goliath::Rack::Params

  def response(env)
    logger.info params
    API.call(env)
  end
end

class API < Grape::API
  format :json

  resource 'events' do
    get "/" do
      if params['hub.verify_token'] == "test-app-123"
        params['hub.challenge']
      else
        error!("Verification failed", 401)
      end
    end

    post "/" do
      env['rack.logger'].info params
      status 201
      "Created"
    end
  end
end
