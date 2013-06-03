require 'json'

class API < Grape::API
  format :json

  helpers do
    def redis
      env.config['redis']
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
        event_set = EventSet.new(params)

        event_set.events.each do |event|
          event.changes.each do |change|
            if change.like?
              redis.send(change.operator, "fb-#{(change.target_id || event.id)}-likes_count")
              if change.add?
                redis.sadd("fb-#{change.target_id || event.id}-likes", {:actor_id => change.actor_id, :time => change.time})
              end
            end
          end
        end
      rescue => e
        env['rack.logger'].warn e
      end

      status 201
      "Created"
    end
  end
end
