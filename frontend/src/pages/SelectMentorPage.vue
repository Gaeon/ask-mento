<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-card class="mb-6">
          <v-card-title class="text-h5">나의 질문</v-card-title>
          <v-card-text class="text-body-1">
            {{ currentQuestion }}
          </v-card-text>
        </v-card>

        <v-card>
          <v-card-title class="text-h5">추천 멘토</v-card-title>
          <v-list>
            <v-list-item
              v-for="(mentor, index) in recommendedMentors"
              :key="index"
              class="mb-4"
            >
              <v-card variant="outlined" width="100%">
                <v-card-title class="d-flex align-center">
                  <v-icon class="mr-3">mdi-account</v-icon>
                  <div>
                    <div>{{ mentor.team }}</div>
                    <div class="text-caption">{{ mentor.experience }}년차</div>
                  </div>
                  <v-spacer></v-spacer>
                  <v-btn
                    color="#004426"
                    dark
                    @click="selectMentor(mentor)"
                    class="white--text"
                  >
                    멘토 선택
                  </v-btn>
                </v-card-title>
              </v-card>
            </v-list-item>
          </v-list>
        </v-card>
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
const recommendedMentors = ref([
  {
    id: 1,
    team: '인사팀 고양이',
    experience: 5,
    domain: 'HR'
  },
  {
    id: 2, 
    team: '개발팀 강아지',
    experience: 4,
    domain: 'Development'
  },
  {
    id: 3,
    team: '기획팀 토끼',
    experience: 6,
    domain: 'Planning'
  }
])

onMounted(() => {
  currentQuestion.value = route.query.question || ''
  console.log('Received question:', currentQuestion.value)
})

const selectMentor = (mentor) => {
  router.push({
    path: '/submit-question',
    query: { 
      question: currentQuestion.value,
      mentor: JSON.stringify(mentor)
    }
  })
}
</script>