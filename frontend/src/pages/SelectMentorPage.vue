<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-card class="mb-6">
          <v-card-title class="text-h5">나의 질문</v-card-title>
          <v-card-text class="text-body-1">
            {{ currentQuestion }}
          </v-card-text>
        </v-card>

        <!-- 로딩 상태 표시 -->
        <v-card v-if="loading" class="mb-6 pa-5">
          <v-card-text class="text-center">
            <v-progress-circular
              indeterminate
              color="#004426"
              size="64"
            ></v-progress-circular>
            <div class="mt-4 text-h6">멘토를 찾는 중입니다...</div>
            <div class="text-subtitle-1">잠시만 기다려주세요</div>
          </v-card-text>
        </v-card>

        <v-card v-else>
          <v-card-title class="text-h5">추천 멘토</v-card-title>
          <v-list v-if="recommendedMentors.length > 0">
            <v-list-item
              v-for="(mentor, index) in recommendedMentors"
              :key="index"
              class="mb-4"
            >
              <v-card variant="outlined" width="100%">
                <v-card-title class="d-flex align-center">
                  <v-icon class="mr-3">mdi-account</v-icon>
                  <div>
                    <div>{{ mentor.team }}</div>
                    <div class="text-caption">{{ mentor.experience }}년차</div>
                  </div>
                  <v-spacer></v-spacer>
                  <v-btn
                    color="#004426"
                    dark
                    @click="selectMentor(mentor)"
                    class="white--text"
                  >
                    멘토 선택
                  </v-btn>
                </v-card-title>
                <!-- 추천 이유 (태그) 표시 -->
                <v-card-text v-if="mentor.tags">
                  <div class="tags">{{ mentor.tags }}</div>
                </v-card-text>
              </v-card>
            </v-list-item>
          </v-list>
          <v-card-text v-else class="text-center py-5">
            추천할 멘토가 없습니다. 다른 질문을 시도해보세요.
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const router = useRouter()
const currentQuestion = ref('')
const recommendedMentors = ref([])
const loading = ref(true)

onMounted(async () => {
  // URL 쿼리에서 질문 가져오기
  currentQuestion.value = route.query.question || ''
  console.log('Received question:', currentQuestion.value)
  
  // 로컬 스토리지에서 추천된 멘토 가져오기
  const storedMentors = localStorage.getItem('recommendedMentors')
  
  if (storedMentors) {
    // 로컬 스토리지에 저장된 멘토 정보가 있으면 사용
    recommendedMentors.value = JSON.parse(storedMentors)
    loading.value = false
  } else if (currentQuestion.value) {
    // 질문이 있지만 멘토 정보가 없으면 API 호출
    try {
      loading.value = true
      const response = await axios.post('http://localhost:5000/api/recommend-mentors', {
        question: currentQuestion.value
      })
      recommendedMentors.value = response.data.mentors
      localStorage.setItem('recommendedMentors', JSON.stringify(response.data.mentors))
    } catch (error) {
      console.error('멘토 추천 중 오류 발생:', error)
      alert('멘토 추천 중 오류가 발생했습니다.')
    } finally {
      loading.value = false
    }
  } else {
    // 질문이 없으면 기본 멘토 목록 표시
    loading.value = false
  }
})

const selectMentor = (mentor) => {
  router.push({
    path: '/submit-question',
    query: { 
      question: currentQuestion.value,
      mentor: JSON.stringify(mentor)
    }
  })
}
</script>

<style scoped>
.tags {
  color: #4361ee;
  font-size: 14px;
  margin-top: 8px;
}
</style>