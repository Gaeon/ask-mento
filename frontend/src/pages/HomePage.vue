<template>
  <v-row>
    <v-col cols="12" md="8">
      <v-card class="mb-4">
        <v-card-title>Recent Questions</v-card-title>
        <v-list>
          <v-list-item
            v-for="question in recentQuestions"
            :key="question.id"
            :to="`/question/${question.id}`"
          >
            <v-list-item-title>{{ question.title }}</v-list-item-title>
            <v-list-item-subtitle>
              {{ question.author }} · {{ question.date }}
            </v-list-item-subtitle>
          </v-list-item>
        </v-list>
      </v-card>
    </v-col>
    
    <v-col cols="12" md="4">
      <v-card>
        <v-card-title>Popular Tags</v-card-title>
        <v-card-text>
          <v-chip
            v-for="tag in popularTags"
            :key="tag.name"
            class="ma-1"
            :to="`/tags/${tag.name}`"
          >
            {{ tag.name }} ({{ tag.count }})
          </v-chip>
        </v-card-text>
      </v-card>
    </v-col>
  </v-row>
</template>

<script setup>
import { ref } from 'vue'

const recentQuestions = ref([
  { id: 1, title: 'How to use Vue 3?', author: 'John', date: '2023-08-20' },
  { id: 2, title: 'Vuetify best practices', author: 'Jane', date: '2023-08-19' },
])

const popularTags = ref([
  { name: 'vue', count: 120 },
  { name: 'javascript', count: 89 },
  { name: 'vuetify', count: 45 },
])
</script>