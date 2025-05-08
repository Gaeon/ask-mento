import { createRouter, createWebHistory } from 'vue-router'
import MainLayout from '../layouts/MainLayout.vue'
import LoginPage from '../pages/LoginPage.vue'
import QuestionsPage from '../pages/QuestionsPage.vue'
import HistoryPage from '../pages/HistoryPage.vue'
import MyPage from '../pages/MyPage.vue'
import SimilarQuestions from '../pages/SimilarQuestionsPage.vue'
import SelectMentorPage from '../pages/SelectMentorPage.vue'
import SubmitQuestionPage from '../pages/SubmitQuestionPage.vue'
import SubmissionConfirmationPage from '../pages/SubmissionConfirmationPage.vue'

const routes = [
  {
    path: '/login',
    name: 'LoginPage',
    component: LoginPage
  },
  {
    path: '/',
    component: MainLayout,
    children: [
      {
        path: '',
        redirect: { name: 'QuestionsPage' }
      },
      {
        path: 'questions',
        name: 'QuestionsPage',
        component: QuestionsPage,
        meta: { requiresAuth: true }
      },
      {
        path: 'history',
        name: 'HistoryPage',
        component: HistoryPage,
        meta: { requiresAuth: true }
      },
      {
        path: 'my-page',
        name: 'MyPage',
        component: MyPage,
        meta: { requiresAuth: true }
      },
      // Added new routes for the imported components
      {
        path: 'similar-questions',
        name: 'SimilarQuestionsPage',
        component: SimilarQuestions,
        meta: { requiresAuth: true }
      },
      {
        path: 'select-mentor',
        name: 'SelectMentorPage',
        component: SelectMentorPage,
        meta: { requiresAuth: true }
      },
      {
        path: 'submit-question',
        name: 'SubmitQuestionPage',
        component: SubmitQuestionPage,
        meta: { requiresAuth: true }
      },
      {
        path: 'submission-confirmation',
        name: 'SubmissionConfirmationPage',
        component: SubmissionConfirmationPage,
        meta: { requiresAuth: true }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  strict: true
})

// Navigation guard to redirect to login if not authenticated
router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('user');
  
  // 기본 경로('/')로 접근 시 무조건 로그인 체크
  if (to.path === '/' || to.matched.some(record => record.meta.requiresAuth)) {
    if (!isAuthenticated) {
      next({ name: 'LoginPage', query: { redirect: to.fullPath } });
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router
