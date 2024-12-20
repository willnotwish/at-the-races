<script>

// In order to play nicely with Vue's v-for and its array change detection,
// maintain a separated js array with message IDs.
// See https://vuejs.org/guide/essentials/list#array-change-detection

import Message from './Message.vue'
import { DataSet } from 'vis-data'
import colourSchemes from '../helpers/colour-schemes'

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
      colourSchemeMap: {} // maps colour scheme names to source IDs
    }
  },

  computed: {
    messageCount() {
      return this.ids.length
    },
    groupCount() {
      return this.groups.length
    }
  },

  methods: {
    decorateMessage(id) {
      const data = this.source.get(id)
      const groupId = data.source.toString()
      const colourScheme = this.colourSchemeMap[groupId] || 'neutral'
      const metadata = { colourScheme, ...this.groups.get(groupId) }
      return { data, metadata }
    }
  },

  mounted() {
    // The 'add' event is called when one or more items are added to the dataset    
    this.source.on('add', (_event, properties) => {
      this.ids.push(...properties.items) // in case there are many, use ...
      console.log("MessagePanel add event on source dataset. Pushed ID. Count now: ", this.messageCount)
    })

    const csNames = Object.keys(colourSchemes)
    console.log("Colour scheme names: ", csNames)
    let index = 0
    this.groups.on('add', (_event, properties) => {
      properties.items.forEach((groupId) => {
        this.colourSchemeMap[groupId] = csNames[index] || csNames[0]
        index++
      })
    })
  }
}
</script>

<template>
  <div>
    <h3 class="mb-2">Message count: <strong>{{ messageCount }}</strong></h3>
    <ul>
      <li v-for="id in ids" :key="id">
        <Message v-bind="decorateMessage(id)"></Message>
      </li>
    </ul>
  </div>
</template>
