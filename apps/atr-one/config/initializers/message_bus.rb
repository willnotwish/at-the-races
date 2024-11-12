# Event pub/sub
class MessageBus
  include Dry::Events::Publisher[:internal_message_bus]

  # This message bus will publish the following events
  %w[
    update.allocated
    lock.acquired
    lock.released
    race_delay.starting
    race_delay.ended
    trace
    driver.start
    driver.stop
  ].each { |event| register_event(event) }

  def publish(id, opts)
    super(id, opts.merge(pid: Process.pid))
  end
end
