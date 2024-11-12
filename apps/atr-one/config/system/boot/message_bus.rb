# Be sure to name this file after the component. Otherwise you see
# Bootable component :xxx was already registered (Dry::System::DuplicatedComponentKeyError) errors.

DEFAULT_BROKER = :pub_nub_event_broker

AtrOne::Container.boot(:message_bus) do |container|
  # Basic setup code, eg require third party code and perform basic configuration
  init do
    register(:message_bus, MessageBus.new)
  end

  # Code that needs to run for a component to be usable at application's runtime.
  # Subscribe default broker to the message bus
  start do
    container[DEFAULT_BROKER].tap do |broker|
      container[:message_bus].subscribe(broker)
    end
  end

  # Code that needs to run to stop a component, eg close a database connection, clear some artifacts etc
  # Unsubscribe default broker from the message bus
  stop do
    container[DEFAULT_BROKER].tap do |broker|
      container[:message_bus].unsubscribe(broker)
    end
  end
end
