require 'tracing'

class PubnubEventBroker
  include AtrOne::Deps[:logger]
  include Tracing

  include AtrOne::Deps[:pubnub]

  def publish(event)
    pubnub.publish(
      channel: 'at-the-races',
      message: { id: event.id, payload: event.payload }
    ) do |envelope|
      trace "Published. Response: #{envelope.response}. Status: #{envelope.status}"
    end
  end

  alias on_update_allocated publish
  alias on_lock_acquired publish
  alias on_lock_released publish
  alias on_race_delay_starting publish
  alias on_race_delay_ended publish
  alias on_trace publish
  alias on_driver_start publish
  alias on_driver_stop publish
  alias on_groups_defined publish
  alias on_update_processed publish
end
