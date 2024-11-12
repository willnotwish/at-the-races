class PubNubEventBroker
  include AtrOne::Deps[:logger]
  include AtrOne::Deps[:pubnub]

  def on_update_allocated(event)
    logger.info "PubNubEventBroker#on_update allocated. Event: #{event.id}, payload: #{event.payload}"
    publish(event)
  end

  def on_lock_acquired(event)
    logger.info "PubNubEventBroker#on_lock_acquired. Event: #{event.id}, payload: #{event.payload}"
    publish(event)
  end

  def publish(event)
    pubnub.publish(
      channel: 'at-the-races',
      message: { id: event.id, payload: event.payload }
    ) do |envelope|
      logger.debug "Published. Response: #{envelope.response}. Status: #{envelope.status}"
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
end
