<script setup lang="ts">
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

onMounted(() => {
  const alias = route.params.alias
  // Редиректим пользователя на API, который уже сделает серверный редирект
  window.location.href = `http://api.frontend.local:8080/${alias}`
})
</script>

<template>
  <div class="text-center py-20">
    <h2 class="text-xl font-bold mb-4">Перенаправляем...</h2>
    <p>Пожалуйста, подождите</p>
  </div>
</template> 