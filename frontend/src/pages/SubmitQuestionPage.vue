<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-card class="mb-6">
          <v-card-title class="text-h5">나의 질문</v-card-title>
          <v-card-text>
            <v-textarea
              v-model="editedQuestion"
              label="필요하면 질문 내용을 추가하세요."
              variant="outlined"
              rows="3"
              auto-grow
              autofocus
            ></v-textarea>
          </v-card-text>
        </v-card>

        <v-card class="mb-6">
          <v-card-title class="text-h5">선택한 멘토</v-card-title>
          <v-card-text class="d-flex align-center">
            <v-icon class="mr-3">mdi-account</v-icon>
            <div>
              <div>{{ selectedMentor.team }}</div>
              <div class="text-caption">{{ selectedMentor.experience }}년차</div>
            </div>
          </v-card-text>
        </v-card>

        <v-card-actions class="justify-space-between">
          <v-btn
            color="grey"
            @click="goBack"
          >
            뒤로
          </v-btn>
          <v-btn
            style="background-color: #004426 !important;"
            color="white"
            dark
            @click="submitQuestion"
          >
            등록
          </v-btn>
        </v-card-actions>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'  // Add this line

const route = useRoute()
const router = useRouter()
const editedQuestion = ref('')  // Changed from question to editedQuestion
const selectedMentor = ref({})

onMounted(() => {
  editedQuestion.value = decodeURIComponent(route.query.question || '')
  selectedMentor.value = route.query.mentor 
    ? JSON.parse(decodeURIComponent(route.query.mentor))
    : {}
})

const goBack = () => {
  router.push({
    path: '/select-mentor',
    query: { question: editedQuestion.value }
  })
}

const submitQuestion = async () => {
  try {
    // Temporarily commented out API call
    /*
    const response = await axios.post('/api/questions', {
      question: editedQuestion.value,
      mentorId: selectedMentor.value.id,
      mentorName: selectedMentor.value.team
    });
    */
    
    // Navigate directly to my-page
    window.location.href = '/submission-confirmation';
  } catch (error) {
    console.error('Navigation error:', error);
    alert('페이지 이동에 문제가 발생했습니다.');
  }
}
</script>