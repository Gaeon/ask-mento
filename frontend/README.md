# Vue 3 + Vite

This template should help get you started developing with Vue 3 in Vite. The template uses Vue 3 `<script setup>` SFCs, check out the [script setup docs](https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup) to learn more.

Learn more about IDE Support for Vue in the [Vue Docs Scaling up Guide](https://vuejs.org/guide/scaling-up/tooling.html#ide-support).

```
frontend
├─ Dockerfile
├─ README.md
├─ default.conf
├─ env.properties
├─ index.html
├─ k8s
│  ├─ cm-auto-ingress-tls.yaml
│  ├─ deploy.t
│  ├─ deploy.yaml
│  ├─ service.t
│  └─ service.yaml
├─ package-lock.json
├─ package.json
├─ public
│  ├─ index.html
│  └─ vite.svg
├─ src
│  ├─ App.vue
│  ├─ assets
│  │  ├─ logo-main.png
│  │  ├─ logo.png
│  │  ├─ vue.svg
│  │  └─ 학사모.png
│  ├─ components
│  │  ├─ HelloWorld.vue
│  │  ├─ history
│  │  │  ├─ AnswersList.vue
│  │  │  └─ QuestionsList.vue
│  │  └─ questions
│  │     └─ SimilarQuestions.vue
│  ├─ layouts
│  │  └─ MainLayout.vue
│  ├─ main.js
│  ├─ pages
│  │  ├─ HistoryPage.vue
│  │  ├─ HomePage.vue
│  │  ├─ LoginPage.vue
│  │  ├─ MyPage.vue
│  │  ├─ PostQuestionPage.vue
│  │  ├─ QuestionsPage.vue
│  │  ├─ SelectMentorPage.vue
│  │  ├─ SimilarQuestionsPage.vue
│  │  ├─ SubmissionConfirmationPage.vue
│  │  └─ SubmitQuestionPage.vue
│  ├─ plugins
│  │  └─ axios.js
│  ├─ router
│  │  └─ index.js
│  ├─ services
│  │  └─ app.js
│  ├─ stores
│  │  └─ auth.js
│  └─ style.css
└─ vite.config.js

```