<script>

import MessageListItem from './MessageListItem.vue'
import { DataSet } from 'vis-data'

export default {
  components: {
    MessageListItem,
  },

  props: {
    source: DataSet
  },

  data() {
    return {
      messageIds: [],
    }
  },

  computed: {
    messageCount() {
      return this.messageIds.length
    }
  },

  mounted() {
    this.source
        .on('add', (_event, properties) => {
          this.messageIds.push(...properties.items)
        })
  }
}
</script>

<template>
  <v-list lines="one" density="compact">
    <v-list-subheader>Message count: {{ messageCount }}</v-list-subheader>
    <v-list-item v-for="id in messageIds" :key="id">
      <MessageListItem :message="source.get(id)"></MessageListItem>
    </v-list-item>
  </v-list>
</template>
