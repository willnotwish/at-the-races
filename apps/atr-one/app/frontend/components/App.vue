<script>
import Visualizer from './Visualizer.vue'

export default {
  components: {
    Visualizer
  },

  props: {
    raceConfig: Object,
    pubnubConfig: Object
  },

  methods: {
    async startRace() {
      console.log("Starting race now...")
      const url = this.raceConfig.start_url

      const response = await fetch(url, { method: 'POST' });
      if (!response.ok) {
        throw new Error(`Response status: ${response.status}`);
      }
      const json = await response.json();
      console.log(json);
    }
  }
}
</script>

<template>
  <v-app>
    <v-container>
      <v-btn @click="startRace">
        Start now
      </v-btn>
      <Visualizer mainTitle="ATR Visualization" :raceConfig="raceConfig" :pubnubConfig="pubnubConfig" />
    </v-container>
  </v-app>
</template>

