<script>

// In order to play nicely with Vue's v-for and its array change detection,
// maintain a separated js array with message IDs.
// See https://vuejs.org/guide/essentials/list#array-change-detection

import Message from './Message.vue'
import { DataSet } from 'vis-data'
import { colourSchemes, gridColsClasses } from '../helpers/colour-schemes'

export default {
  components: {
    Message,
  },

  props: {
    source: DataSet,
    groups: DataSet
  },

  data() {
    return {
      ids: [],
      colourSchemeMap: {}, // maps colour scheme names to source IDs
      columnIndexMap: {}   // maps column indices to source IDs
    }
  },

  computed: {
    messageCount() {
      return this.ids.length
    },
    groupCount() {
      return this.groups.length
    },
    gridColsClass() {
      return gridColsClasses[this.groupCount - 1]
    }
  },

  methods: {
    decorateMessage(id) {
      const data = this.source.get(id)
      const groupId = data.source.toString()
      const colourScheme = this.colourSchemeMap[groupId] || 'neutral'
      const columnIndex = this.columnIndexMap[groupId] || 0
      const columnCount = this.groupCount
      const metadata = { colourScheme, columnIndex, columnCount, ...this.groups.get(groupId) }
      return { data, metadata }
    },
  },

  mounted() {
    // The 'add' event is called when one or more items are added to the dataset    
    this.source.on('add', (_event, properties) => {
      this.ids.push(...properties.items) // in case there are many, use ...
    })

    const csNames = Object.keys(colourSchemes)
    let index = 0
    this.groups.on('add', (_event, properties) => {
      properties.items.forEach((groupId) => {
        this.colourSchemeMap[groupId] = csNames[index] || csNames[0]
        this.columnIndexMap[groupId] = index
        index++
      })
    })
  }
}
</script>

<template>
  <div>
    <h3 class="mb-2">Message count: <strong>{{ messageCount }}</strong></h3>
    <div class="grid gap-1" :class="gridColsClass">
      <Message v-for="id in ids" :key="id" v-bind="decorateMessage(id)"></Message>
    </div>
  </div>
</template>
