<script setup>
import { ref, onMounted } from 'vue'
import Pubnub from 'pubnub'

defineProps({
  msg: String,
  mainTitle: String
})

const count = ref(0)

onMounted(() => {
  console.log("App is mounted")

  const client = new Pubnub({
    subscribeKey: "sub-c-618301a8-8591-4466-b90d-2d410d308e19",
    userId: "at-the-races-user"
  })

  console.log("Pubnub client: ", client)

  const messageProcessor = (event) => {
    console.log("Message received, timetoken: ", event.message, event.timetoken)
  }

  const subscription = client
    .channel('at-the-races')
    .subscription({ receivePresenceEvents: false });
    
    subscription.addListener({ message: messageProcessor });
    subscription.subscribe();

    console.log('Listening for pubnub messages...');

})
</script>

<template>
  <h1>{{ mainTitle }}</h1>

  <div class="card">
    <button type="button" @click="count++">count is {{ count }}</button>
    <p>
      Edit
      <code>components/HelloWorld.vue</code> to test HMR
    </p>
  </div>

  <p>
    Check out
    <a href="https://vuejs.org/guide/quick-start.html#local" target="_blank"
      >create-vue</a
    >, the official Vue + Vite starter
  </p>
</template>

<style scoped>
.read-the-docs {
  color: #888;
}
</style>
