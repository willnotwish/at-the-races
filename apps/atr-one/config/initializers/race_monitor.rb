class RaceMonitor
  include Dry::Initializer.define -> do
    option :message_bus
    option :race
  end

  def call(id, payload)
    message_bus.publish(id, payload.merge(race_id: race.id))
  end

  # alias signal call
end
