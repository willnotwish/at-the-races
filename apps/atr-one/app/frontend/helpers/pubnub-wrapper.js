import Pubnub from 'pubnub'

const subscribeToPubnub = (handler, options) => {
  console.log("subscribeToPubnub starting...")

  const client = new Pubnub({
    subscribeKey: options.subscribe_key,
    userId: options.user_id
  })

  const subscription = client.channel(options.channel)
                             .subscription({ receivePresenceEvents: false });
    
  subscription.addListener({ message: handler })
  subscription.subscribe()

  console.log('subscribeToPubnub complete. Listening for pubnub messages...')
}

export {
  subscribeToPubnub
}
