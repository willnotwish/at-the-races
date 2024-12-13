import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue()
  ],
  server: {
    hmr: {
      // Set the port the dev server uses in order to avoid the error about HMR fallback
      port: 3036
    }
  }
})
