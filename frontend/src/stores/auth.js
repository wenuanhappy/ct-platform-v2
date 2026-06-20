import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login as apiLogin, register as apiRegister, logout as apiLogout, getCurrentUser } from '@/api/auth'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('accessToken') || '')
  const refreshTokenValue = ref(localStorage.getItem('refreshToken') || '')
  const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))

  const isAuthenticated = computed(() => !!token.value && !!user.value)

  async function login(loginForm) {
    try {
      const res = await apiLogin(loginForm)
      token.value = res.data.accessToken
      refreshTokenValue.value = res.data.refreshToken
      user.value = res.data.user

      localStorage.setItem('accessToken', res.data.accessToken)
      localStorage.setItem('refreshToken', res.data.refreshToken)
      localStorage.setItem('user', JSON.stringify(res.data.user))

      return res
    } catch (error) {
      throw error
    }
  }

  async function register(registerForm) {
    try {
      const res = await apiRegister(registerForm)
      return res
    } catch (error) {
      throw error
    }
  }

  async function logout() {
    try {
      await apiLogout()
    } catch (e) {
      console.error('Logout API error:', e)
    } finally {
      clearAuth()
    }
  }

  async function fetchUser() {
    try {
      const res = await getCurrentUser()
      user.value = res.data
      localStorage.setItem('user', JSON.stringify(res.data))
      return res
    } catch (error) {
      throw error
    }
  }

  function clearAuth() {
    token.value = ''
    refreshTokenValue.value = ''
    user.value = null
    localStorage.removeItem('accessToken')
    localStorage.removeItem('refreshToken')
    localStorage.removeItem('user')
  }

  return {
    token,
    refreshToken: refreshTokenValue,
    user,
    isAuthenticated,
    login,
    register,
    logout,
    fetchUser,
    clearAuth
  }
})
