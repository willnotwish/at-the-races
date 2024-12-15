<script>

import Message from './Message.vue'
import { DataSet } from 'vis-data'

export default {
  components: {
    Message,
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
    <h3 class="mb-2">Message count: <strong>{{ messageCount }}</strong></h3>
    <ul>
      <li v-for="id in messageIds" :key="id">
        <Message :message="source.get(id)"></Message>
      </li>
    </ul>
  </div>
</template>
