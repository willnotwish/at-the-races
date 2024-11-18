<script>

import Pubnub from 'pubnub'

export default {
  props: {
    mainTitle: String,
    raceConfig: Object,
    pubnubConfig: Object
  },

  data() {
    return {
      count: 0,
      events: []
    }
  },

  computed: {
    raceId() {
      return this.raceConfig.id
    }
  },

  methods: {
    onEventReceived(event) {
      const message = event.message
      const message_type = message.id
      const timetoken = event.timetoken
      const payload = message.payload
      const event_race_id = payload.race_id

      console.log("onMessageReceived received, timetoken: ", message, timetoken)

      if (event_race_id != this.race_id) {
        console.log("Unknown race id. Message ignored...")
        return
      }

      this.count++
      this.events.push(event)
    }
  },

  mounted() {
    console.log("pubnub config: ", this.pubnubConfig)

    const client = new Pubnub({
      subscribeKey: this.pubnubConfig.subscribe_key,
      userId: this.pubnubConfig.user_id
    })

    console.log("Pubnub client: ", client)

    const subscription = client
      .channel(this.pubnubConfig.channel)
      .subscription({ receivePresenceEvents: false });
      
    subscription.addListener({ message: this.onEventReceived })
    subscription.subscribe()

    console.log('Listening for pubnub messages...')
    console.log('Race ID: ', this.raceId)
  }
}
</script>

<template>
  <div border-2 border-black>
    <header class="my-8">
      <h1 class="text-xl mb-4">{{ mainTitle }}</h1>
      <h2 class="text-lg mb-4">Race {{ raceId }}</h2>
    </header>

    <main>
      <div class="mb-4">Event count: <b>{{ count }}</b></div>
      <ul>
        <li v-for="event in events" :key="event">{{ event.message }}</li>
      </ul>
    </main>
  </div>
</template>
