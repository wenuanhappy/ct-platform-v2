<template>
  <div class="dashboard-layout">
    <AppHeader />
    <div class="dashboard-body">
      <AppSidebar />
      <main class="dashboard-main">
        <div class="dashboard-content">
          <!-- Welcome Section -->
          <div class="welcome-section">
            <div class="welcome-text">
              <h1 class="welcome-title">
                欢迎回来，<span class="username">{{ user?.username || '学习者' }}</span>
              </h1>
              <p class="welcome-subtitle">选择一个模块开始你的计算思维学习之旅</p>
            </div>
            <div class="welcome-stats">
              <div class="stat-item">
                <div class="stat-value">{{ completedModules }}</div>
                <div class="stat-label">已完成模块</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">{{ totalModules }}</div>
                <div class="stat-label">总模块数</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">{{ progressPercent }}%</div>
                <div class="stat-label">学习进度</div>
              </div>
            </div>
          </div>

          <!-- Module Grid -->
          <div class="modules-section">
            <h2 class="section-title">
              <svg class="section-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7" rx="1"/>
                <rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/>
                <rect x="14" y="14" width="7" height="7" rx="1"/>
              </svg>
              学习模块
            </h2>
            <div class="modules-grid">
              <ModuleCard
                v-for="module in modules"
                :key="module.id"
                :module="module"
                @click="navigateToModule(module.id)"
              />
            </div>
          </div>

          <!-- Quick Tips -->
          <div class="tips-section">
            <h2 class="section-title">
              <svg class="section-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"/>
                <path d="M12 16v-4M12 8h.01"/>
              </svg>
              学习提示
            </h2>
            <div class="tips-grid">
              <div class="tip-card">
                <div class="tip-icon" style="background: #e3f2fd; color: #1976d2;">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 2L2 7l10 5 10-5-10-5z"/>
                    <path d="M2 17l10 5 10-5"/>
                    <path d="M2 12l10 5 10-5"/>
                  </svg>
                </div>
                <div class="tip-content">
                  <div class="tip-title">系统学习</div>
                  <div class="tip-text">按照模块顺序由浅入深，夯实基础概念</div>
                </div>
              </div>
              <div class="tip-card">
                <div class="tip-icon" style="background: #f3e5f5; color: #7b1fa2;">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                  </svg>
                </div>
                <div class="tip-content">
                  <div class="tip-title">动手实践</div>
                  <div class="tip-text">每个模块都配有交互式模拟器，边学边练</div>
                </div>
              </div>
              <div class="tip-card">
                <div class="tip-icon" style="background: #e8f5e9; color: #388e3c;">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                  </svg>
                </div>
                <div class="tip-content">
                  <div class="tip-title">协作交流</div>
                  <div class="tip-text">与同学讨论问题，分享学习心得</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import AppHeader from '@/components/AppHeader.vue'
import AppSidebar from '@/components/AppSidebar.vue'
import ModuleCard from '@/components/ModuleCard.vue'

const router = useRouter()
const authStore = useAuthStore()

const user = computed(() => authStore.user)

const modules = [
  { id: 'turing', name: '图灵机', icon: 'turing', color: '#4285f4', desc: '理解计算本质' },
  { id: 'complexity', name: '算法复杂度', icon: 'complexity', color: '#fbbc05', desc: '评估算法效率' },
  { id: 'cellular', name: '元胞自动机', icon: 'cellular', color: '#34a853', desc: '模拟复杂系统' },
  { id: 'circuit', name: '逻辑电路', icon: 'circuit', color: '#ea4335', desc: '构建数字逻辑' },
  { id: 'datastruct', name: '数据结构', icon: 'datastruct', color: '#9334e6', desc: '组织与管理数据' },
  { id: 'algorithm', name: '算法', icon: 'algorithm', color: '#00acc1', desc: '经典算法解析' },
  { id: 'programming', name: '程序设计', icon: 'programming', color: '#ff6d00', desc: '编程思维训练' },
  { id: 'ai', name: '人工智能', icon: 'ai', color: '#5f6368', desc: '探索AI奥秘' }
]

const totalModules = modules.length
const completedModules = computed(() => 0) // 后续可接入学习进度数据
const progressPercent = computed(() => Math.round((completedModules.value / totalModules) * 100))

const navigateToModule = (moduleId) => {
  router.push(`/module/${moduleId}`)
}
</script>

<style scoped>
.dashboard-layout {
  min-height: 100vh;
  background: var(--bg);
  display: flex;
  flex-direction: column;
}

.dashboard-body {
  display: flex;
  flex: 1;
  padding-top: 80px;
}

.dashboard-main {
  flex: 1;
  margin-left: 240px;
  min-height: calc(100vh - 80px);
  background: var(--bg);
}

.dashboard-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 24px 32px;
}

/* Welcome Section */
.welcome-section {
  background: var(--primary-gradient);
  border-radius: var(--radius-xl);
  padding: 28px 36px;
  margin-bottom: 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 8px 32px rgba(66, 133, 244, 0.2);
}

.welcome-title {
  font-size: 26px;
  font-weight: 700;
  color: #fff;
  margin-bottom: 8px;
}

.username {
  color: #ffeb3b;
}

.welcome-subtitle {
  font-size: 15px;
  color: rgba(255, 255, 255, 0.85);
}

.welcome-stats {
  display: flex;
  gap: 40px;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: #fff;
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 8px;
}

/* Section Title */
.section-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text);
  margin-bottom: 18px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.section-icon {
  width: 24px;
  height: 24px;
  color: var(--primary);
}

/* Modules Section */
.modules-section {
  margin-bottom: 24px;
}

.modules-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

/* Tips Section */
.tips-section {
  margin-bottom: 24px;
}

.tips-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.tip-card {
  background: var(--surface);
  border-radius: var(--radius-lg);
  padding: 18px;
  display: flex;
  align-items: flex-start;
  gap: 14px;
  border: 1px solid var(--border);
  box-shadow: var(--shadow);
  transition: all var(--transition);
}

.tip-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

.tip-icon {
  width: 50px;
  height: 50px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.tip-icon svg {
  width: 26px;
  height: 26px;
}

.tip-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text);
  margin-bottom: 6px;
}

.tip-text {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.5;
}

/* Responsive */
@media (max-width: 1200px) {
  .modules-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 900px) {
  .modules-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .tips-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .welcome-stats {
    display: none;
  }
}

@media (max-width: 768px) {
  .dashboard-main {
    margin-left: 0;
  }

  .dashboard-content {
    padding: 16px 20px;
  }

  .welcome-section {
    flex-direction: column;
    text-align: center;
    gap: 16px;
    padding: 24px;
  }

  .modules-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }

  .tips-grid {
    grid-template-columns: 1fr;
  }
}
</style>
