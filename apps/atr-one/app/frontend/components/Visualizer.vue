<script>

import LoggingPanel from './LoggingPanel.vue'
import TimelinePanel from './TimelinePanel.vue'
// import { subscribeToPubnub } from '../helpers/pubnub-wrapper'
import { subscribeToCentrifugo } from '../helpers/centrifugo-wrapper'
import { DataSet } from 'vis-data'
import { v4 as uuidv4 } from 'uuid'

export default {
  components: {
    LoggingPanel,
    TimelinePanel
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
      groupIds: []
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
        this.groupIds = payload.groups
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
  <v-container>
    <header>
      <h1>{{ mainTitle }}</h1>
      <h2>Race {{ raceId }}</h2>
    </header>

    <v-card class="mx-auto">
      <TimelinePanel :source="dataset" :groupIds="groupIds"></TimelinePanel>
    </v-card>

    <v-card class="mx-auto">
      <LoggingPanel :source="dataset"></LoggingPanel>
    </v-card>
  </v-container>
</template>
