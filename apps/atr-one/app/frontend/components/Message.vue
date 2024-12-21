<script>
import moment from 'moment'
import { colourSchemes } from '../helpers/colour-schemes'

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

    columnIndex() {
      return this.metadata.columnIndex
    },

    columnCount() {
      return this.metadata.columnCount
    },

    prePad() {
      const a = []
      for (let index = 0; index < this.columnIndex; index++) {
        a.push(index)
      }
      return a
    },

    postPad() {
      const a = []
      for (let index = this.columnIndex + 1; index < this.columnCount; index++) {
        a.push(index)
      }
      return a
    },

    containerClass() {
      const classes = {}
      classes[this.colourScheme.container] = true

      // const positions = colsStartAndEndClasses[this.columnNumber]      
      // classes[positions[0]] = true
      // classes[positions[1]] = true
      
      return classes
    }
  },

  mounted() {
    console.log("Message component mounted. Metadata: ", this.metadata)
  }
}
</script>

<template>
  <div v-for="n in prePad"></div>
  <div class="mb-2 p-2 border-2" :class="containerClass" :title="title">
    <header class="flex flex-row flex-nowrap justify-between">
      <div class="mr-4 font-bold" :class="colourScheme.label">{{ labelText }}</div>
      <div font-bold :class="colourScheme.label">{{ data.type }}</div>
    </header>
    <div class="flex flex-row flex-nowrap justify-between">
      <p class="mb-2 font-light text-sm">{{ timestamp }}</p>
      <p class="font-light text-sm text-right">{{ data.text }}</p>
    </div>
  </div>
  <div v-for="n in postPad"></div>
</template>
