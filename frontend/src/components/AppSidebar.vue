<template>
  <aside class="sidebar">
    <div class="sidebar-section">
      <div class="sidebar-section-title">应用中心</div>
      <ul class="sidebar-menu">
        <li>
          <router-link to="/dashboard" :class="{ active: route.path === '/dashboard' }">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="3" y="3" width="7" height="7" rx="1"/>
              <rect x="14" y="3" width="7" height="7" rx="1"/>
              <rect x="3" y="14" width="7" height="7" rx="1"/>
              <rect x="14" y="14" width="7" height="7" rx="1"/>
            </svg>
            应用中心
          </router-link>
        </li>
      </ul>
    </div>

    <div class="sidebar-section">
      <div class="sidebar-section-title">学习模块</div>
      <ul class="sidebar-menu">
        <li v-for="module in modules" :key="module.id">
          <router-link
            :to="`/module/${module.id}`"
            :class="{ active: route.params.id === module.id }"
          >
            <span class="module-dot" :style="{ background: module.color }"></span>
            {{ module.name }}
          </router-link>
        </li>
      </ul>
    </div>
  </aside>
</template>

<script setup>
import { useRoute } from 'vue-router'

const route = useRoute()

const modules = [
  { id: 'turing', name: '图灵机', color: 'var(--m1)' },
  { id: 'complexity', name: '算法复杂度', color: 'var(--m2)' },
  { id: 'cellular', name: '元胞自动机', color: 'var(--m3)' },
  { id: 'circuit', name: '逻辑电路', color: 'var(--m4)' },
  { id: 'datastruct', name: '数据结构', color: 'var(--m5)' },
  { id: 'algorithm', name: '算法', color: 'var(--m6)' },
  { id: 'programming', name: '程序设计', color: 'var(--m7)' },
  { id: 'ai', name: '人工智能', color: 'var(--m8)' }
]
</script>

<style scoped>
.sidebar {
  position: fixed;
  top: 80px;
  left: 0;
  width: 240px;
  height: calc(100vh - 80px);
  background: #fff;
  border-right: 1px solid var(--border);
  overflow-y: auto;
  padding: 8px 0;
  z-index: 40;
}

.sidebar-section {
  padding: 0 12px 6px;
}

.sidebar-section-title {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 1px;
  padding: 14px 8px 10px;
}

.sidebar-menu {
  list-style: none;
  margin: 0;
  padding: 0;
}

.sidebar-menu li a {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 12px 16px;
  border-radius: 10px;
  font-size: 18px;
  font-weight: 500;
  color: var(--text-secondary);
  transition: var(--transition);
  margin: 2px 8px;
  text-decoration: none;
}

.sidebar-menu li a:hover {
  background: var(--primary-light);
  color: var(--primary);
}

.sidebar-menu li a.active {
  background: var(--primary-light);
  color: var(--primary);
  font-weight: 700;
}

.sidebar-menu li a svg {
  width: 22px;
  height: 22px;
  flex-shrink: 0;
}

.module-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
}
</style>
