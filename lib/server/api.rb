require 'json'
require 'pry-remote'

class API < Grape::API
  format :json

  helpers do
    def redis
      env.config['redis']
    end

    def queue
      env.config['queue']
    end

    def exchange
      env.config['exchange']
    end
  end

  resource 'events' do
    get "/" do
      if params['hub.verify_token'] == "test-app-123"
        params['hub.challenge'].to_i
      else
        error!("Verification failed", 401)
      end
    end

    post "/" do
      env['rack.logger'].info params

      begin
        exchange.publish(JSON.dump(params))
      rescue => e
        env['rack.logger'].error "#{e}"
        env['rack.logger'].error JSON.dump(params)
      end

      status 201
      "Created"
    end
  end
end
