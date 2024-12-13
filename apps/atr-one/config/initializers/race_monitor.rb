class RaceMonitor
  include Dry::Initializer.define -> do
    option :message_bus
    option :race
  end

  def call(id, payload)
    message_bus.publish(id, payload.merge(race_id: race.id, timestamp: Time.now.to_f))
  end
end
