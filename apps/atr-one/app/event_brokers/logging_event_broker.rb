class LoggingEventBroker
  include AtrOne::Deps[:logger]

  def on_update_allocated(event)
    logger.info "LoggingEventBroker. update allocated. Event: #{event.inspect}"
  end
end
