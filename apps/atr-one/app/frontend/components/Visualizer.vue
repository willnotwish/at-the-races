<script>

import LoggingPanel from './LoggingPanel.vue'
import TimelinePanel from './TimelinePanel.vue'
import { subscribeToPubnub } from '../helpers/pubnub-wrapper'
import { DataSet } from 'vis-data'

export default {
  components: {
    LoggingPanel,
    TimelinePanel
  },

  props: {
    mainTitle: String,
    raceConfig: Object,
    pubnubConfig: Object
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
    onPubnubEvent(event) {
      console.log("onPubnubEvent received: ", event)

      const message = event.message
      const payload = message.payload

      if (payload.race_id != this.raceId) {
        console.log("Unexpected race id. Event ignored.")
        return
      }

      const type = message.id
      if (type == 'groups.defined') {
        this.groupIds = payload.groups
      }

      const item = {
        id: event.timetoken, // a bit dubious, but maybe OK
        type: type,
        text: payload.text,
        source: payload.pid,
        timestamp: payload.timestamp
      }

      console.log('About to add item to source data set: ', item)
      this.dataset.add(item)
    },
  },

  mounted() {
    subscribeToPubnub(this.onPubnubEvent, this.pubnubConfig)
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
