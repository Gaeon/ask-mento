<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" md="8">
        <v-card class="mb-6">
          <v-card-title class="text-h5 bg-primary text-white pa-4">
            내 프로필
          </v-card-title>
          
          <v-card-text class="pa-6">
            <v-row>
              <v-col cols="12">
                <v-list>
                  <v-list-item>
                    <template v-slot:prepend>
                      <v-icon color="#4CAF50">mdi-account</v-icon>
                    </template>
                    <v-list-item-title>이름</v-list-item-title>
                    <v-list-item-subtitle>{{ userInfo.name }}</v-list-item-subtitle>
                  </v-list-item>

                  <v-list-item>
                    <template v-slot:prepend>
                      <v-icon color="#4CAF50">mdi-badge-account</v-icon>
                    </template>
                    <v-list-item-title>사번</v-list-item-title>
                    <v-list-item-subtitle>{{ userInfo.employeeId }}</v-list-item-subtitle>
                  </v-list-item>

                  <v-list-item>
                    <template v-slot:prepend>
                      <v-icon color="#4CAF50">mdi-calendar</v-icon>
                    </template>
                    <v-list-item-title>입사년도</v-list-item-title>
                    <v-list-item-subtitle>{{ userInfo.joinYear }}</v-list-item-subtitle>
                  </v-list-item>
                </v-list>
              </v-col>
            </v-row>

            <v-divider class="my-4"></v-divider>

            <v-row>
              <v-col cols="12" sm="4">
                <v-btn
                  variant="outlined"
                  class="text-center pa-4"
                  width="100%"
                  height="100%"
                  style="border-radius: 12px;"
                  @click="$router.push({ name: 'HistoryPage', query: { tab: 'question' } })"
                >
                  <div class="d-flex flex-column align-center justify-center" style="width: 100%;">
                    <div class="text-h4 mb-1">{{ userInfo.questionCount }}</div>
                    <div class="text-subtitle-1">작성한 질문</div>
                  </div>
                </v-btn>
              </v-col>
              
              <v-col cols="12" sm="4">
                <v-btn
                  variant="outlined"
                  class="text-center pa-4"
                  width="100%"
                  height="100%"
                  @click="$router.push({ name: 'HistoryPage', query: { tab: 'answers' } })"
                  style="border-radius: 12px;"
                >
                  <div class="d-flex flex-column align-center justify-center" style="width: 100%;">
                    <div class="text-h4 mb-1">{{ userInfo.answerCount }}</div>
                    <div class="text-subtitle-1">작성한 답변</div>
                  </div>
                </v-btn>
              </v-col>
              
              <v-col cols="12" sm="4">
                <v-card variant="outlined" class="text-center pa-4">
                  <div class="text-h4 mb-1">{{ userInfo.averageRating }}</div>
                  <div class="text-subtitle-1">평균 만족도</div>
                </v-card>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>

        <!-- Password Change Section -->
        <v-card class="mt-auto">
          <v-card-title class="text-h5 bg-primary text-white pa-4">
            비밀번호 변경
          </v-card-title>
          
          <v-card-text class="pa-6">
            <v-form @submit.prevent="changePassword" class="password-form">
              <v-text-field
                v-model="passwordForm.current"
                label="현재 비밀번호"
                type="password"
                variant="outlined"
                required
                class="mb-4"
              ></v-text-field>

              <v-text-field
                v-model="passwordForm.new"
                label="새 비밀번호"
                type="password"
                variant="outlined"
                required
                :error-messages="passwordErrors.new"
                @update:model-value="validatePassword"
                hint="8자 이상 입력해주세요"
                class="mb-4"
              ></v-text-field>

              <v-text-field
                v-model="passwordForm.confirm"
                label="새 비밀번호 확인"
                type="password"
                variant="outlined"
                required
                :error-messages="passwordErrors.confirm"
                @update:model-value="validatePassword"
                class="mb-6"
              ></v-text-field>

              <v-btn
                color="#1A4229"
                dark
                type="submit"
                block
                :loading="loading"
                class="white--text"
              >
                비밀번호 변경
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

// Default user info with sample data
const userInfo = ref({
  name: '',
  userId: '',
  questionCount: 0,
  answerCount: 0,
  sumSatisfaction: 0,
  joinYear: ''
})

const fetchUserData = async () => {
  try {
    const userData = JSON.parse(localStorage.getItem('user'))
    const response = await axios.get(`http://localhost:8080/api/users/${userData.user_id}`)
    
    userInfo.value = {
      name: response.data.name,
      employeeId: response.data.userId.toString(),
      questionCount: response.data.questionCount || 0,
      answerCount: response.data.answerCount || 0,
      averageRating: response.data.sumSatisfaction || 0,
      joinYear: response.data.joinYear || ''
    }
  } catch (error) {
    console.error('Failed to fetch user data:', error)
  }
}

// Initial fetch
onMounted(() => {
  fetchUserData()
})

const passwordForm = ref({
  current: '',
  new: '',
  confirm: ''
})

const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const passwordErrors = ref({
  new: '',
  confirm: ''
})

const validatePassword = () => {
  passwordErrors.value.new = ''
  passwordErrors.value.confirm = ''

  if (passwordForm.value.new && passwordForm.value.new.length < 8) {
    passwordErrors.value.new = '비밀번호는 8자 이상이어야 합니다.'
  }

  if (passwordForm.value.new && passwordForm.value.confirm && 
      passwordForm.value.new !== passwordForm.value.confirm) {
    passwordErrors.value.confirm = '비밀번호가 일치하지 않습니다.'
  }
}

const changePassword = async () => {
  errorMessage.value = ''
  successMessage.value = ''

  // Validation
  if (!passwordForm.value.current || !passwordForm.value.new || !passwordForm.value.confirm) {
    errorMessage.value = '모든 필드를 입력해주세요.'
    return
  }

  if (passwordForm.value.new !== passwordForm.value.confirm) {
    errorMessage.value = '새 비밀번호가 일치하지 않습니다.'
    return
  }

  if (passwordForm.value.new.length < 8) {
    errorMessage.value = '새 비밀번호는 8자 이상이어야 합니다.'
    return
  }

  loading.value = true
  try {
    const userData = JSON.parse(localStorage.getItem('user'))
    const response = await axios.patch(`http://localhost:8080/api/users/${userData.user_id}`, {
      password: passwordForm.value.new
    })
    
    successMessage.value = '비밀번호가 성공적으로 변경되었습니다.'
    passwordForm.value = { current: '', new: '', confirm: '' }
  } catch (error) {
    if (error.response?.status === 401) {
      errorMessage.value = '현재 비밀번호가 일치하지 않습니다.'
    } else {
      errorMessage.value = '비밀번호 변경 중 오류가 발생했습니다.'
    }
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.v-container {
  position: relative;
  padding-bottom: 80px; /* Space for button */
}

.v-btn {
  position: sticky;
  bottom: 20px;
  z-index: 1000;
}

.v-card {
  border-radius: 12px;
}
</style>