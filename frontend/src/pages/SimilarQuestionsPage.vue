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
                    유사도: {{ item.similarity }}%
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
              @click="navigateToPostQuestion"
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

const route = useRoute()
const router = useRouter()
const currentQuestion = ref('')
const similarQuestions = ref([
  {
    question: '오전 반차는 언제까지 말씀드려야 하나요?',
    answer: '통상 당일 9시 30분쯤 전까지는 담당자께 연락드려야 합니다.',
    similarity: 85
  }
])

onMounted(() => {
  currentQuestion.value = route.query.question || ''
  if (!currentQuestion.value) {
    // Handle case when no question is provided
  }
})

const navigateToPostQuestion = () => {
  router.push({
    path: '/select-mentor',
    query: { 
      question: currentQuestion.value 
    }
  })
}
</script>