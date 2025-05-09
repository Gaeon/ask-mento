<template>
  <v-card class="mt-4">
    <v-list>
      <div v-for="question in questions" :key="question.id">
        <v-list-item
          :class="{ 'expandable': true }"
          @click="handleQuestionClick(question)"
        >
          <v-list-item-title>{{ question.question }}</v-list-item-title>
          <v-list-item-subtitle>
            {{ new Date(question.timestamp).toLocaleString() }}
          </v-list-item-subtitle>
          <template v-slot:append>
            <v-chip
              :color="getStatusColor(question.status)"
              size="small"
            >
              {{ getStatusText(question.status) }}
            </v-chip>
          </template>
        </v-list-item>

        <v-expand-transition>
          <v-card
            v-if="question.expanded"
            flat
            class="pa-4 mt-2"
          >
            <v-card-title>질문</v-card-title>
            <v-card-text>{{ question.question }}</v-card-text>
            
            <v-card-title>답변</v-card-title>
            <v-card-text>{{ question.answer }}</v-card-text>
            
            <template v-if="question.answers && question.answers.length > 1">
              <v-card-title>추가 답변</v-card-title>
              <v-card-text>
                <div v-for="(answer, index) in question.answers.slice(1)" :key="index">
                  <v-divider class="my-2"></v-divider>
                  {{ answer.answer }}
                </div>
              </v-card-text>
            </template>

            <v-card-actions v-if="(question.status === 1 || question.status === 2) && (question.answer || (question.answers && question.answers.length > 0))">
              <v-rating
                v-model="question.rating"
                color="primary"
                hover
                length="5"
                :readonly="question.status === 2"
                :model-value="question.status === 2 ? question.answers[0]?.satisfaction : question.rating"
              ></v-rating>
              <v-spacer></v-spacer>
              <v-btn
                v-if="question.status === 1"
                color="primary"
                @click="submitReview(question)"
              >
                리뷰 제출
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-expand-transition>
      </div>
    </v-list>
  </v-card>
</template>

<script setup>
import { ref, onMounted } from 'vue'
const emit = defineEmits(['update-question-count'])

const questions = ref([])
const selectedQuestion = ref(null)
const loading = ref(false)

const fetchQuestionDetail = async (questionId) => {
  try {
    const response = await fetch(`http://localhost:8080/api/questions/detail/${questionId}`)
    return await response.json()
  } catch (error) {
    console.error('Error fetching question detail:', error)
    return null
  }
}

const fetchQuestions = async () => {
  try {
    const userData = localStorage.getItem('user')
    if (!userData) {
      console.error('User data not found in localStorage')
      return
    }
    
    let userId
    try {
      userId = JSON.parse(userData).user_id
    } catch (error) {
      console.error('Error parsing user data:', error)
      return
    }
    
    if (!userId) {
      console.error('User ID not found in user data')
      return
    }

    
 
    // API 호출 시 loading 상태 추가
    loading.value = true
    
    const response = await fetch(`http://localhost:8080/api/questions/${userId}`)
    if (!response.ok) {
      throw new Error(`API 요청 실패: ${response.status}`)
    }
    
    const data = await response.json()
    questions.value = data.map(q => ({
      id: q.questionId,
      questionId: q.questionId,
      question: q.question,
      timestamp: q.timestamp,
      status: q.status,
      expanded: false,
      answer: '',
      answers: [],
      rating: q.rating || 0
    }))
    
    emit('update-question-count', questions.value.length)
  } catch (error) {
    console.error('Error fetching questions:', error)
    alert('질문 목록을 불러오는 중 오류가 발생했습니다.')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchQuestions()
})

const getStatusColor = (status) => {
  switch (status) {
    case 0: return 'orange'
    case 1: return 'green'
    case 2: return 'blue'
    default: return 'grey'
  }
}

const getStatusText = (status) => {
  switch(status) {
    case 0: return '대기중'
    case 1: return '답변 완료'
    case 2: return '해결됨'
    default: return '알 수 없음'
  }
}

const submitReview = async (question) => {
  try {
    const answerId = question.answers?.[0]?.answerId
    if (!answerId) {
      throw new Error('답변 ID를 찾을 수 없습니다.')
    }
    const response = await fetch(`http://localhost:8080/api/answers/${answerId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        satisfaction: question.rating
      })
    })
    
    if (!response.ok) {
      throw new Error('리뷰 제출에 실패했습니다.')
    }
    
    alert('리뷰가 성공적으로 제출되었습니다!')
  } catch (error) {
    console.error('Error submitting review:', error)
    alert('리뷰 제출 중 오류가 발생했습니다: ' + error.message)
  }
}

const handleQuestionClick = async (question) => {
  question.expanded = !question.expanded
  if (question.expanded && !question.answer) {
    const detail = await fetchQuestionDetail(question.questionId || question.id)
    if (detail) {
      question.answer = detail.answers[0]?.answer || ''
      question.answers = detail.answers
      selectedQuestion.value = detail
    }
  }
}

const formatDate = (dateString) => {
  if (!dateString) return ''
  return new Date(dateString).toLocaleString()
}

onMounted(() => {
  fetchQuestions()
})
</script>

<style scoped>
.expandable {
  cursor: pointer;
}
</style>