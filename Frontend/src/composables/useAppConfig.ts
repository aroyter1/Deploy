import { ref } from 'vue'

export function useAppConfig() {
  const appName = ref(import.meta.env.VITE_APP_NAME || 'КороткоСсылка')
  const appDescription = ref(
    import.meta.env.VITE_APP_DESCRIPTION || 'Сервис для сокращения ссылок'
  )
  const apiUrl = ref(import.meta.env.VITE_API_URL || 'https://api.local')
  const appPort = ref(import.meta.env.VITE_APP_PORT || '5200')
  const appHost = ref(import.meta.env.VITE_APP_HOST || 'frontend.local')

  return {
    appName,
    appDescription,
    apiUrl,
    appPort,
    appHost,
  }
}
