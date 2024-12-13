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
  <div>
    <h3 class="mb-2">Message count: {{ messageCount }}</h3>
    <ul>
      <li v-for="id in messageIds" :key="id">
        <MessageListItem :message="source.get(id)"></MessageListItem>
      </li>
    </ul>
  </div>
</template>
