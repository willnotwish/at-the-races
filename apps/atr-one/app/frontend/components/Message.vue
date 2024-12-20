<script>
import moment from 'moment'

export default {
  props: {
    data: Object,
    metadata: Object
  },
  
  computed: {
    timestamp() {
      const ts = this.data.timestamp
      const hms = moment.unix(ts).format("HH:mm:ss")
      const decimal = (ts % 1).toFixed(6).substring(2)
      return `${hms}.${decimal}`
    },

    title() {
      return JSON.stringify(this.data);
    },

    labelText() {
      return this.metadata.label
    },

    wrapperClass() {
      return this.metadata.htmlClasses.wrapper
    }
  },
}
</script>

<template>
  <div class="mb-2 p-2" :class="wrapperClass" :title="title">
    <!-- <p>{{ metadata }}</p> -->
    <header class="flex flex-row flex-nowrap justify-between">
      <div class="mr-4 font-bold">{{ labelText }}</div>
      <div font-bold>{{ data.type }}</div>
    </header>
    <div class="flex flex-row flex-nowrap justify-between">
      <p class="mb-2 font-light text-sm">{{ timestamp }}</p>
      <p class="font-light text-sm text-right">{{ data.text }}</p>
    </div>
  </div>
</template>
