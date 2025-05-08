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
                </v-list>
              </v-col>
            </v-row>

            <v-divider class="my-4"></v-divider>

            <v-row>
              <v-col cols="12" sm="4">
                <v-card variant="outlined" class="text-center pa-4">
                  <div class="text-h4 mb-1">{{ userInfo.questionCount }}</div>
                  <div class="text-subtitle-1">작성한 질문</div>
                </v-card>
              </v-col>
              
              <v-col cols="12" sm="4">
                <v-card variant="outlined" class="text-center pa-4">
                  <div class="text-h4 mb-1">{{ userInfo.answerCount }}</div>
                  <div class="text-subtitle-1">작성한 답변</div>
                </v-card>
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
  name: '홍길동',
  employeeId: 'EMP123456',
  questionCount: 15,
  answerCount: 23,
  averageRating: 4.8
})

const fetchUserData = async () => {
  try {
    // For development, use mock data if API is not available
    // When API is ready, uncomment the following:
    /*
    const userId = localStorage.getItem('userId') || 'default'
    const response = await axios.get(`/api/users/${userId}`)
    userInfo.value = response.data
    */
    console.log('User data loaded (mock)')
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
    // Mock API call for now
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    // When API is ready, uncomment the following:
    /*
    const response = await axios.post('/api/users/change-password', {
      currentPassword: passwordForm.value.current,
      newPassword: passwordForm.value.new
    })
    */
    
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