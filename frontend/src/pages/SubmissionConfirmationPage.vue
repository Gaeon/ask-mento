<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" md="8">
        <v-card class="text-center pa-6">
          <v-icon color="green" size="64">mdi-check-circle</v-icon>
          <v-card-title class="text-h4 justify-center">전송되었습니다</v-card-title>
          <v-card-text class="text-h6">
            질문이 성공적으로 전송되었습니다.
          </v-card-text>
          
          <v-card-actions class="justify-center mt-4">
            <v-btn
              color="primary"
              @click="goToQuestions"
              class="mr-2"
            >
              홈으로
            </v-btn>
            <v-btn
              color="#004426"
              dark
              @click="goToMyPage"
            >
              내 질문 보기
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const goToQuestions = () => {
  router.push({ name: 'QuestionsPage' })
}

const goToMyPage = () => {
  router.push({ name: 'HistoryPage' })
}
</script>