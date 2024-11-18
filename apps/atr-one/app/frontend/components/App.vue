<script>
import Visualizer from './Visualizer.vue';

export default {
  components: {
    Visualizer
  },

  props: {
    raceConfig: Object,
    pubnubConfig: Object
  },
}
</script>

<template>
  <Visualizer mainTitle="ATR Visualization" :raceConfig="raceConfig" :pubnubConfig="pubnubConfig" />
</template>
