import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import axios from './utils/api'

// Импортируем CSS стили
import './index.css'

// Создаем экземпляр Pinia (хранилище)
const pinia = createPinia()

// Создаем и монтируем приложение
const app = createApp(App)
app.use(pinia)
app.use(router)

// Добавляем глобальные данные из .env
app.config.globalProperties.$appName =
  import.meta.env.VITE_APP_NAME || 'КороткоСсылка'
app.config.globalProperties.$appDescription =
  import.meta.env.VITE_APP_DESCRIPTION

app.mount('#app')
