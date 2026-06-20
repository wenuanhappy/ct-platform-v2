<template>
  <div class="login-page">
    <div class="login-bg-decor"></div>
    <div class="login-bg-pattern"></div>

    <div class="login-container register-container">
      <div class="login-header">
        <div class="login-logo">
          <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 2L2 7l10 5 10-5-10-5z"/>
            <path d="M2 17l10 5 10-5"/>
            <path d="M2 12l10 5 10-5"/>
          </svg>
        </div>
        <div class="login-title">注册新账号</div>
        <div class="login-subtitle">创建您的学习平台账号，开始计算思维之旅</div>
      </div>

      <el-form
        ref="formRef"
        :model="registerForm"
        :rules="rules"
        class="login-form"
        @submit.prevent="handleRegister"
      >
        <el-form-item prop="username">
          <label class="form-label">用户名</label>
          <el-input
            v-model="registerForm.username"
            placeholder="请输入用户名（3-20位）"
            size="large"
            :prefix-icon="User"
          />
        </el-form-item>

        <el-form-item prop="email">
          <label class="form-label">邮箱</label>
          <el-input
            v-model="registerForm.email"
            type="email"
            placeholder="请输入邮箱地址"
            size="large"
            :prefix-icon="Message"
          />
        </el-form-item>

        <el-form-item prop="password">
          <label class="form-label">密码</label>
          <el-input
            v-model="registerForm.password"
            type="password"
            placeholder="请输入密码（至少6位）"
            size="large"
            :prefix-icon="Lock"
            show-password
          />
        </el-form-item>

        <el-form-item prop="confirmPassword">
          <label class="form-label">确认密码</label>
          <el-input
            v-model="registerForm.confirmPassword"
            type="password"
            placeholder="请再次输入密码"
            size="large"
            :prefix-icon="Lock"
            show-password
          />
        </el-form-item>

        <el-form-item>
          <button
            class="btn-login"
            type="submit"
            :disabled="loading"
          >
            <span v-if="!loading">注 册</span>
            <span v-else>注册中...</span>
          </button>
        </el-form-item>
      </el-form>

      <div class="login-footer">
        已有账号？ <router-link to="/login">立即登录</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, Message } from '@element-plus/icons-vue'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const formRef = ref(null)
const loading = ref(false)

const registerForm = reactive({
  username: '',
  email: '',
  password: '',
  confirmPassword: ''
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度为3-20位', trigger: 'blur' },
    { pattern: /^[a-zA-Z0-9_]+$/, message: '用户名只能包含字母、数字和下划线', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

const handleRegister = async () => {
  if (!formRef.value) return

  try {
    await formRef.value.validate()
    loading.value = true

    const { confirmPassword, ...registerData } = registerForm
    await authStore.register(registerData)

    ElMessage.success('注册成功！请登录')
    router.push('/login')
  } catch (error) {
    if (error !== false) {
      console.error('Register error:', error)
    }
  } finally {
    loading.value = false
  }
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
  margin-bottom: 32px;
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

.login-footer {
  text-align: center;
  font-size: 13px;
  color: var(--text-secondary);
  margin-top: 8px;
}

.login-footer a {
  color: var(--primary);
  font-weight: 600;
}
</style>
