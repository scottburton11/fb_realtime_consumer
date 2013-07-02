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

    def verify_token
      env.config['verify_token']
    end

    def logger
      env['rack.logger']
    end
  end

  resource 'events' do
    get "/" do
      if params['hub.verify_token'] == verify_token
        params['hub.challenge'].to_i
      else
        error!("Verification failed", 401)
      end
    end

    post "/" do
      env['rack.logger'].info JSON.dump(params)

      begin
        # exchange.publish(JSON.dump(params))
        redis.rpush queue, JSON.dump(params)
      rescue => e
        env['rack.logger'].error "#{e}"
        env['rack.logger'].error JSON.dump(params)
      end

      status 201
      "Created"
    end
  end
end
