<script>
import moment from 'moment'

export default {
  props: {
    message: Object
  },
  computed: {
    source() {
      return `Source ${this.message.source}`
    },

    timestamp() {
      const ts = this.message.timestamp
      const hms = moment.unix(ts).format("HH:mm:ss")
      const decimal = (ts % 1).toFixed(6).substring(2)
      return `${hms}.${decimal}`
    },

    title() {
      return JSON.stringify(this.message);
    }
  },
}
</script>

<template>
  <div class="mb-2 border border-indigo-600 p-2" :title="title">
    <header class="flex flex-row flex-nowrap justify-between">
      <div class="mr-4 font-bold">{{ message.source }}</div>
      <div font-bold>{{ message.type }}</div>
    </header>
    <div class="flex flex-row flex-nowrap justify-between">
      <p class="mb-2 font-light text-sm">{{ timestamp }}</p>
      <p class="font-light text-sm text-right">{{ message.text }}</p>
    </div>
  </div>
</template>
