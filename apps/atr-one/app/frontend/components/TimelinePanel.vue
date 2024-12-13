<script>

import { Timeline } from 'vis-timeline/standalone'
import { DataSet, createNewDataPipeFrom } from 'vis-data'
import moment from 'moment'

export default {
  props: {
    source: DataSet,
    groupIds: Array
  },

  data() {
    return {
      timelineData: new DataSet()
    }
  },

  computed: {
    groups() {
      return this.groupIds.map(id => {
        return { 
          id: id,
          content: `Process ${id}`
        }
      })
    }
  },

  methods: {
    view() {
      const timeline = new Timeline(this.$refs.container, this.timelineData)
      timeline.setGroups(this.groups)
    }
  },

  mounted() {
    // Timeline requires a different data format
    const pipe = createNewDataPipeFrom(this.source)
      .map(item => {
        const mapped = {
          id: item.id,
          start: moment.unix(item.timestamp),
          content: item.text,
          group: item.source,
          className: 'xxxy'
        }
        console.log("Timeline panel. Mapped data:", mapped)

        return mapped
      })
      .to(this.timelineData)

    pipe.all().start()
  }
}
</script>

<template>
  <div>
    <button @click="view" class="text-orange-700 hover:underline">View Timeline</button>
    <div ref="container"></div>
  </div>
</template>
