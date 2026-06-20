<template>
  <div class="module-view-layout">
    <AppHeader />
    <div class="module-view-body">
      <AppSidebar :active-module="moduleId" />
      <main class="module-view-main">
        <div class="module-view-content">
          <!-- Breadcrumb -->
          <div class="breadcrumb">
            <router-link to="/dashboard" class="breadcrumb-link">首页</router-link>
            <span class="breadcrumb-sep">/</span>
            <span class="breadcrumb-current">{{ moduleInfo.name }}</span>
          </div>

          <!-- Compact Module Header -->
          <div class="module-header" :style="{ '--module-color': moduleInfo.color }">
            <div class="module-header-icon">
              <component :is="moduleIcon" />
            </div>
            <div class="module-header-info">
              <h1 class="module-title">{{ moduleInfo.name }}</h1>
              <p class="module-subtitle">{{ moduleInfo.subtitle }}</p>
            </div>
            <div class="module-progress">
              <div class="progress-ring">
                <svg viewBox="0 0 36 36">
                  <path
                    class="progress-bg"
                    d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
                  />
                  <path
                    class="progress-value"
                    :stroke-dasharray="`${progress}, 100`"
                    d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
                  />
                </svg>
                <span class="progress-text">{{ progress }}%</span>
              </div>
            </div>
          </div>

          <!-- Main Content: Theory + Interactive -->
          <div class="main-content-area">
            <!-- Collapsible Theory Panel -->
            <div class="theory-panel" :class="{ collapsed: theoryCollapsed }">
              <div class="panel-header" @click="toggleTheory">
                <div class="panel-title">
                  <svg class="panel-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                  </svg>
                  <span>理论知识</span>
                </div>
                <button class="collapse-btn" :title="theoryCollapsed ? '展开' : '收起'">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline v-if="theoryCollapsed" points="9 18 15 12 9 6"/>
                    <polyline v-else points="15 18 9 12 15 6"/>
                  </svg>
                </button>
              </div>
              <div class="theory-content" v-show="!theoryCollapsed">
                <!-- Theory content based on current module -->
                <div class="theory-text" v-html="currentTheoryContent"></div>
              </div>
            </div>

            <!-- Resize Handle -->
            <div
              class="resize-handle"
              v-show="!theoryCollapsed"
              @mousedown="startResize"
              :class="{ resizing: isResizing }"
            >
              <div class="handle-dots">
                <span></span>
                <span></span>
                <span></span>
              </div>
            </div>

            <!-- Interactive Simulation Panel -->
            <div class="interactive-panel">
              <div class="panel-header">
                <div class="panel-title">
                  <svg class="panel-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="5 3 19 12 5 21 5 3"/>
                  </svg>
                  <span>交互模拟</span>
                </div>
              </div>
              <div class="simulator-container">
                <Suspense>
                  <component :is="simulatorComponent" />
                  <template #fallback>
                    <div class="loading-placeholder">加载中...</div>
                  </template>
                </Suspense>
              </div>
            </div>
          </div>

          <!-- Exercises -->
          <div class="exercises-section">
            <div class="card-header">
              <svg class="card-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                <polyline points="22 4 12 14.01 9 11.01"/>
              </svg>
              <h3 class="card-title">练习测验</h3>
            </div>
            <div class="exercises-grid">
              <div
                v-for="(exercise, index) in exercises"
                :key="index"
                class="exercise-card"
                :class="{ completed: exercise.completed }"
                @click="openExercise(exercise)"
              >
                <div class="exercise-number">{{ index + 1 }}</div>
                <div class="exercise-content">
                  <div class="exercise-title">{{ exercise.title }}</div>
                  <div class="exercise-type">{{ exercise.type }}</div>
                </div>
                <div class="exercise-status">
                  <svg v-if="exercise.completed" viewBox="0 0 24 24" fill="none" stroke="#34a853" stroke-width="2">
                    <polyline points="20 6 9 17 4 12"/>
                  </svg>
                  <svg v-else viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="M12 8v4M12 16h.01"/>
                  </svg>
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
import { computed, ref, h, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import AppHeader from '@/components/AppHeader.vue'
import AppSidebar from '@/components/AppSidebar.vue'

const route = useRoute()
const moduleId = computed(() => route.params.id)

// Theory panel state
const theoryCollapsed = ref(false)
const isResizing = ref(false)
const theoryWidth = ref(380)
let startX = 0
let startWidth = 0

const toggleTheory = () => {
  theoryCollapsed.value = !theoryCollapsed.value
}

const startResize = (e) => {
  isResizing.value = true
  startX = e.clientX
  startWidth = theoryWidth.value
  document.addEventListener('mousemove', onResize)
  document.addEventListener('mouseup', stopResize)
  document.body.style.cursor = 'col-resize'
  document.body.style.userSelect = 'none'
}

const onResize = (e) => {
  if (!isResizing.value) return
  const delta = e.clientX - startX
  const newWidth = Math.max(200, Math.min(600, startWidth + delta))
  theoryWidth.value = newWidth
}

const stopResize = () => {
  isResizing.value = false
  document.removeEventListener('mousemove', onResize)
  document.removeEventListener('mouseup', stopResize)
  document.body.style.cursor = ''
  document.body.style.userSelect = ''
}

onUnmounted(() => {
  document.removeEventListener('mousemove', onResize)
  document.removeEventListener('mouseup', stopResize)
})

// Module config
const moduleConfig = {
  turing: { name: '图灵机', subtitle: '理解计算的终极模型', color: '#4285f4' },
  complexity: { name: '算法复杂度', subtitle: '评估算法效率的必备知识', color: '#fbbc05' },
  cellular: { name: '元胞自动机', subtitle: '简单规则创造复杂世界', color: '#34a853' },
  circuit: { name: '逻辑电路', subtitle: '构建数字世界的基石', color: '#ea4335' },
  datastruct: { name: '数据结构', subtitle: '组织与管理数据的方法', color: '#9334e6' },
  algorithm: { name: '算法', subtitle: '经典算法的思想与实现', color: '#00acc1' },
  programming: { name: '程序设计', subtitle: '培养计算思维与编程能力', color: '#ff6d00' },
  ai: { name: '人工智能', subtitle: '探索机器学习的奥秘', color: '#5f6368' }
}

// Theory content for each module
const theoryContents = {
  turing: `
    <h4>图灵机的组成</h4>
    <ul>
      <li><strong>纸带（Tape）</strong>：无限长的带子，被分成一个个格子，每个格子存储一个符号</li>
      <li><strong>读写头（Head）</strong>：可以在纸带上移动、读取和写入符号</li>
      <li><strong>状态寄存器</strong>：存储图灵机当前的状态</li>
      <li><strong>转换规则表</strong>：定义在什么状态下读取什么符号后应该执行什么操作</li>
    </ul>
    <h4>工作原理</h4>
    <ol>
      <li>读取当前格子中的符号</li>
      <li>根据当前状态和读取的符号查找转换规则</li>
      <li>写入新的符号到当前格子</li>
      <li>向左或向右移动一格</li>
      <li>转换到新的状态</li>
    </ol>
    <div class="theory-note">📌 图灵机是现代计算机科学的理论基础，可以模拟任何计算过程。</div>
  `,
  complexity: `
    <h4>时间复杂度</h4>
    <p>时间复杂度表示算法执行时间与输入规模的关系。常用大O表示法：</p>
    <ul>
      <li><strong>O(1)</strong> - 常数时间：执行时间与输入规模无关</li>
      <li><strong>O(log n)</strong> - 对数时间：二分查找等</li>
      <li><strong>O(n)</strong> - 线性时间：遍历数组</li>
      <li><strong>O(n log n)</strong> - 线性对数时间：快速排序、归并排序</li>
      <li><strong>O(n²)</strong> - 平方时间：冒泡排序、选择排序</li>
      <li><strong>O(2ⁿ)</strong> - 指数时间：递归Fibonacci</li>
    </ul>
    <div class="theory-note">📌 复杂度越低，算法效率越高。选择合适的算法至关重要。</div>
  `,
  cellular: `
    <h4>元胞自动机简介</h4>
    <p>元胞自动机（Cellular Automata）是由冯·诺依曼提出的一种离散模型，由大量简单的细胞组成，每个细胞根据周围细胞的状态按照一定规则更新自己的状态。</p>
    <h4>经典规则</h4>
    <ul>
      <li><strong>规则30</strong>：产生伪随机序列，用于密码学</li>
      <li><strong>规则90</strong>：生成谢尔宾斯基三角形</li>
      <li><strong>规则110</strong>：图灵完备，可模拟任何计算</li>
    </ul>
    <div class="theory-note">📌 元胞自动机展示了简单规则如何产生复杂行为。</div>
  `,
  circuit: `
    <h4>基本逻辑门</h4>
    <ul>
      <li><strong>与门（AND）</strong>：所有输入为1时输出为1</li>
      <li><strong>或门（OR）</strong>：任意输入为1时输出为1</li>
      <li><strong>非门（NOT）</strong>：输入取反</li>
      <li><strong>与非门（NAND）</strong>：与门的反向</li>
      <li><strong>或非门（NOR）</strong>：或门的反向</li>
      <li><strong>异或门（XOR）</strong>：输入不同时输出为1</li>
    </ul>
    <div class="theory-note">📌 所有数字电路都可以由这三种基本门构成：与、或、非。</div>
  `,
  datastruct: `
    <h4>常见数据结构</h4>
    <ul>
      <li><strong>数组</strong>：连续内存，支持随机访问，O(1)查找</li>
      <li><strong>链表</strong>：节点包含数据和指针，O(1)插入/删除</li>
      <li><strong>栈</strong>：后进先出（LIFO），用于函数调用栈</li>
      <li><strong>队列</strong>：先进先出（FIFO），用于任务调度</li>
      <li><strong>二叉搜索树</strong>：左小右大，O(log n)查找</li>
    </ul>
    <div class="theory-note">📌 选择合适的数据结构可以大幅提升算法效率。</div>
  `,
  algorithm: `
    <h4>排序算法比较</h4>
    <table class="theory-table">
      <tr><th>算法</th><th>时间复杂度</th><th>空间复杂度</th><th>稳定性</th></tr>
      <tr><td>冒泡排序</td><td>O(n²)</td><td>O(1)</td><td>稳定</td></tr>
      <tr><td>选择排序</td><td>O(n²)</td><td>O(1)</td><td>不稳定</td></tr>
      <tr><td>插入排序</td><td>O(n²)</td><td>O(1)</td><td>稳定</td></tr>
      <tr><td>快速排序</td><td>O(n log n)</td><td>O(log n)</td><td>不稳定</td></tr>
    </table>
    <div class="theory-note">📌 "稳定"指相等的元素排序后相对位置不变。</div>
  `,
  programming: `
    <h4>程序执行过程</h4>
    <ol>
      <li><strong>编译/解释</strong>：将源代码转换为机器能理解的形式</li>
      <li><strong>词法分析</strong>：将代码分解成token（标记）</li>
      <li><strong>语法分析</strong>：检查语法是否正确</li>
      <li><strong>语义分析</strong>：检查变量是否声明、类型是否匹配</li>
      <li><strong>生成目标代码</strong>：生成可执行的机器指令</li>
    </ol>
    <div class="theory-note">📌 理解程序执行过程有助于编写更高效的代码。</div>
  `,
  ai: `
    <h4>机器学习基础</h4>
    <ul>
      <li><strong>感知机</strong>：最简单的神经网络，单层线性分类器</li>
      <li><strong>K近邻（KNN）</strong>：根据最近的K个邻居投票决定类别</li>
      <li><strong>决策树</strong>：根据特征递归划分样本的树形结构</li>
    </ul>
    <h4>学习类型</h4>
    <ul>
      <li><strong>监督学习</strong>：有标签的训练数据</li>
      <li><strong>无监督学习</strong>：无标签，发现数据内在结构</li>
      <li><strong>强化学习</strong>：通过试错学习最优策略</li>
    </ul>
    <div class="theory-note">📌 AI的本质是从数据中学习规律，进行预测或决策。</div>
  `
}

const currentTheoryContent = computed(() => theoryContents[moduleId.value] || theoryContents.turing)

const moduleInfo = computed(() => moduleConfig[moduleId.value] || moduleConfig.turing)
const progress = computed(() => 0)

const icons = {
  turing: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('rect', { x: 6, y: 14, width: 36, height: 20, rx: 4, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('rect', { x: 10, y: 10, width: 4, height: 4, rx: 1, fill: 'currentColor', opacity: 0.6 }),
    h('circle', { cx: 14, cy: 24, r: 5, stroke: 'currentColor', 'stroke-width': 2, fill: 'none' })
  ]),
  complexity: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('rect', { x: 6, y: 36, width: 6, height: 4, rx: 1, fill: 'currentColor' }),
    h('rect', { x: 14, y: 28, width: 6, height: 12, rx: 1, fill: 'currentColor' }),
    h('rect', { x: 22, y: 20, width: 6, height: 20, rx: 1, fill: 'currentColor' }),
    h('rect', { x: 30, y: 12, width: 6, height: 28, rx: 1, fill: 'currentColor' }),
    h('rect', { x: 38, y: 8, width: 6, height: 32, rx: 1, fill: 'currentColor' })
  ]),
  cellular: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('rect', { x: 4, y: 4, width: 12, height: 12, rx: 2, fill: 'currentColor', opacity: 0.3 }),
    h('rect', { x: 18, y: 4, width: 12, height: 12, rx: 2, fill: 'currentColor', opacity: 0.5 }),
    h('rect', { x: 32, y: 4, width: 12, height: 12, rx: 2, fill: 'currentColor', opacity: 0.7 }),
    h('rect', { x: 4, y: 18, width: 12, height: 12, rx: 2, fill: 'currentColor', opacity: 0.6 }),
    h('rect', { x: 18, y: 18, width: 12, height: 12, rx: 2, fill: 'currentColor', opacity: 0.9 }),
    h('rect', { x: 32, y: 18, width: 12, height: 12, rx: 2, fill: 'currentColor', opacity: 0.4 }),
    h('rect', { x: 4, y: 32, width: 12, height: 12, rx: 2, fill: 'currentColor', opacity: 0.8 }),
    h('rect', { x: 18, y: 32, width: 12, height: 12, rx: 2, fill: 'currentColor', opacity: 0.35 }),
    h('rect', { x: 32, y: 32, width: 12, height: 12, rx: 2, fill: 'currentColor', opacity: 0.55 })
  ]),
  circuit: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('rect', { x: 4, y: 4, width: 40, height: 40, rx: 4, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('circle', { cx: 24, cy: 24, r: 3, fill: 'currentColor', opacity: 0.7 })
  ]),
  datastruct: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('circle', { cx: 24, cy: 8, r: 5, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('line', { x1: 24, y1: 13, x2: 24, y2: 19, stroke: 'currentColor', 'stroke-width': 2 }),
    h('circle', { cx: 24, cy: 24, r: 5, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('line', { x1: 19, y1: 24, x2: 12, y2: 16, stroke: 'currentColor', 'stroke-width': 2 }),
    h('line', { x1: 29, y1: 24, x2: 36, y2: 16, stroke: 'currentColor', 'stroke-width': 2 }),
    h('circle', { cx: 10, cy: 40, r: 5, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('circle', { cx: 38, cy: 40, r: 5, stroke: 'currentColor', 'stroke-width': 2.5 })
  ]),
  algorithm: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('path', { d: 'M6 40L12 32L18 36L24 24L30 28L36 16L42 20', stroke: 'currentColor', 'stroke-width': 2.5, 'stroke-linejoin': 'round' })
  ]),
  programming: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('rect', { x: 4, y: 8, width: 40, height: 32, rx: 4, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('path', { d: 'M16 20l-4 4 4 4M26 28l8-16M32 20l4 4-4 4', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' })
  ]),
  ai: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('circle', { cx: 24, cy: 16, r: 10, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('line', { x1: 24, y1: 26, x2: 24, y2: 32, stroke: 'currentColor', 'stroke-width': 2.5, 'stroke-linecap': 'round' }),
    h('line', { x1: 18, y1: 32, x2: 30, y2: 32, stroke: 'currentColor', 'stroke-width': 2.5, 'stroke-linecap': 'round' })
  ])
}

const moduleIcon = computed(() => icons[moduleId.value] || icons.turing)

const modules = {
  turing: () => import('./modules/TuringModule.vue'),
  complexity: () => import('./modules/ComplexityModule.vue'),
  cellular: () => import('./modules/CellularModule.vue'),
  circuit: () => import('./modules/CircuitModule.vue'),
  datastruct: () => import('./modules/DataStructModule.vue'),
  algorithm: () => import('./modules/AlgorithmModule.vue'),
  programming: () => import('./modules/ProgrammingModule.vue'),
  ai: () => import('./modules/AIModule.vue')
}

const simulatorComponent = computed(() => modules[moduleId.value] || modules.turing)

const exercises = [
  { title: '基础概念测试', type: '选择题', completed: false },
  { title: '实际应用练习', type: '应用题', completed: false },
  { title: '综合能力挑战', type: '综合题', completed: false }
]

const openExercise = (exercise) => {
  console.log('Open exercise:', exercise)
}
</script>

<style scoped>
.module-view-layout {
  min-height: 100vh;
  background: var(--bg);
  display: flex;
  flex-direction: column;
}

.module-view-body {
  display: flex;
  flex: 1;
  padding-top: 80px;
}

.module-view-main {
  flex: 1;
  margin-left: 240px;
  min-height: calc(100vh - 80px);
  background: var(--bg);
}

.module-view-content {
  max-width: 1600px;
  margin: 0 auto;
  padding: 20px 24px;
}

/* Breadcrumb */
.breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
  font-size: 14px;
}

.breadcrumb-link {
  color: var(--primary);
  text-decoration: none;
}

.breadcrumb-link:hover {
  text-decoration: underline;
}

.breadcrumb-sep {
  color: var(--text-muted);
}

.breadcrumb-current {
  color: var(--text-secondary);
}

/* Compact Module Header */
.module-header {
  background: linear-gradient(135deg, var(--module-color, #4285f4) 0%, color-mix(in srgb, var(--module-color, #4285f4) 80%, white) 100%);
  border-radius: var(--radius-lg);
  padding: 14px 20px;
  margin-bottom: 16px;
  display: flex;
  align-items: center;
  gap: 14px;
  color: white;
}

.module-header-icon {
  width: 44px;
  height: 44px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.module-header-icon :deep(svg) {
  width: 26px;
  height: 26px;
}

.module-header-info {
  flex: 1;
}

.module-title {
  font-size: 18px;
  font-weight: 700;
  margin: 0;
}

.module-subtitle {
  font-size: 12px;
  opacity: 0.9;
  margin: 0;
}

.progress-ring {
  position: relative;
  width: 40px;
  height: 40px;
}

.progress-ring svg {
  transform: rotate(-90deg);
}

.progress-bg {
  fill: none;
  stroke: rgba(255, 255, 255, 0.2);
  stroke-width: 3;
}

.progress-value {
  fill: none;
  stroke: white;
  stroke-width: 3;
  stroke-linecap: round;
  transition: stroke-dasharray 0.5s;
}

.progress-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 10px;
  font-weight: 700;
}

/* Main Content Area */
.main-content-area {
  display: flex;
  gap: 0;
  margin-bottom: 16px;
  min-height: 450px;
}

/* Theory Panel */
.theory-panel {
  width: 380px;
  min-width: 200px;
  max-width: 600px;
  background: var(--surface);
  border-radius: var(--radius-lg) 0 0 var(--radius-lg);
  border: 1px solid var(--border);
  border-right: none;
  display: flex;
  flex-direction: column;
  transition: width 0.3s ease, min-width 0.3s ease;
  overflow: hidden;
  flex-shrink: 0;
}

.theory-panel.collapsed {
  width: 48px;
  min-width: 48px;
}

.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 14px;
  border-bottom: 1px solid var(--border);
  background: var(--surface-secondary);
  cursor: pointer;
  transition: background 0.2s;
}

.theory-panel.collapsed .panel-header {
  justify-content: center;
  padding: 12px 8px;
}

.panel-header:hover {
  background: var(--bg);
}

.panel-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: var(--text);
}

.theory-panel.collapsed .panel-title span {
  display: none;
}

.panel-icon {
  width: 16px;
  height: 16px;
  color: var(--primary);
  flex-shrink: 0;
}

.collapse-btn {
  background: none;
  border: none;
  padding: 4px;
  cursor: pointer;
  color: var(--text-muted);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.collapse-btn:hover {
  background: var(--border);
  color: var(--text);
}

.collapse-btn svg {
  width: 16px;
  height: 16px;
}

.theory-content {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  background: var(--bg);
}

.theory-text {
  font-size: 13px;
  color: var(--text-secondary);
  line-height: 1.7;
}

.theory-text h4 {
  color: var(--primary);
  font-size: 14px;
  margin: 0 0 10px 0;
}

.theory-text ul, .theory-text ol {
  padding-left: 18px;
  margin: 0 0 14px 0;
}

.theory-text li {
  margin-bottom: 6px;
}

.theory-text p {
  margin: 0 0 12px 0;
}

.theory-note {
  background: var(--primary-light);
  color: var(--primary);
  padding: 10px 12px;
  border-radius: 6px;
  font-size: 12px;
  margin-top: 12px;
}

.theory-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 12px;
  margin: 10px 0;
}

.theory-table th, .theory-table td {
  border: 1px solid var(--border);
  padding: 6px 8px;
  text-align: center;
}

.theory-table th {
  background: var(--surface-secondary);
  font-weight: 600;
}

/* Resize Handle */
.resize-handle {
  width: 6px;
  background: var(--border);
  cursor: col-resize;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s;
  flex-shrink: 0;
}

.resize-handle:hover,
.resize-handle.resizing {
  background: var(--primary);
}

.handle-dots {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.handle-dots span {
  width: 3px;
  height: 3px;
  background: var(--text-muted);
  border-radius: 50%;
}

.resize-handle:hover .handle-dots span,
.resize-handle.resizing .handle-dots span {
  background: white;
}

/* Interactive Panel */
.interactive-panel {
  flex: 1;
  background: var(--surface);
  border-radius: 0 var(--radius-lg) var(--radius-lg) 0;
  border: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.interactive-panel .panel-header {
  cursor: default;
}

.interactive-panel .panel-header:hover {
  background: var(--surface-secondary);
}

.simulator-container {
  flex: 1;
  overflow-y: auto;
  background: var(--bg);
}

.loading-placeholder {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-muted);
  font-size: 14px;
}

/* Exercises Section */
.exercises-section {
  background: var(--surface);
  border-radius: var(--radius-lg);
  border: 1px solid var(--border);
  padding: 14px 18px;
  box-shadow: var(--shadow);
}

.card-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
}

.card-icon {
  width: 16px;
  height: 16px;
  color: var(--primary);
}

.card-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text);
  margin: 0;
}

.exercises-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}

.exercise-card {
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 12px 14px;
  cursor: pointer;
  transition: all var(--transition);
  display: flex;
  align-items: center;
  gap: 10px;
}

.exercise-card:hover {
  border-color: var(--primary);
  background: color-mix(in srgb, var(--primary) 5%, var(--bg));
}

.exercise-card.completed {
  border-color: #34a853;
  background: rgba(52, 168, 83, 0.05);
}

.exercise-number {
  width: 26px;
  height: 26px;
  background: var(--primary);
  color: white;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 12px;
  flex-shrink: 0;
}

.exercise-content {
  flex: 1;
}

.exercise-title {
  font-size: 12px;
  font-weight: 600;
  color: var(--text);
  margin-bottom: 2px;
}

.exercise-type {
  font-size: 10px;
  color: var(--text-secondary);
}

.exercise-status svg {
  width: 16px;
  height: 16px;
  color: var(--text-muted);
}

/* Responsive */
@media (max-width: 1200px) {
  .main-content-area {
    flex-direction: column;
  }

  .theory-panel {
    width: 100%;
    max-width: none;
    border-radius: var(--radius-lg) var(--radius-lg) 0 0;
    border-right: 1px solid var(--border);
    border-bottom: none;
    max-height: 250px;
  }

  .theory-panel.collapsed {
    max-height: 48px;
    width: 100%;
  }

  .resize-handle {
    display: none;
  }

  .interactive-panel {
    border-radius: 0 0 var(--radius-lg) var(--radius-lg);
    min-height: 350px;
  }
}

@media (max-width: 768px) {
  .module-view-main {
    margin-left: 0;
  }

  .module-view-content {
    padding: 14px 16px;
  }

  .module-header {
    flex-direction: column;
    text-align: center;
    gap: 10px;
    padding: 14px;
  }

  .exercises-grid {
    grid-template-columns: 1fr;
  }
}
</style>
