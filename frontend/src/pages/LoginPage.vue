<template>
  <v-container class="fill-height login-container">
    <v-row align="center" justify="center">
      <v-col cols="12" sm="8" md="6" lg="4">
        <v-card class="elevation-12 login-card">
          <div class="text-center pt-6">
            <img src="../assets/logo.png" alt="물어멘토 Logo" class="login-logo" />
            <h1 class="text-h4 text-primary mt-4">물어멘토</h1>
          </div>
          <v-card-text class="pt-6">
            <v-form @submit.prevent="handleLogin">
              <v-text-field
                v-model="credentials.username"
                label="Username"
                prepend-inner-icon="mdi-account"
                variant="outlined"
                color="primary"
                required
                class="mb-4"
              ></v-text-field>

              <v-text-field
                v-model="credentials.password"
                label="Password"
                prepend-inner-icon="mdi-lock"
                :type="showPassword ? 'text' : 'password'"
                variant="outlined"
                color="primary"
                required
                :append-inner-icon="showPassword ? 'mdi-eye-off' : 'mdi-eye'"
                @click:append-inner="showPassword = !showPassword"
                class="mb-6"
              ></v-text-field>

              <v-btn
                type="submit"
                color="primary"
                block
                size="large"
                class="login-btn"
                elevation="2"
              >
                Login
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import axios from 'axios'

const router = useRouter()
const showPassword = ref(false)
const credentials = ref({
  username: '',
  password: ''
})

const authStore = useAuthStore()

const handleLogin = async () => {
  try {
    const response = await axios.post('http://localhost:8080/api/login', {
      user_id: credentials.value.username,
      password: credentials.value.password
    })
    
    if (response.data === "사용자를 찾을 수 없습니다.") {
      alert("사용자를 찾을 수 없습니다.")
      return
    }
    
    if (response.data === "비밀번호가 일치하지 않습니다.") {
      alert("비밀번호가 일치하지 않습니다.")
      return
    }
    
    authStore.login(credentials.value)
    router.push('/questions')
  } catch (error) {
    console.error("로그인 실패:", error)
    alert("로그인 중 오류가 발생했습니다.")
  }
}
</script>

<style scoped>
.login-container {
  background: rgb(255, 255, 234);
}

.login-card {
  border-radius: 16px;
  background: rgba(255, 255, 234, 0.95);
  border: 1px solid rgba(26, 66, 41, 0.1);
}

.login-logo {
  max-width: 200px;
  height: auto;
  margin-bottom: 1rem;
}

.login-btn {
  text-transform: none;
  font-size: 1.1rem;
  padding: 12px 0;
  border-radius: 8px;
  background: rgb(26, 66, 41) !important;
}

:deep(.v-field) {
  border-radius: 8px;
}

:deep(.v-field.v-field--focused) {
  border-color: rgb(26, 66, 41);
}
</style>