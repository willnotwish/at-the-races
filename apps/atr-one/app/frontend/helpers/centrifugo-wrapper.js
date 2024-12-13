import { Centrifuge } from 'centrifuge'

const subscribeToCentrifugo = (handler, options) => {
  console.log("subscribeToCentrifugo starting. options: ", options)

  const centrifuge = new Centrifuge(options.ws_url, { token: options.token })
  console.log("subscribeToCentrifugo. centrifuge client: ", centrifuge)

  centrifuge.on('connecting', (context) => {
    console.log("subscribeToCentrifugo. Connecting: ", context)
  })

  centrifuge.on('connected', (context) => {
    console.log("subscribeToCentrifugo. Connected: ", context)
  })

  centrifuge.on('disconnected', (context) => {
    console.log("subscribeToCentrifugo. Disconnected: ", context)
  })

  centrifuge.connect()

  const subscription = centrifuge.newSubscription(options.channel)
  subscription.on('publication', (context) => {
    if (context.channel == options.channel) {
      handler(context.data)
    }
  })

  subscription.subscribe()

  console.log('subscribeToCentrifugo complete. Listening...')
}

export {
  subscribeToCentrifugo
}
