<template>
  <div class="login-page">
    <div class="login-bg-decor"></div>
    <div class="login-bg-pattern"></div>

    <div class="login-container">
      <div class="login-header">
        <div class="login-logo">
          <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 2L2 7l10 5 10-5-10-5z"/>
            <path d="M2 17l10 5 10-5"/>
            <path d="M2 12l10 5 10-5"/>
          </svg>
        </div>
        <div class="login-title">计算思维交互式仿真学习平台</div>
        <div class="login-subtitle">Computational Thinking Interactive Simulation Platform</div>
      </div>

      <el-form
        ref="formRef"
        :model="loginForm"
        :rules="rules"
        class="login-form"
        @submit.prevent="handleLogin"
      >
        <el-form-item prop="username">
          <label class="form-label">用户名 / 邮箱</label>
          <el-input
            v-model="loginForm.username"
            placeholder="请输入用户名或邮箱"
            size="large"
            :prefix-icon="User"
            autocomplete="username"
          />
        </el-form-item>

        <el-form-item prop="password">
          <label class="form-label">密码</label>
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            size="large"
            :prefix-icon="Lock"
            show-password
            autocomplete="current-password"
          />
        </el-form-item>

        <div class="form-row">
          <label class="remember-me">
            <el-checkbox v-model="rememberMe">记住登录状态</el-checkbox>
          </label>
          <span class="forgot-link" @click="showForgotDialog">忘记密码？</span>
        </div>

        <el-form-item>
          <button
            class="btn-login"
            type="submit"
            :disabled="loading"
          >
            <span v-if="!loading">登 录</span>
            <span v-else>登录中...</span>
          </button>
        </el-form-item>
      </el-form>

      <div class="login-divider">
        <span>或者</span>
      </div>

      <div class="login-footer">
        还没有账号？ <router-link to="/register">注册账号</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const formRef = ref(null)
const loading = ref(false)
const rememberMe = ref(false)

const loginForm = reactive({
  username: '',
  password: ''
})

const rules = {
  username: [
    { required: true, message: '请输入用户名或邮箱', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  if (!formRef.value) return

  try {
    await formRef.value.validate()
    loading.value = true

    await authStore.login(loginForm)

    ElMessage.success('登录成功，欢迎回来！')

    const redirect = route.query.redirect || '/dashboard'
    router.push(redirect)
  } catch (error) {
    if (error !== false) {
      console.error('Login error:', error)
    }
  } finally {
    loading.value = false
  }
}

const showForgotDialog = () => {
  ElMessage.info('请联系管理员重置密码')
}
</script>

<style scoped>
.login-page {
  position: fixed;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #e8f0fe 0%, #d2e3fc 25%, #c4d7f2 50%, #dbeafe 75%, #eff6ff 100%);
  background-size: 400% 400%;
  animation: bgShift 20s ease infinite;
  z-index: 100;
}

@keyframes bgShift {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

.login-bg-decor {
  position: absolute;
  inset: 0;
  overflow: hidden;
  pointer-events: none;
}

.login-bg-decor::before {
  content: '';
  position: absolute;
  width: 600px;
  height: 600px;
  background: radial-gradient(circle, rgba(26,115,232,.08) 0%, transparent 70%);
  top: -200px;
  right: -100px;
  border-radius: 50%;
}

.login-bg-decor::after {
  content: '';
  position: absolute;
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, rgba(66,133,244,.06) 0%, transparent 70%);
  bottom: -150px;
  left: -100px;
  border-radius: 50%;
}

.login-bg-pattern {
  position: absolute;
  inset: 0;
  background-image:
    radial-gradient(circle at 20% 30%, rgba(26,115,232,.03) 1px, transparent 1px),
    radial-gradient(circle at 80% 70%, rgba(66,133,244,.04) 1px, transparent 1px);
  background-size: 60px 60px, 40px 40px;
}

.login-container {
  position: relative;
  z-index: 1;
  width: 440px;
  background: rgba(255,255,255,.85);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-radius: var(--radius-xl);
  padding: 48px 40px;
  box-shadow: 0 25px 50px rgba(26,115,232,.12), 0 0 0 1px rgba(255,255,255,.8) inset;
}

.login-header {
  text-align: center;
  margin-bottom: 36px;
}

.login-logo {
  width: 64px;
  height: 64px;
  margin: 0 auto 16px;
  background: var(--primary-gradient);
  border-radius: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8px 20px rgba(26,115,232,.25);
}

.login-logo svg {
  width: 36px;
  height: 36px;
}

.login-title {
  font-size: 22px;
  font-weight: 700;
  color: var(--text);
  letter-spacing: -.3px;
}

.login-subtitle {
  font-size: 13px;
  color: var(--text-secondary);
  margin-top: 6px;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

:deep(.el-form-item) {
  margin-bottom: 16px;
}

.form-label {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: var(--text-secondary);
  margin-bottom: 6px;
}

:deep(.el-input__wrapper) {
  height: 46px;
  padding: 0 16px;
  border: 1.5px solid var(--border);
  border-radius: 10px;
  box-shadow: none;
  background: #fafbfc;
  transition: var(--transition);
}

:deep(.el-input__wrapper:hover),
:deep(.el-input__wrapper.is-focus) {
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(26,115,232,.12);
  background: #fff;
}

:deep(.el-input__inner) {
  font-size: 14px;
}

.form-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.remember-me {
  display: flex;
  align-items: center;
  font-size: 13px;
  color: var(--text-secondary);
}

.forgot-link {
  font-size: 13px;
  color: var(--primary);
  cursor: pointer;
  transition: var(--transition);
}

.forgot-link:hover {
  text-decoration: underline;
}

.btn-login {
  width: 100%;
  height: 48px;
  background: var(--primary-gradient);
  color: #fff;
  border: none;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all var(--transition);
  box-shadow: 0 4px 12px rgba(26,115,232,.3);
}

.btn-login:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 6px 20px rgba(26,115,232,.35);
}

.btn-login:active:not(:disabled) {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(26,115,232,.25);
}

.btn-login:disabled {
  opacity: 0.8;
  cursor: not-allowed;
}

.login-divider {
  display: flex;
  align-items: center;
  gap: 16px;
  color: var(--text-muted);
  font-size: 12px;
  margin: 8px 0;
}

.login-divider::before,
.login-divider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: var(--border);
}

.login-footer {
  text-align: center;
  font-size: 13px;
  color: var(--text-secondary);
}

.login-footer a {
  color: var(--primary);
  font-weight: 600;
}
</style>
