<template>
  <v-container>
    <v-row class="mb-6">
      <v-col cols="6">
        <v-card 
          class="pa-4 cursor-pointer"
          :class="{ 'bg-primary text-white': activeTab === 'questions' }"
          @click="activeTab = 'questions'"
        >
          <div class="text-h6">질문 {{ questionCount }}개</div>
        </v-card>
      </v-col>
      <v-col cols="6">
        <v-card 
          class="pa-4 cursor-pointer"
          :class="{ 'bg-primary text-white': activeTab === 'answers' }"
          @click="activeTab = 'answers'"
        >
          <div class="text-h6">답변 {{ answerCount }}개</div>
        </v-card>
      </v-col>
    </v-row>

    <v-window v-model="activeTab">
      <QuestionsList
        v-show="activeTab === 'questions'"
        @update-question-count="handleQuestionCountUpdate"
      />
      <AnswersList
        v-show="activeTab === 'answers'"
        @update-answer-count="handleAnswerCountUpdate"
      />
    </v-window>
  </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import QuestionsList from '../components/history/QuestionsList.vue'
import AnswersList from '../components/history/AnswersList.vue'

const route = useRoute()
console.log('route.query.tab:', route.query.tab)
const activeTab = ref(route.query.tab === 'answers' ? 'answers' : 'questions')  // 라우터 쿼리 파라미터 기반 탭 전환
console.log('activeTab:', activeTab.value)
const questionCount = ref(0)
const answerCount = ref(0)

// QuestionsList에서 emit된 질문 개수 업데이트
const handleQuestionCountUpdate = (count) => {
  questionCount.value = count
}

// AnswersList에서 emit된 질문 개수 업데이트
const handleAnswerCountUpdate = (count) => {
  answerCount.value = count
}
</script>

<style scoped>
.cursor-pointer {
  cursor: pointer;
  transition: all 0.3s ease;
}
.cursor-pointer:hover {
  opacity: 0.9;
}
</style>