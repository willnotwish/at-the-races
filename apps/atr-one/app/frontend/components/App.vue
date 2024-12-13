<script>
import Visualizer from './Visualizer.vue'

export default {
  components: {
    Visualizer
  },

  props: {
    raceConfig: Object,
    pubnubConfig: Object,
    centrifugoConfig: Object
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
  <div>
    <button @click="startRace" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mt-4">
      Run race now
    </button>
    <Visualizer mainTitle="Visualization" :raceConfig="raceConfig" :pubnubConfig="pubnubConfig" :centrifugoConfig="centrifugoConfig" />
  </div>
</template>

