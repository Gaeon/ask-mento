<template>
  <v-app>
    <v-app-bar color="background" elevation="1" height="64">
      <v-container class="d-flex align-center px-4">
        <div class="d-flex align-center">
          <img 
            :src="logoImage" 
            alt="물어멘토" 
            class="nav-logo me-2 cursor-pointer"
            @click="goToQuestions"
          />
        </div>
        <v-spacer></v-spacer>
        <v-tabs v-model="activeTab" class="ml-4" center-active>
          <v-tab value="questions" @click="goToQuestions">Home</v-tab>
          <v-tab value="history" @click="goToHistory">History</v-tab>
          <v-tab value="my-page" @click="goToMyPage">My Page</v-tab>
        </v-tabs>
      </v-container>
    </v-app-bar>

    <v-main>
      <router-view v-slot="{ Component }">
        <component :is="Component" :key="$route.fullPath" />
      </router-view>
    </v-main>
  </v-app>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useTheme } from 'vuetify'
import logoImage from '../assets/logo.png'

const router = useRouter()
const route = useRoute()
const theme = useTheme()
const isDark = ref(false)
const activeTab = ref('questions')

// Sync active tab with current route
watch(() => route.name, (newName) => {
  if (newName === 'QuestionsPage') activeTab.value = 'questions'
  else if (newName === 'HistoryPage') activeTab.value = 'history'
  else if (newName === 'MyPage') activeTab.value = 'my-page'
}, { immediate: true })

const goToQuestions = () => {
  router.push({ name: 'QuestionsPage' })
}

const goToHistory = () => {
  router.push({ name: 'HistoryPage' })
}

const goToMyPage = () => {
  router.push({ name: 'MyPage' })
}

const toggleTheme = () => {
  isDark.value = !isDark.value
  theme.global.name.value = isDark.value ? 'dark' : 'light'
}
</script>

<style scoped>
.nav-logo {
  height: 40px;
  width: auto;
  object-fit: contain;
  cursor: pointer;
}

.v-app-bar {
  min-height: 64px;
  max-height: 64px;
}
</style>