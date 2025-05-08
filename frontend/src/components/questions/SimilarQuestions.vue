<template>
  <v-dialog v-model="dialog" width="800">
    <v-card>
      <v-card-title class="text-h5 bg-primary text-white pa-4">
        유사한 질문들
        <v-spacer></v-spacer>
        <v-btn icon="mdi-close" variant="text" color="white" @click="dialog = false"></v-btn>
      </v-card-title>

      <v-card-text class="pa-4">
        <v-list>
          <v-list-item
            v-for="question in similarQuestions"
            :key="question.id"
            class="mb-4"
          >
            <v-card width="100%" variant="outlined">
              <v-card-title class="text-h6">
                {{ question.title }}
                <v-chip
                  class="ml-2"
                  color="success"
                  size="small"
                >
                  유사도: {{ question.similarity }}%
                </v-chip>
              </v-card-title>
              
              <v-card-text>
                <div class="text-subtitle-1 mb-2">질문</div>
                <div class="mb-4">{{ question.content }}</div>
                
                <v-divider class="mb-4"></v-divider>
                
                <div class="text-subtitle-1 mb-2">답변</div>
                <div>{{ question.answer }}</div>
              </v-card-text>

              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn
                  color="primary"
                  variant="text"
                  @click="useThisAnswer(question)"
                >
                  이 답변 사용하기
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-list-item>
        </v-list>

        <v-row class="mt-4" v-if="similarQuestions.length === 0">
          <v-col cols="12" class="text-center">
            <v-icon size="64" color="grey">mdi-help-circle-outline</v-icon>
            <div class="text-h6 mt-2">유사한 질문을 찾을 수 없습니다</div>
            <div class="text-subtitle-1">새로운 질문을 작성해주세요</div>
          </v-col>
        </v-row>
      </v-card-text>

      <v-card-actions class="pa-4">
        <v-spacer></v-spacer>
        <v-btn
          color="primary"
          @click="proceedWithNewQuestion"
        >
          새로운 질문하기
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { ref, defineEmits, defineProps } from 'vue'

const props = defineProps({
  questions: {
    type: Array,
    required: true,
    default: () => []
  }
})

const emit = defineEmits(['use-answer', 'new-question'])
const dialog = ref(false)

const useThisAnswer = (question) => {
  emit('use-answer', question)
  dialog.value = false
}

const proceedWithNewQuestion = () => {
  emit('new-question')
  dialog.value = false
}

const showDialog = () => {
  dialog.value = true
}

defineExpose({
  showDialog
})
</script>