<template>
  <header class="header">
    <div class="header-left">
      <div class="header-logo">
        <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M12 2L2 7l10 5 10-5-10-5z"/>
          <path d="M2 17l10 5 10-5"/>
          <path d="M2 12l10 5 10-5"/>
        </svg>
      </div>
      <span class="header-title">计算思维交互式仿真学习平台</span>
    </div>
    <div class="header-right">
      <el-tooltip content="应用中心" placement="bottom">
        <button class="header-icon-btn" @click="$router.push('/dashboard')">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="3" width="7" height="7" rx="1"/>
            <rect x="14" y="3" width="7" height="7" rx="1"/>
            <rect x="3" y="14" width="7" height="7" rx="1"/>
            <rect x="14" y="14" width="7" height="7" rx="1"/>
          </svg>
        </button>
      </el-tooltip>
      <div class="user-dropdown" ref="dropdownRef">
        <div class="user-avatar" @click="toggleMenu">
          {{ userAvatarText }}
        </div>
        <transition name="fade">
          <div v-show="menuVisible" class="user-menu">
            <div class="user-menu-item" @click="goToProfile">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
              </svg>
              个人信息
            </div>
            <div class="user-menu-item logout" @click="handleLogout">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                <polyline points="16,17 21,12 16,7"/>
                <line x1="21" y1="12" x2="9" y2="12"/>
              </svg>
              退出登录
            </div>
          </div>
        </transition>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const dropdownRef = ref(null)
const menuVisible = ref(false)

const userAvatarText = computed(() => {
  if (authStore.user?.username) {
    return authStore.user.username.charAt(0).toUpperCase()
  }
  return 'U'
})

const toggleMenu = () => {
  menuVisible.value = !menuVisible.value
}

const goToProfile = () => {
  menuVisible.value = false
  router.push('/profile')
}

const handleLogout = async () => {
  menuVisible.value = false
  await authStore.logout()
  ElMessage.success('已安全退出')
  router.push('/login')
}

const handleClickOutside = (e) => {
  if (dropdownRef.value && !dropdownRef.value.contains(e.target)) {
    menuVisible.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
.header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 80px;
  background: linear-gradient(135deg, #1a73e8, #4285f4);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 28px;
  color: #fff;
  z-index: 50;
  box-shadow: 0 2px 12px rgba(0,0,0,.15);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.header-logo {
  width: 44px;
  height: 44px;
  background: rgba(255,255,255,.2);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.header-logo svg {
  width: 26px;
  height: 26px;
}

.header-title {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.header-icon-btn {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: rgba(255,255,255,.15);
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: var(--transition);
  color: #fff;
}

.header-icon-btn:hover {
  background: rgba(255,255,255,.25);
}

.header-icon-btn svg {
  width: 24px;
  height: 24px;
}

.user-dropdown {
  position: relative;
}

.user-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: rgba(255,255,255,.25);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-weight: 700;
  cursor: pointer;
  transition: var(--transition);
}

.user-avatar:hover {
  background: rgba(255,255,255,.35);
}

.user-menu {
  position: absolute;
  top: 58px;
  right: 0;
  background: #fff;
  border-radius: var(--radius);
  box-shadow: var(--shadow-xl);
  min-width: 180px;
  padding: 8px;
  z-index: 100;
}

.user-menu-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  border-radius: 10px;
  font-size: 16px;
  color: var(--text);
  cursor: pointer;
  transition: var(--transition);
}

.user-menu-item:hover {
  background: var(--primary-light);
  color: var(--primary);
}

.user-menu-item.logout:hover {
  background: #fef2f2;
  color: #ef4444;
}

.user-menu-item svg {
  width: 20px;
  height: 20px;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s, transform 0.2s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}
</style>
