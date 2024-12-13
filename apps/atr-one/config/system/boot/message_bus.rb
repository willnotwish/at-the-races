# Be sure to name this file after the component you want to boot. Otherwise you see:
# 
# Bootable component :xxx was already registered (Dry::System::DuplicatedComponentKeyError) errors.

AtrOne::Container.boot(:message_bus) do |container|
  # Basic setup code, eg require third party code and perform basic configuration
  init do
    register(:message_bus, MessageBus.new)
  end

  # Code that needs to run for a component to be usable at application's runtime.
  # By the time these (stop & start) are called the container is fully initialized.

  # Subscribe default broker to the message bus
  start do
    container[:message_bus].subscribe(container[:centrifugo_event_broker])
  end
    
  stop do
    container[:message_bus].unsubscribe(container[:centrifugo_event_broker])
  end
end
