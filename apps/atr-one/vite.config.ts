import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

// See https://github.com/vitejs/vite-plugin-vue/tree/main/packages/plugin-vue
import vue from '@vitejs/plugin-vue'

import vuetify from 'vite-plugin-vuetify'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue(),
    vuetify({ autoImport: true })
  ],
  server: {
    hmr: {
      // Set the port the dev server uses in order to avoid the error about HMR fallback
      port: 3036
    }
  }
})
