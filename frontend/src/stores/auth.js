import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    isAuthenticated: false
  }),
  
  actions: {
    login(credentials) {
      // TODO: Implement actual login API call
      this.user = { username: credentials.username }
      this.isAuthenticated = true
      localStorage.setItem('user', JSON.stringify(this.user))
    },
    
    logout() {
      this.user = null
      this.isAuthenticated = false
      localStorage.removeItem('user')
    }
  }
})