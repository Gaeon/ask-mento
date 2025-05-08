<template>
  <v-card class="mt-4">
    <v-list>
      <div v-for="question in questions" :key="question.id">
        <v-list-item
          :class="{ 'expandable': question.status === 'review_pending' }"
          @click="question.status === 'review_pending' && (question.expanded = !question.expanded)"
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
            v-if="question.expanded && question.status === 'review_pending'"
            flat
            class="pa-4 mt-2"
          >
            <v-card-title>질문</v-card-title>
            <v-card-text>{{ question.content }}</v-card-text>
            
            <v-card-title>답변</v-card-title>
            <v-card-text>{{ question.answer }}</v-card-text>

            <v-card-actions>
              <v-rating
                v-model="question.rating"
                color="primary"
                hover
                length="5"
              ></v-rating>
              <v-spacer></v-spacer>
              <v-btn
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
import { ref } from 'vue'

const questions = ref([
  // Sample data - will be replaced with DB data
  {
    id: 1,
    title: '샘플 질문 1',
    content: '질문 내용...',
    answer: '답변 내용...',
    timestamp: new Date(),
    status: 'review_pending',
    expanded: false,
    rating: 0
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

const submitReview = (question) => {
  // TODO: Submit review to DB
  console.log('Submitting review:', question.id, question.rating)
}
</script>

<style scoped>
.expandable {
  cursor: pointer;
}
</style>