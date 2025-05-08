<template>
  <MainLayout>  <!-- Add MainLayout wrapper -->
    <v-container>
      <v-row>
        <v-col cols="12">
          <v-card>
            <v-card-title class="text-h5">Post Your Question</v-card-title>
            <v-card-text>
              <p class="text-h6 mb-4">{{ question }}</p>
              
              <v-select
                v-model="selectedMentors"
                label="Select Mentors"
                :items="mentors"
                item-title="name"
                item-value="id"
                multiple
                chips
                return-object
              ></v-select>
              
              <v-btn
                color="primary"
                @click="submitQuestion"
                class="mt-4"
                :loading="submitting"
              >
                Submit to Selected Mentors
              </v-btn>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </MainLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MainLayout from '../layouts/MainLayout.vue'  // Add layout import

const route = useRoute()
const router = useRouter()
const question = ref('')
const selectedMentors = ref([])
const submitting = ref(false)
const mentors = ref([
  { id: 1, name: 'Mentor 1' },
  { id: 2, name: 'Mentor 2' },
  { id: 3, name: 'Mentor 3' }
])

onMounted(() => {
  if (!route.query.question) {
    router.push('/questions')  // Redirect if no question
  }
  question.value = route.query.question || ''
})

const submitQuestion = async () => {
  submitting.value = true
  try {
    // TODO: Implement actual submission
    await new Promise(resolve => setTimeout(resolve, 1000))
    router.push('/question-result')  // Navigate after submission
  } finally {
    submitting.value = false
  }
}
</script>