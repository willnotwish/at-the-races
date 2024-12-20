<script>

// In order to play nicely with Vue's v-for and its array change detection,
// maintain a separated js array with message IDs.
// See https://vuejs.org/guide/essentials/list#array-change-detection

import Message from './Message.vue'
import { DataSet } from 'vis-data'

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
      outerBorderClasses: ['border-red-400', 'border-indigo-600', 'border-yellow-400', 'border-lime-500', 'border-blue-500'],
      defaultColour: 'slate-500',
      twClasses: { 'outerBorder': {} }
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
      
      const htmlClasses = {}
      htmlClasses.wrapper = { 'border-2': true }
      htmlClasses.wrapper[this.twClasses['outerBorder'][groupId]] = true

      return { data, metadata: { htmlClasses, ...this.groups.get(groupId) } }
    }
  },

  mounted() {
    // The 'add' event is called when one or more items are added to the dataset    
    this.source.on('add', (_event, properties) => {
      this.ids.push(...properties.items) // in case there are many, use ...
      console.log("MessagePanel add event on source dataset. Pushed ID. Count now: ", this.messageCount)
    })

    let index = 0
    this.groups.on('add', (_event, properties) => {
      properties.items.forEach((id) => {
        this.twClasses['outerBorder'][id] = this.outerBorderClasses[index] || this.defaultColour
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
