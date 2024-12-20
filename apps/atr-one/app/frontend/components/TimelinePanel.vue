<script>

import { Timeline } from 'vis-timeline/standalone'
import { DataSet, createNewDataPipeFrom } from 'vis-data'
import moment from 'moment'

export default {
  props: {
    source: DataSet,
    groups: DataSet
  },

  data() {
    return {
      timelineData: new DataSet()
    }
  },

  methods: {
    view() {
      new Timeline(this.$refs.container)
        .setData({groups: this.groups, items: this.timelineData})
    }
  },

  mounted() {
    // Timeline requires a different data format
    function toTimelineFormat(item) {
      return {
        id: item.id,
        start: moment.unix(item.timestamp),
        content: item.text,
        group: item.source,
        className: 'xxxy'
      }
    }

    createNewDataPipeFrom(this.source)
      .map(toTimelineFormat)
      .to(this.timelineData)
      .all()
      .start()
  }
}
</script>

<template>
  <div>
    <button @click="view" class="text-orange-700 hover:underline">View Timeline</button>
    <div ref="container"></div>
  </div>
</template>
