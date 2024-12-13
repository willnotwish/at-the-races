// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

// Example: Load Rails libraries in Vite.
//
// import * as Turbo from '@hotwired/turbo'
// Turbo.start()
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css

import '~/styles/tailwind-directives.css' // imports from app/frontend/styles

import { createApp } from 'vue'

import App from '~/components/App.vue'

const container = document.getElementById("visualization")
if (container) {
  const raceConfig = JSON.parse(container.dataset.race)
  console.log("raceConfig: ", raceConfig)
  
  const pubnubConfig = JSON.parse(container.dataset.pubnub)
  console.log("pubnubConfig: ", pubnubConfig)
  
  const centrifugoConfig = JSON.parse(container.dataset.centrifugo)
  console.log("centrifugoConfig: ", centrifugoConfig)
  
  createApp(App, { raceConfig, pubnubConfig, centrifugoConfig })
    .mount(container)
  
  console.log('Vite ⚡️ Rails. In visualization.js. App onMounted.')
}
