<script>

import Pubnub from 'pubnub'

export default {
  props: ['mainTitle'],

  data() {
    return {
      race_id: 0,
      count: 0,
      events: []
    }
  },

  methods: {
    onEventReceived(event) {
      const message = event.message
      const message_type = message.id
      const timetoken = event.timetoken
      const payload = message.payload
      const race_id = payload.race_id

      console.log("onMessageReceived received, timetoken: ", message, timetoken)

      if (race_id != this.race_id) {
        console.log("Unknown race id. Message ignored...")
        return
      }

      this.count++
      this.events.push(event)
    }
  },

  mounted() {
    console.log("Visualizer mounted. this: ", this)

    const client = new Pubnub({
      subscribeKey: "sub-c-618301a8-8591-4466-b90d-2d410d308e19",
      userId: "at-the-races-user"
    })

    console.log("Pubnub client: ", client)

    const subscription = client
      .channel('at-the-races')
      .subscription({ receivePresenceEvents: false });
      
    subscription.addListener({ message: this.onEventReceived })
    subscription.subscribe()

    console.log('Listening for pubnub messages...')
  }
}
</script>

<template>
  <div>
    <header class="my-8">
      <h1 class="text-xl mb-4 text-center">{{ mainTitle }}</h1>
      <h2 class="text-lg mb-4 text-center">Visualization</h2>
    </header>

    <main>
      <div class="mb-4 border-b-2">
        <label>
          Race ID
          <input v-model="race_id" placeholder="edit race ID">        
        </label>
      
      </div>
      <div class="mb-4">Event count: {{ count }}</div>
      <ul>
        <li v-for="event in events" :key="event">{{ event.message }}</li>
      </ul>
    </main>

    <footer class="mt-8 border-t-2 pt-4">
      Footer (say something meaningful here)
    </footer>
  </div>
</template>

<style scoped>
</style>
