<template>
  <v-card class="mt-4">
    <v-list>
      <div v-for="question in pendingQuestions" :key="question.id">
        <v-list-item
          :class="{ 'expandable': true }"
          @click="question.expanded = !question.expanded"
        >
          <v-list-item-title>{{ question.title }}</v-list-item-title>
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
            <v-card-text>{{ question.content }}</v-card-text>
            
            <template v-if="question.status === 'pending'">
              <v-card-title>답변 작성</v-card-title>
              <v-card-text>
                <v-textarea
                  v-model="question.draftAnswer"
                  label="답변을 작성해주세요"
                  rows="4"
                ></v-textarea>
                <v-btn
                  color="primary"
                  @click="submitAnswer(question)"
                  class="mt-2"
                >
                  답변 제출
                </v-btn>
              </v-card-text>
            </template>

            <template v-else>
              <v-card-title>답변</v-card-title>
              <v-card-text>{{ question.answer }}</v-card-text>
            </template>
          </v-card>
        </v-expand-transition>
      </div>
    </v-list>
  </v-card>
</template>

<script setup>
import { ref } from 'vue'

const pendingQuestions = ref([
  // Sample data - will be removed later
  {
    id: 1,
    title: '자바스크립트에서 비동기 처리는 어떻게 하나요?',
    content: '자바스크립트에서 비동기 처리를 구현하고 싶은데, Promise와 async/await의 차이점이 궁금합니다.',
    timestamp: new Date(),
    status: 'pending',
    expanded: false,
    draftAnswer: ''
  },
  {
    id: 2,
    title: 'Vue.js와 React의 주요 차이점은?',
    content: 'Vue.js와 React를 비교했을 때 가장 큰 차이점과 각각의 장단점이 궁금합니다.',
    timestamp: new Date(Date.now() - 24 * 60 * 60 * 1000),
    status: 'completed',
    expanded: false,
    answer: '두 프레임워크의 주요 차이점은...'
  }
])

const getStatusColor = (status) => {
  switch (status) {
    case 'pending': return 'warning'
    case 'review_pending': return 'info'
    case 'completed': return 'success'
    default: return 'grey'
  }
}

const getStatusText = (status) => {
  switch (status) {
    case 'pending': return '답변대기'
    case 'review_pending': return '리뷰대기'
    case 'completed': return '완료'
    default: return '알 수 없음'
  }
}

const submitAnswer = (question) => {
  // TODO: Submit answer to DB
  console.log('Submitting answer:', question.id, question.draftAnswer)
}
</script>

<style scoped>
.expandable {
  cursor: pointer;
}
</style>