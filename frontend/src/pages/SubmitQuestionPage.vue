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
import axios from 'axios'

const route = useRoute()
const router = useRouter()
const editedQuestion = ref('')
const selectedMentor = ref({})

onMounted(() => {
  editedQuestion.value = route.query.question || ''
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
    const userId = JSON.parse(localStorage.getItem('user'))?.user_id;
    if (!userId) {
      alert('로그인이 필요합니다.');
      router.push('/login');
      return;
    }

    // 실제 질문 저장 API 호출
    await axios.post(`/api/questions/${userId}`, {
      user_id: userId,
      question: editedQuestion.value,
      status: 0,
      answerUserId: selectedMentor.value.id,
      mentorName: selectedMentor.value.team
    });

    // 제출 후 로컬 스토리지 정리
    localStorage.removeItem('currentQuestion');
    localStorage.removeItem('recommendedMentors');

    // 성공 시 페이지 이동
    router.push('/submission-confirmation');
  } catch (error) {
    console.error('질문 전송 중 오류:', error);
    alert('질문 전송에 실패했습니다. 다시 시도해 주세요.');
  }
};
</script>