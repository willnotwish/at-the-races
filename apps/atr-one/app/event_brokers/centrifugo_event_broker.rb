require 'tracing'

class CentrifugoEventBroker
  include AtrOne::Deps[:logger]
  include Tracing

  include AtrOne::Deps[:centrifugo_client]

  def publish(event)
    trace "About to publish event to centrifugo: #{event}"

    begin
      centrifugo_client.publish(
        channel: 'at-the-races',
        data: { message: { id: event.id, payload: event.payload } }
      )
    rescue Cent::ResponseError => ex
      trace "Centrifugo error: #{ex}"
    rescue Faraday::ClientError => ex
      trace "Faraday client (network) error: #{ex}"
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
