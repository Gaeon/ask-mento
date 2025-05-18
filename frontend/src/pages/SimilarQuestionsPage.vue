<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-card class="mb-6">
          <v-card-title class="text-h5">Your Question</v-card-title>
          <v-card-text class="text-body-1">
            {{ currentQuestion }}
          </v-card-text>
        </v-card>

        <v-card>
          <v-card-title class="text-h5">Similar Questions</v-card-title>
          <v-list>
            <v-list-item
              v-for="(item, index) in similarQuestions"
              :key="index"
              class="mb-4"
            >
              <v-card variant="outlined" width="100%">
                <v-card-title class="d-flex justify-space-between align-center">
                  <span>Q: {{ item.question }}</span>
                  <v-chip color="primary" size="small">
                    유사도: {{ 100 - item.similarity }}%
                  </v-chip>
                </v-card-title>
                <v-card-text>
                  <div class="text-subtitle-1 mb-2">A: {{ item.answer }}</div>
                </v-card-text>
              </v-card>
            </v-list-item>
          </v-list>
        </v-card>
        <v-card-actions class="justify-end pa-4">
            <v-btn
              color="white"
              dark
              @click="findMentor"
              class="mt-4"
              size="large"
              style="background-color: #004426 !important;"
            >
              멘토 보기
            </v-btn>
          </v-card-actions>
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
const loading = ref(false)
const similarQuestions = ref([
  {
    question: '오전 반차는 언제까지 말씀드려야 하나요?',
    answer: '통상 당일 9시 30분쯤 전까지는 담당자께 연락드려야 합니다.',
    similarity: 85
  }
])

onMounted(() => {
  currentQuestion.value = route.query.question || ''
  
  // 라우터 쿼리에서 유사 질문 데이터 파싱
  if (route.query.similarQuestions) {
    try {
      similarQuestions.value = JSON.parse(route.query.similarQuestions)
    } catch (e) {
      console.error('유사 질문 데이터 파싱 오류:', e)
    }
  }
  
  if (!currentQuestion.value) {
    // Handle case when no question is provided
  }
  
  // 페이지 로드 시 이전에 저장된 멘토 정보 초기화
  localStorage.removeItem('recommendedMentors')
})

// navigateToPostQuestion 함수는 findMentor로 대체
const findMentor = async () => {
  try {
    loading.value = true;
    
    // 에이전트 API 호출
    const response = await axios.post('http://localhost:8000/api/recommend-mentors', {
      question: currentQuestion.value
    });
    
    // 추천된 멘토 정보 저장
    localStorage.setItem('recommendedMentors', JSON.stringify(response.data.mentors));
    
    // 멘토 선택 페이지로 이동
    router.push({
      path: '/select-mentor',
      query: { question: currentQuestion.value }
    });
  } catch (error) {
    console.error('멘토 추천 중 오류 발생:', error);
    alert('멘토 추천 중 오류가 발생했습니다. 다시 시도해주세요.');
  } finally {
    loading.value = false;
  }
}
</script>