import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'

const baseURL = import.meta.env.VITE_API_BASE_URL || ''

const service = axios.create({
  baseURL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器：自动附加JWT
service.interceptors.request.use(
  config => {
    const token = localStorage.getItem('accessToken')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器：统一处理错误
service.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code !== 200) {
      ElMessage.error(res.message || '请求失败')
      return Promise.reject(new Error(res.message || '请求失败'))
    }
    return res
  },
  async error => {
    if (error.response) {
      const { status, data } = error.response

      if (status === 401) {
        // Token过期，尝试刷新
        const refreshToken = localStorage.getItem('refreshToken')
        if (refreshToken && !error.config._retry) {
          error.config._retry = true
          try {
            const res = await axios.post(`${baseURL}/api/auth/refresh`, {
              refreshToken
            })
            if (res.data.code === 200 && res.data.data?.accessToken) {
              localStorage.setItem('accessToken', res.data.data.accessToken)
              error.config.headers.Authorization = `Bearer ${res.data.data.accessToken}`
              return service(error.config)
            }
          } catch (refreshError) {
            console.error('Token刷新失败', refreshError)
          }
        }

        // 刷新失败，清除登录状态
        localStorage.removeItem('accessToken')
        localStorage.removeItem('refreshToken')
        localStorage.removeItem('user')

        ElMessage.error('登录已过期，请重新登录')
        router.push('/login')
      } else if (status === 403) {
        ElMessage.error('没有权限访问')
      } else if (status === 404) {
        ElMessage.error('资源不存在')
      } else {
        ElMessage.error(data.message || '服务器错误')
      }
    } else if (error.request) {
      ElMessage.error('网络连接失败，请检查网络')
    } else {
      ElMessage.error('请求配置错误')
    }
    return Promise.reject(error)
  }
)

export default service
