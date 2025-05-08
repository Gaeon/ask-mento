// src/plugins/axios.js
import axios from 'axios'

const instance = axios.create({
  baseURL: '/api', // 프록시 설정 기준으로 동작
})

export default instance
