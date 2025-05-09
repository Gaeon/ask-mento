<template>
  <v-card class="mt-4">
    <v-list>
      <div v-for="answer in answers" :key="answer.answerId">
        <v-list-item
          :class="{ 'expandable': true }"
          @click="handleAnswerClick(answer)"
        >
          <v-list-item-title>Q. {{ answer.question }}</v-list-item-title>
          <v-list-item-title>A. {{ answer.answer  }}</v-list-item-title>
          
          <v-list-item-subtitle>
            {{ answer.timestamp ? new Date(answer.timestamp).toLocaleString() : '' }}
          </v-list-item-subtitle>
          <template v-slot:append>
            <v-chip
              :color="getStatusColor(answer.status)"
              size="small"
            >
              {{ getStatusText(answer.status) }}
            </v-chip>
          </template>
        </v-list-item>

        <v-expand-transition>
          <v-card
            v-if="answer.expanded"
            flat
            class="pa-4 mt-2"
          >
            <v-card-title>질문</v-card-title>
            <v-card-text>{{ answer.question }}</v-card-text>
          
            
            <template v-if="answer.status === 0">
              <v-card-title>답변 작성</v-card-title>
              <v-card-text>
                <v-textarea
                  v-model="answer.draftAnswer"
                  label="답변을 작성해주세요"
                  rows="4"
                ></v-textarea>
                <v-btn
                  color="primary"
                  @click="submitAnswer(answer)"
                  class="mt-2"
                >
                  답변 제출
                </v-btn>
              </v-card-text>
            </template>

            <template v-else>
              <v-card-title>답변</v-card-title>
              <v-card-text>{{ answer.answer }}</v-card-text>
            </template>
          </v-card>
        </v-expand-transition>
      </div>
    </v-list>
  </v-card>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
const emit = defineEmits(['update-answer-count'])

const questions = ref([])
const answers = ref([])
const selectedAnswer = ref(null)
const loading = ref(false)

// const pendingQuestions = ref([
//   // Sample data - will be removed later
//   {
//     id: 1,
//     title: '자바스크립트에서 비동기 처리는 어떻게 하나요?',
//     content: '자바스크립트에서 비동기 처리를 구현하고 싶은데, Promise와 async/await의 차이점이 궁금합니다.',
//     timestamp: new Date(),
//     status: 'pending',
//     expanded: false,
//     draftAnswer: ''
//   },
//   {
//     id: 2,
//     title: 'Vue.js와 React의 주요 차이점은?',
//     content: 'Vue.js와 React를 비교했을 때 가장 큰 차이점과 각각의 장단점이 궁금합니다.',
//     timestamp: new Date(Date.now() - 24 * 60 * 60 * 1000),
//     status: 'completed',
//     expanded: false,
//     answer: '두 프레임워크의 주요 차이점은...'
//   }
// ])

// 1. OnMounted - Mounted 시
onMounted(() => {
  fetchAnswers()
})

// 2. Answers 보여주기
const fetchAnswers = async () => {
  try {
    // 2-1. 에러처리
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

    // 2-2. API 호출 시 loading 상태 추가
    loading.value = true
    
    const response = await fetch(`/api/answers/${userId}`)
    if (!response.ok) {
      throw new Error(`API 요청 실패: ${response.status}`)
    }
    
    const data = await response.json()
    answers.value = data.map(a => ({
      id: a.questionId,
      answerId: a.answerId,
      answer: a.answer,
      timestamp: a.timestamp,
      status: a.state,
      expanded: false,
      question: a.question,
      draftAnswer: '',
      rating: a.rating || 0
    }))
    
    emit('update-answer-count', answers.value.length)
  } catch (error) {
    console.error('Error fetching answers:', error)
    alert('질문 목록을 불러오는 중 오류가 발생했습니다.')
  } finally {
    loading.value = false
  }
}

// 3. 질문이 눌리면
const handleAnswerClick = async (question) => {
  question.expanded = !question.expanded
  if (question.expanded && !question.answer) {
    const detail = await fetchAnswerDetail(question.questionId || question.id)
    if (detail) {
      question.answer = detail.answers[0]?.answer || ''
      question.answers = detail.answers
      selectedQuestion.value = detail
    }
  }
}

// 4. 세부 내용 보여주기
const fetchQuestionDetail = async (questionId) => {
  try {
    const response = await fetch(`/api/questions/detail/${questionId}`)
    return await response.json()
  } catch (error) {
    console.error('Error fetching question detail:', error)
    return null
  }
}

// 5. 답변 상태표시
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

// 6. 답변입력 안된거는
const submitAnswer = async (question) => {
  try {
    const response = await axios.patch(`/api/answers/${question.answerId}`, {
      answer: question.draftAnswer,
      satisfaction: null, // 초기에는 null 또는 생략도 가능
    });
    console.log('✅ 답변 저장 완료:', response.data);
    alert('답변이 성공적으로 저장되었습니다!');
    fetchAnswers();
  } catch (error) {
    console.error('❌ 답변 저장 실패:', error);
    alert('답변 저장 중 오류가 발생했습니다.');
  }
};

</script>

<style scoped>
.expandable {
  cursor: pointer;
}
</style>