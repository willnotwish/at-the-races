<script>
import moment from 'moment'
import colourSchemes from '../helpers/colour-schemes'

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

    colourScheme() {
      return colourSchemes[this.metadata.colourScheme]
    },
  },

  mounted() {
    console.log("Message component mounted. Metadata: ", this.metadata)
  }
}
</script>

<template>
  <div class="mb-2 p-2 border-2" :class="colourScheme.container" :title="title">
    <!-- <p>{{ metadata }}</p> -->
    <header class="flex flex-row flex-nowrap justify-between">
      <div class="mr-4 font-bold" :class="colourScheme.label">{{ labelText }}</div>
      <div font-bold :class="colourScheme.label">{{ data.type }}</div>
    </header>
    <div class="flex flex-row flex-nowrap justify-between">
      <p class="mb-2 font-light text-sm">{{ timestamp }}</p>
      <p class="font-light text-sm text-right">{{ data.text }}</p>
    </div>
  </div>
</template>
