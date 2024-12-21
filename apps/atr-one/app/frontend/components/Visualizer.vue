<script>

import TimelinePanel from './TimelinePanel.vue'
import MessagePanel from './MessagePanel.vue'
// import { subscribeToPubnub } from '../helpers/pubnub-wrapper'
import { subscribeToCentrifugo } from '../helpers/centrifugo-wrapper'
import { DataSet } from 'vis-data'
import { v4 as uuidv4 } from 'uuid'

export default {
  components: {
    TimelinePanel,
    MessagePanel
  },

  props: {
    mainTitle: String,
    raceConfig: Object,
    pubnubConfig: Object,
    centrifugoConfig: Object
  },

  data() {
    return {
      dataset: new DataSet(),
      groups: new DataSet()
    }
  },

  computed: {
    raceId() {
      return this.raceConfig.id
    },
  },

  methods: {

    onDataPublished(event) {
      console.log("onDataPublished received: ", event)

      const message = event.message
      const payload = message.payload

      if (payload.race_id != this.raceId) {
        console.log("onDataPublished. Unexpected race id. Event ignored.")
        return
      }

      const type = message.id
      if (type == 'groups.defined') {
        payload.groups.forEach((groupId) => {
          const group = {
            id: groupId,
            label: groupId
          }
          console.log('onDataPublished. About to add group: ', group)
          this.groups.add(group)
        })
        return
      }

      const item = {
        id: uuidv4(),
        type: type,
        text: payload.text,
        source: payload.pid,
        timestamp: payload.timestamp
      }

      console.log('onDataPublished. About to add item to source data set: ', item)
      this.dataset.add(item)
    },
  },

  mounted() {
    subscribeToCentrifugo(this.onDataPublished, this.centrifugoConfig)
    // subscribeToPubnub(this.onPubnubEvent, this.pubnubConfig)
  }
}
</script>

<template>
  <div>
    <header class="my-8">
      <h1 class="text-lg font-bold mb-4">{{ mainTitle }}</h1>
      <h2>Race {{ raceId }}</h2>
    </header>

    <div class="mx-auto">
      <TimelinePanel :source="dataset" :groups="groups"></TimelinePanel>
    </div>

    <div class="mx-auto">
      <MessagePanel :source="dataset" :groups="groups"></MessagePanel>
    </div>
  </div>
</template>
