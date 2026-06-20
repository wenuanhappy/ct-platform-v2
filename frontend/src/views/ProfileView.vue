<template>
  <div class="profile-layout">
    <AppHeader />
    <div class="profile-body">
      <AppSidebar />
      <main class="profile-main">
        <div class="profile-content">
          <!-- Profile Header -->
          <div class="profile-header">
            <div class="avatar-section">
              <div class="avatar">
                <span>{{ userInitials }}</span>
              </div>
              <button class="btn-change-avatar">更换头像</button>
            </div>
            <div class="profile-info">
              <h1 class="profile-name">{{ user?.username || '学习者' }}</h1>
              <p class="profile-email">{{ user?.email || '未设置邮箱' }}</p>
              <div class="profile-badges">
                <span class="badge badge-primary">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                  </svg>
                  正式会员
                </span>
                <span class="badge badge-secondary">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                  </svg>
                  {{ completedModules }} 模块已学
                </span>
              </div>
            </div>
          </div>

          <!-- Profile Sections -->
          <div class="profile-sections">
            <!-- Basic Info -->
            <div class="profile-section">
              <h2 class="section-title">
                <svg class="section-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                  <circle cx="12" cy="7" r="4"/>
                </svg>
                基本信息
              </h2>
              <div class="section-content">
                <div class="info-grid">
                  <div class="info-item">
                    <label class="info-label">用户名</label>
                    <div class="info-value">{{ user?.username || '-' }}</div>
                  </div>
                  <div class="info-item">
                    <label class="info-label">邮箱</label>
                    <div class="info-value">{{ user?.email || '-' }}</div>
                  </div>
                  <div class="info-item">
                    <label class="info-label">角色</label>
                    <div class="info-value">
                      <span class="role-badge" :class="`role-${user?.role || 'student'}`">
                        {{ roleLabel }}
                      </span>
                    </div>
                  </div>
                  <div class="info-item">
                    <label class="info-label">注册时间</label>
                    <div class="info-value">{{ formatDate(user?.createdAt) }}</div>
                  </div>
                </div>
                <button class="btn-edit" @click="showEditBasicDialog = true">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                  </svg>
                  编辑资料
                </button>
              </div>
            </div>

            <!-- Password Change -->
            <div class="profile-section">
              <h2 class="section-title">
                <svg class="section-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                  <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
                修改密码
              </h2>
              <div class="section-content">
                <form class="password-form" @submit.prevent="handleChangePassword">
                  <div class="form-group">
                    <label>当前密码</label>
                    <input
                      v-model="passwordForm.oldPassword"
                      type="password"
                      placeholder="请输入当前密码"
                    />
                  </div>
                  <div class="form-group">
                    <label>新密码</label>
                    <input
                      v-model="passwordForm.newPassword"
                      type="password"
                      placeholder="请输入新密码"
                    />
                  </div>
                  <div class="form-group">
                    <label>确认新密码</label>
                    <input
                      v-model="passwordForm.confirmPassword"
                      type="password"
                      placeholder="请再次输入新密码"
                    />
                  </div>
                  <button type="submit" class="btn-submit">确认修改</button>
                </form>
              </div>
            </div>

            <!-- Learning Stats -->
            <div class="profile-section">
              <h2 class="section-title">
                <svg class="section-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <line x1="18" y1="20" x2="18" y2="10"/>
                  <line x1="12" y1="20" x2="12" y2="4"/>
                  <line x1="6" y1="20" x2="6" y2="14"/>
                </svg>
                学习统计
              </h2>
              <div class="section-content">
                <div class="stats-grid">
                  <div class="stat-card">
                    <div class="stat-icon" style="background: #e3f2fd; color: #1976d2;">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                      </svg>
                    </div>
                    <div class="stat-info">
                      <div class="stat-value">{{ totalModules }}</div>
                      <div class="stat-label">学习模块</div>
                    </div>
                  </div>
                  <div class="stat-card">
                    <div class="stat-icon" style="background: #e8f5e9; color: #388e3c;">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="20 6 9 17 4 12"/>
                      </svg>
                    </div>
                    <div class="stat-info">
                      <div class="stat-value">{{ completedModules }}</div>
                      <div class="stat-label">已完成</div>
                    </div>
                  </div>
                  <div class="stat-card">
                    <div class="stat-icon" style="background: #fff3e0; color: #f57c00;">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/>
                        <polyline points="12 6 12 12 16 14"/>
                      </svg>
                    </div>
                    <div class="stat-info">
                      <div class="stat-value">{{ totalHours }}</div>
                      <div class="stat-label">学习时长(h)</div>
                    </div>
                  </div>
                  <div class="stat-card">
                    <div class="stat-icon" style="background: #f3e5f5; color: #7b1fa2;">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                      </svg>
                    </div>
                    <div class="stat-info">
                      <div class="stat-value">{{ currentStreak }}</div>
                      <div class="stat-label">连续学习(天)</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Danger Zone -->
            <div class="profile-section danger-section">
              <h2 class="section-title danger-title">
                <svg class="section-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                  <line x1="12" y1="9" x2="12" y2="13"/>
                  <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                危险区域
              </h2>
              <div class="section-content">
                <div class="danger-item">
                  <div class="danger-info">
                    <div class="danger-title">注销账户</div>
                    <div class="danger-desc">注销后所有数据将无法恢复，请谨慎操作</div>
                  </div>
                  <button class="btn-danger" @click="handleAccountDeletion">注销账户</button>
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
import { ref, computed, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useAuthStore } from '@/stores/auth'
import AppHeader from '@/components/AppHeader.vue'
import AppSidebar from '@/components/AppSidebar.vue'

const authStore = useAuthStore()
const user = computed(() => authStore.user)

const showEditBasicDialog = ref(false)
const totalModules = 8
const completedModules = ref(0)
const totalHours = ref(0)
const currentStreak = ref(0)

const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

const userInitials = computed(() => {
  if (!user.value?.username) return '?'
  return user.value.username.charAt(0).toUpperCase()
})

const roleLabel = computed(() => {
  const roles = {
    student: '学生',
    teacher: '教师',
    admin: '管理员'
  }
  return roles[user.value?.role] || '学生'
})

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const handleChangePassword = async () => {
  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
    ElMessage.error('两次输入的密码不一致')
    return
  }
  if (passwordForm.newPassword.length < 6) {
    ElMessage.error('密码长度至少6位')
    return
  }
  // TODO: Call API to change password
  ElMessage.success('密码修改成功')
  passwordForm.oldPassword = ''
  passwordForm.newPassword = ''
  passwordForm.confirmPassword = ''
}

const handleAccountDeletion = async () => {
  try {
    await ElMessageBox.confirm(
      '确定要注销账户吗？此操作不可逆，所有数据将被永久删除。',
      '危险操作',
      {
        confirmButtonText: '确认注销',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    ElMessage.success('账户注销功能开发中...')
  } catch {
    // User cancelled
  }
}
</script>

<style scoped>
.profile-layout {
  min-height: 100vh;
  background: var(--bg);
  display: flex;
  flex-direction: column;
}

.profile-body {
  display: flex;
  flex: 1;
  padding-top: 80px;
}

.profile-main {
  flex: 1;
  margin-left: 240px;
  min-height: calc(100vh - 80px);
  background: var(--bg);
}

.profile-content {
  max-width: 900px;
  margin: 0 auto;
  padding: 32px;
}

/* Profile Header */
.profile-header {
  background: var(--surface);
  border-radius: var(--radius-xl);
  padding: 32px;
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  gap: 32px;
  box-shadow: var(--shadow);
  border: 1px solid var(--border);
}

.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.avatar {
  width: 100px;
  height: 100px;
  background: var(--primary-gradient);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 36px;
  font-weight: 700;
  box-shadow: 0 8px 20px rgba(66, 133, 244, 0.3);
}

.btn-change-avatar {
  padding: 6px 16px;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  font-size: 12px;
  color: var(--text-secondary);
  cursor: pointer;
  transition: all var(--transition);
}

.btn-change-avatar:hover {
  border-color: var(--primary);
  color: var(--primary);
}

.profile-info {
  flex: 1;
}

.profile-name {
  font-size: 24px;
  font-weight: 700;
  color: var(--text);
  margin-bottom: 4px;
}

.profile-email {
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 12px;
}

.profile-badges {
  display: flex;
  gap: 8px;
}

.badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

.badge svg {
  width: 14px;
  height: 14px;
}

.badge-primary {
  background: rgba(66, 133, 244, 0.1);
  color: #1976d2;
}

.badge-secondary {
  background: rgba(52, 168, 83, 0.1);
  color: #388e3c;
}

/* Sections */
.profile-sections {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.profile-section {
  background: var(--surface);
  border-radius: var(--radius-xl);
  padding: 24px;
  box-shadow: var(--shadow);
  border: 1px solid var(--border);
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text);
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.section-icon {
  width: 20px;
  height: 20px;
  color: var(--primary);
}

.danger-title {
  color: #d32f2f;
}

.danger-title .section-icon {
  color: #d32f2f;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-bottom: 20px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-label {
  font-size: 12px;
  color: var(--text-secondary);
}

.info-value {
  font-size: 14px;
  color: var(--text);
  font-weight: 500;
}

.role-badge {
  display: inline-block;
  padding: 2px 10px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.role-student {
  background: #e3f2fd;
  color: #1976d2;
}

.role-teacher {
  background: #f3e5f5;
  color: #7b1fa2;
}

.role-admin {
  background: #fff3e0;
  color: #f57c00;
}

.btn-edit {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  font-size: 13px;
  cursor: pointer;
  transition: all var(--transition);
}

.btn-edit svg {
  width: 16px;
  height: 16px;
}

.btn-edit:hover {
  background: color-mix(in srgb, var(--primary) 85%, black);
}

/* Password Form */
.password-form {
  max-width: 400px;
}

.form-group {
  margin-bottom: 16px;
}

.form-group label {
  display: block;
  font-size: 13px;
  color: var(--text-secondary);
  margin-bottom: 6px;
}

.form-group input {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  font-size: 14px;
  transition: all var(--transition);
}

.form-group input:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(66, 133, 244, 0.1);
}

.btn-submit {
  padding: 10px 24px;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  font-size: 14px;
  cursor: pointer;
  transition: all var(--transition);
}

.btn-submit:hover {
  background: color-mix(in srgb, var(--primary) 85%, black);
}

/* Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

.stat-card {
  background: var(--bg);
  border-radius: var(--radius-lg);
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-icon svg {
  width: 24px;
  height: 24px;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: var(--text);
}

.stat-label {
  font-size: 12px;
  color: var(--text-secondary);
}

/* Danger Zone */
.danger-section {
  border-color: rgba(211, 47, 47, 0.3);
}

.danger-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.danger-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text);
  margin-bottom: 4px;
}

.danger-desc {
  font-size: 12px;
  color: var(--text-secondary);
}

.btn-danger {
  padding: 8px 20px;
  background: white;
  color: #d32f2f;
  border: 1px solid #d32f2f;
  border-radius: var(--radius-md);
  font-size: 13px;
  cursor: pointer;
  transition: all var(--transition);
}

.btn-danger:hover {
  background: #d32f2f;
  color: white;
}

/* Responsive */
@media (max-width: 768px) {
  .profile-main {
    margin-left: 0;
  }

  .profile-content {
    padding: 20px;
  }

  .profile-header {
    flex-direction: column;
    text-align: center;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }

  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .danger-item {
    flex-direction: column;
    gap: 16px;
  }
}
</style>
