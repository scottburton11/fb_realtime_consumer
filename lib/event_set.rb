require 'hashie'

class EventSet
  def initialize(params)
    @params = params
  end

  def object
    @params["object"]
  end

  def entries
    @params["entry"]
  end

  def events
    entries.map {|e| event_klass.new(e) }
  end

  def event_klass
    Event
  end

end

class Event

  attr_reader :params
  def initialize(params)
    @params = Hashie::Mash.new(params)
  end

  def id
    params['id']
  end

  def time
    params['time']
  end

  def changes
    params['changes'].map { |c| Change.new(c) }
  end

  class Change

    attr_reader :params
    def initialize(params)
      @params = Hashie::Mash.new(params)
    end

    def operator
      add? ? "incr" : "decr"
    end

    def actor_id
      params.value.user_id || params.value.sender_id
    end

    def target_id
      params.value.parent_id
    end

    def created_time
      params.value.created_time
    end
    alias :time :created_time

    def like?
      params.value.item == "like"
    end

    def unlike?
      like? && remove?
    end

    def add?
      params.value.verb == "add"
    end

    def remove? 
      params.value.verb == "remove"
    end
  end
end