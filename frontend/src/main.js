import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'

// Vuetify
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import '@mdi/font/css/materialdesignicons.css'

const vuetify = createVuetify({
  components,
  directives,
  theme: {
    defaultTheme: 'light',
    themes: {
      light: {
        colors: {
          primary: '#1A4229',
          secondary: '#1A4229',
          background: '#FFFFEA',
          surface: '#FFFFEA',
        },
      },
    },
  },
})

try {
  const app = createApp(App)
  app.use(createPinia())
  app.use(router)
  app.use(vuetify)
  
  // Debugging logs
  console.log('Before mounting app')
  app.mount('#app')
  console.log('After mounting app')
} catch (error) {
  console.error('Application initialization failed:', error)
}
