# Be sure to name this file after the component. Otherwise you see
# Bootable component :xxx was already registered (Dry::System::DuplicatedComponentKeyError) errors.

AtrOne::Container.boot(:pubnub) do |container|
  init do    
    Pubnub.new(
      subscribe_key: ENV['PUBNUB_SUBSCRIBE_KEY'],
      publish_key: ENV['PUBNUB_PUBLISH_KEY'],
      secret_key: ENV['PUBNUB_SECRET_KEY'],
      user_id: ENV['PUBNUB_USER_ID']
    ).tap { |pubnub| register(:pubnub, pubnub) }
  end

  start do
    # container[:pubnub].tap do |broker|
    #   container[:message_bus].subscribe(broker)
    # end
  end

  stop do
    # container[:pubnub].tap do |broker|
    #   container[:message_bus].unsubscribe(broker)
    # end
  end
end
