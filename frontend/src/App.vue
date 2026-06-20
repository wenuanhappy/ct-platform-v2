<template>
  <router-view />
</template>

<script setup>
import { onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

onMounted(() => {
  // 初始化用户信息（如果已登录）
  if (authStore.isAuthenticated && !authStore.user) {
    authStore.fetchUser().catch(() => {
      authStore.clearAuth()
    })
  }
})
</script>

<style>
/* Element Plus 全局样式覆盖 */
.el-button--primary {
  --el-button-bg-color: var(--primary);
  --el-button-border-color: var(--primary);
  --el-button-hover-bg-color: var(--primary-dark);
  --el-button-hover-border-color: var(--primary-dark);
}

.el-input__wrapper {
  border-radius: 10px;
}

.el-form-item__label {
  font-weight: 600;
  color: var(--text-secondary);
}
</style>
