<template>
  <div class="module-content datastruct-module">
    <!-- 理论知识区域 -->
    <div class="theory-section">
      <h3 class="section-subtitle">📚 数据结构基础</h3>
      <div class="theory-content">
        <p><strong>数据结构</strong>是计算机存储、组织数据的方式，是算法的基础。正确选择数据结构可以大大提高算法效率。</p>

        <div class="key-concept">
          <h4>📊 常见数据结构</h4>
          <div class="ds-cards">
            <div class="ds-card" v-for="ds in dataStructures" :key="ds.name">
              <div class="ds-icon">{{ ds.icon }}</div>
              <div class="ds-name">{{ ds.name }}</div>
              <div class="ds-complexity">插入: {{ ds.insert }}<br>删除: {{ ds.delete }}<br>查找: {{ ds.search }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 交互式模拟器区域 -->
    <div class="simulator-section">
      <h3 class="section-subtitle">🎮 数据结构可视化</h3>

      <div class="simulator-container">
        <!-- 控制面板 -->
        <div class="control-panel">
          <div class="control-group">
            <label>选择数据结构：</label>
            <div class="ds-buttons">
              <button
                v-for="ds in dsTypes"
                :key="ds.id"
                :class="['ds-btn', { active: selectedType === ds.id }]"
                @click="switchDataStructure(ds.id)"
              >
                {{ ds.name }}
              </button>
            </div>
          </div>

          <div class="control-group">
            <label>操作：</label>
            <div class="op-buttons">
              <button @click="insertValue" class="op-btn">插入</button>
              <button @click="deleteValue" class="op-btn">删除</button>
              <button @click="searchValue" class="op-btn">查找</button>
              <button @click="clearData" class="op-btn reset">清空</button>
            </div>
          </div>

          <div class="input-group">
            <label>输入值：</label>
            <input type="number" v-model.number="inputValue" placeholder="输入数值" class="value-input">
            <button @click="performOperation" class="execute-btn">执行</button>
          </div>

          <div class="info-panel">
            <span>元素数量: {{ elementCount }}</span>
            <span v-if="lastOperation" :class="['last-op', lastOperation.type]">
              {{ lastOperation.message }}
            </span>
          </div>
        </div>

        <!-- 可视化区域 -->
        <div class="visualization-area">
          <!-- 数组可视化 -->
          <div v-if="selectedType === 'array'" class="array-visual">
            <div class="vis-label">数组</div>
            <div class="array-box">
              <div
                v-for="(val, idx) in arrayData"
                :key="idx"
                class="array-cell"
                :class="{ highlighted: highlightedIndex === idx, found: foundIndex === idx }"
              >
                <div class="cell-index">{{ idx }}</div>
                <div class="cell-value">{{ val }}</div>
              </div>
            </div>
          </div>

          <!-- 链表可视化 -->
          <div v-else-if="selectedType === 'linkedlist'" class="list-visual">
            <div class="vis-label">链表</div>
            <div class="linked-list">
              <div
                v-for="(node, idx) in linkedListData"
                :key="idx"
                class="list-node"
                :class="{ highlighted: highlightedIndex === idx }"
              >
                <div class="node-value">{{ node }}</div>
                <div class="node-arrow" v-if="idx < linkedListData.length - 1">→</div>
              </div>
              <div class="list-tail">NULL</div>
            </div>
          </div>

          <!-- 栈可视化 -->
          <div v-else-if="selectedType === 'stack'" class="stack-visual">
            <div class="vis-label">栈 (Stack)</div>
            <div class="stack-container">
              <div class="stack-box">
                <div
                  v-for="(val, idx) in stackData.slice().reverse()"
                  :key="idx"
                  class="stack-cell"
                  :class="{ top: idx === stackData.length - 1 }"
                >
                  <span class="stack-value">{{ val }}</span>
                  <span v-if="idx === 0" class="stack-top-label">← TOP</span>
                </div>
              </div>
              <div class="stack-ops">
                <span>PUSH →</span>
                <span>← POP</span>
              </div>
            </div>
          </div>

          <!-- 队列可视化 -->
          <div v-else-if="selectedType === 'queue'" class="queue-visual">
            <div class="vis-label">队列 (Queue)</div>
            <div class="queue-container">
              <div class="queue-flow">
                <span class="queue-end">出队 →</span>
                <div class="queue-box">
                  <div
                    v-for="(val, idx) in queueData"
                    :key="idx"
                    class="queue-cell"
                    :class="{ front: idx === 0 }"
                  >
                    {{ val }}
                  </div>
                </div>
                <span class="queue-end">← 入队</span>
              </div>
              <div class="queue-labels">
                <span>FRONT</span>
                <span>REAR</span>
              </div>
            </div>
          </div>

          <!-- 二叉树可视化 -->
          <div v-else-if="selectedType === 'tree'" class="tree-visual">
            <div class="vis-label">二叉搜索树</div>
            <div class="tree-container">
              <div class="tree-svg" ref="treeSvg">
                <svg :viewBox="`0 0 ${treeWidth} ${treeHeight}`">
                  <!-- 边 -->
                  <line
                    v-for="(edge, idx) in treeEdges"
                    :key="'edge-' + idx"
                    :x1="edge.x1" :y1="edge.y1" :x2="edge.x2" :y2="edge.y2"
                    stroke="#94a3b8" stroke-width="2"
                  />
                  <!-- 节点 -->
                  <g v-for="(node, idx) in treeNodes" :key="'node-' + idx">
                    <circle
                      :cx="node.x" :cy="node.y" r="20"
                      :fill="node.highlighted ? '#3b82f6' : '#e2e8f0'"
                      stroke="#64748b" stroke-width="2"
                    />
                    <text
                      :x="node.x" :y="node.y + 4"
                      text-anchor="middle" fill="white" font-size="12" font-weight="600"
                    >
                      {{ node.value }}
                    </text>
                  </g>
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 练习题 -->
    <div class="exercise-section">
      <h3 class="section-subtitle">📝 练习题</h3>
      <div class="exercises">
        <div class="exercise-item" v-for="(quiz, index) in quizzes" :key="index"
             :class="{ answered: quiz.answered, correct: quiz.answered && quiz.correct }">
          <div class="quiz-number">{{ index + 1 }}</div>
          <div class="quiz-content">
            <div class="quiz-question">{{ quiz.question }}</div>
            <div class="quiz-options">
              <label v-for="(option, optIndex) in quiz.options" :key="optIndex"
                     :class="{ selected: quiz.selected === optIndex, correct: quiz.answered && optIndex === quiz.answer }">
                <input type="radio" :name="'q' + index" :value="optIndex" v-model="quiz.selected" @change="checkAnswer(index)">
                {{ option }}
              </label>
            </div>
            <div class="quiz-feedback" v-if="quiz.answered">
              <span v-if="quiz.correct">✅ 正确！</span>
              <span v-else>❌ 错误！正确答案是：{{ quiz.options[quiz.answer] }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'

const selectedType = ref('array')
const inputValue = ref(null)
const highlightedIndex = ref(-1)
const foundIndex = ref(-1)
const lastOperation = ref(null)

// 数据结构类型
const dsTypes = [
  { id: 'array', name: '数组' },
  { id: 'linkedlist', name: '链表' },
  { id: 'stack', name: '栈' },
  { id: 'queue', name: '队列' },
  { id: 'tree', name: '二叉树' }
]

// 数据
const arrayData = reactive([10, 25, 33, 47, 58, 62, 78, 89])
const linkedListData = reactive([10, 25, 33, 47, 58])
const stackData = reactive([10, 25, 33, 47, 58])
const queueData = reactive([10, 25, 33, 47, 58])
const treeRoot = ref(null)

// 理论知识数据
const dataStructures = [
  { name: '数组', icon: '📦', insert: 'O(n)', delete: 'O(n)', search: 'O(1)*' },
  { name: '链表', icon: '🔗', insert: 'O(1)', delete: 'O(n)', search: 'O(n)' },
  { name: '栈', icon: '📚', insert: 'O(1)', delete: 'O(1)', search: 'O(n)' },
  { name: '队列', icon: '🚶', insert: 'O(1)', delete: 'O(1)', search: 'O(n)' },
  { name: '二叉树', icon: '🌲', insert: 'O(log n)', delete: 'O(log n)', search: 'O(log n)' }
]

const elementCount = computed(() => {
  switch (selectedType.value) {
    case 'array': return arrayData.length
    case 'linkedlist': return linkedListData.length
    case 'stack': return stackData.length
    case 'queue': return queueData.length
    case 'tree': return countTreeNodes(treeRoot.value)
    default: return 0
  }
})

function countTreeNodes(node) {
  return node ? 1 + countTreeNodes(node.left) + countTreeNodes(node.right) : 0
}

// 树的可视化数据
const treeWidth = 400
const treeHeight = 200

const treeNodes = computed(() => {
  const nodes = []
  collectNodes(treeRoot.value, treeWidth / 2, 40, treeWidth / 4, nodes, 0)
  return nodes
})

const treeEdges = computed(() => {
  const edges = []
  collectEdges(treeRoot.value, null, treeWidth / 2, 40, treeWidth / 4, edges, 0)
  return edges
})

function collectNodes(node, x, y, offset, nodes, depth) {
  if (!node) return
  nodes.push({ value: node.value, x, y, highlighted: highlightedIndex.value === node.value })
  if (node.left) collectNodes(node.left, x - offset, y + 50, offset / 2, nodes, depth + 1)
  if (node.right) collectNodes(node.right, x + offset, y + 50, offset / 2, nodes, depth + 1)
}

function collectEdges(node, parent, x, y, offset, edges, depth) {
  if (!node) return
  if (parent) {
    edges.push({ x1: x, y1: y, x2: parent.x, y2: parent.y })
  }
  if (node.left) collectEdges(node.left, { x, y }, x - offset, y + 50, offset / 2, edges, depth + 1)
  if (node.right) collectEdges(node.right, { x, y }, x + offset, y + 50, offset / 2, edges, depth + 1)
}

// 初始化树
function insertTreeNode(root, value) {
  if (!root) return { value, left: null, right: null }
  if (value < root.value) root.left = insertTreeNode(root.left, value)
  else root.right = insertTreeNode(root.right, value)
  return root
}

// 操作
function insertValue() {
  if (inputValue.value === null) return

  switch (selectedType.value) {
    case 'array':
      arrayData.push(inputValue.value)
      arrayData.sort((a, b) => a - b)
      lastOperation.value = { type: 'success', message: `插入 ${inputValue.value} 到数组` }
      break
    case 'linkedlist':
      if (linkedListData.length === 0 || inputValue.value <= linkedListData[0]) {
        linkedListData.unshift(inputValue.value)
      } else {
        for (let i = 0; i < linkedListData.length; i++) {
          if (inputValue.value <= linkedListData[i]) {
            linkedListData.splice(i, 0, inputValue.value)
            break
          }
          if (i === linkedListData.length - 1) {
            linkedListData.push(inputValue.value)
            break
          }
        }
      }
      lastOperation.value = { type: 'success', message: `插入 ${inputValue.value} 到链表` }
      break
    case 'stack':
      stackData.push(inputValue.value)
      lastOperation.value = { type: 'success', message: `PUSH ${inputValue.value}` }
      break
    case 'queue':
      queueData.push(inputValue.value)
      lastOperation.value = { type: 'success', message: `入队 ${inputValue.value}` }
      break
    case 'tree':
      treeRoot.value = insertTreeNode(treeRoot.value, inputValue.value)
      lastOperation.value = { type: 'success', message: `插入 ${inputValue.value} 到BST` }
      break
  }

  inputValue.value = null
  clearHighlights()
}

function deleteValue() {
  if (inputValue.value === null) return

  let deleted = false
  switch (selectedType.value) {
    case 'array':
      const idx = arrayData.indexOf(inputValue.value)
      if (idx !== -1) {
        arrayData.splice(idx, 1)
        deleted = true
      }
      break
    case 'linkedlist':
      const lidx = linkedListData.indexOf(inputValue.value)
      if (lidx !== -1) {
        linkedListData.splice(lidx, 1)
        deleted = true
      }
      break
    case 'stack':
      if (stackData.length > 0) {
        const popped = stackData.pop()
        lastOperation.value = { type: 'info', message: `POP ${popped}` }
        return
      }
      break
    case 'queue':
      if (queueData.length > 0) {
        const dequeued = queueData.shift()
        lastOperation.value = { type: 'info', message: `出队 ${dequeued}` }
        return
      }
      break
  }

  lastOperation.value = deleted
    ? { type: 'success', message: `删除 ${inputValue.value}` }
    : { type: 'error', message: `${inputValue.value} 不存在` }

  inputValue.value = null
  clearHighlights()
}

function searchValue() {
  if (inputValue.value === null) return

  let found = false
  switch (selectedType.value) {
    case 'array':
      const idx = arrayData.indexOf(inputValue.value)
      if (idx !== -1) {
        foundIndex.value = idx
        highlightedIndex.value = idx
        found = true
      }
      break
    case 'linkedlist':
      const lidx = linkedListData.indexOf(inputValue.value)
      if (lidx !== -1) {
        highlightedIndex.value = lidx
        found = true
      }
      break
    case 'stack':
    case 'queue':
      found = (selectedType.value === 'stack' ? stackData : queueData).includes(inputValue.value)
      break
  }

  lastOperation.value = found
    ? { type: 'success', message: `找到 ${inputValue.value}！` }
    : { type: 'error', message: `${inputValue.value} 未找到` }

  setTimeout(clearHighlights, 2000)
}

function clearData() {
  arrayData.length = 0
  linkedListData.length = 0
  stackData.length = 0
  queueData.length = 0
  treeRoot.value = null
  lastOperation.value = { type: 'info', message: '已清空' }
  clearHighlights()
}

function clearHighlights() {
  highlightedIndex.value = -1
  foundIndex.value = -1
}

function switchDataStructure(id) {
  selectedType.value = id
  clearHighlights()
  lastOperation.value = null
}

function performOperation() {
  // 根据上下文执行操作
}

// 练习题
const quizzes = reactive([
  {
    question: '数组访问第i个元素的时间复杂度是多少？',
    options: ['O(n)', 'O(1)', 'O(log n)', 'O(n²)'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '栈的特点是什么？',
    options: ['FIFO', 'LIFO', '随机访问', '无顺序'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '在链表头部插入一个元素的时间复杂度是？',
    options: ['O(n)', 'O(1)', 'O(log n)', 'O(n²)'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '二叉搜索树的查找时间复杂度是？',
    options: ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '队列的特点是什么？',
    options: ['LIFO', 'FIFO', '无限制', '后进先出'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  }
])

function checkAnswer(index) {
  const quiz = quizzes[index]
  quiz.answered = true
  quiz.correct = quiz.selected === quiz.answer
}
</script>

<style scoped>
.datastruct-module { padding: 0; }

.section-subtitle {
  font-size: 16px;
  color: var(--text);
  margin-bottom: 16px;
  padding-bottom: 8px;
  border-bottom: 2px solid var(--primary-light);
}

.theory-section, .simulator-section, .exercise-section {
  background: var(--surface);
  border-radius: var(--radius);
  padding: 20px;
  margin-bottom: 24px;
}

.theory-section { background: var(--bg); }

/* 卡片 */
.ds-cards { display: grid; grid-template-columns: repeat(5, 1fr); gap: 12px; }

.ds-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 12px;
  text-align: center;
}

.ds-icon { font-size: 24px; margin-bottom: 8px; }
.ds-name { font-weight: 600; margin-bottom: 4px; }
.ds-complexity { font-size: 11px; color: var(--text-muted); line-height: 1.4; }

/* 控制面板 */
.control-panel {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 16px;
  margin-bottom: 16px;
}

.control-group { margin-bottom: 12px; }
.control-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 13px; }

.ds-buttons, .op-buttons { display: flex; flex-wrap: wrap; gap: 8px; }

.ds-btn, .op-btn {
  padding: 8px 16px;
  border: 1px solid var(--border);
  border-radius: 8px;
  background: var(--surface);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}

.ds-btn.active, .op-btn:hover { background: var(--primary); color: white; border-color: var(--primary); }
.op-btn.reset { background: #fee2e2; color: #dc2626; border-color: #dc2626; }

.input-group { display: flex; gap: 8px; align-items: center; }
.value-input { flex: 1; padding: 8px 12px; border: 1px solid var(--border); border-radius: 8px; }

.execute-btn {
  padding: 8px 20px;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
}

.info-panel { display: flex; gap: 16px; font-size: 13px; color: var(--text-secondary); margin-top: 12px; }
.last-op.success { color: #22c55e; }
.last-op.error { color: #dc2626; }
.last-op.info { color: #3b82f6; }

/* 可视化区域 */
.visualization-area {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 24px;
  min-height: 200px;
}

.vis-label { font-weight: 600; margin-bottom: 16px; color: var(--text); }

/* 数组 */
.array-box { display: flex; gap: 4px; flex-wrap: wrap; }

.array-cell {
  width: 50px;
  height: 60px;
  border: 2px solid var(--border);
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: var(--surface);
  transition: all 0.3s;
}

.array-cell.highlighted { border-color: var(--primary); background: var(--primary-light); }
.array-cell.found { border-color: #22c55e; background: #dcfce7; }

.cell-index { font-size: 10px; color: var(--text-muted); }
.cell-value { font-size: 18px; font-weight: 700; }

/* 链表 */
.linked-list { display: flex; align-items: center; gap: 0; flex-wrap: wrap; }

.list-node { display: flex; align-items: center; }

.node-value {
  width: 50px;
  height: 50px;
  border: 2px solid var(--border);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 16px;
  background: var(--surface);
}

.node-arrow { margin: 0 4px; color: var(--text-muted); font-size: 20px; }
.list-tail { color: var(--text-muted); font-size: 12px; padding: 8px; }

/* 栈 */
.stack-container { display: flex; flex-direction: column; align-items: center; }

.stack-box {
  display: flex;
  flex-direction: column-reverse;
  gap: 2px;
  width: 120px;
}

.stack-cell {
  height: 36px;
  border: 2px solid var(--border);
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--surface);
  position: relative;
}

.stack-cell.top { border-color: var(--primary); background: var(--primary-light); }
.stack-value { font-weight: 700; }
.stack-top-label { position: absolute; right: -50px; font-size: 11px; color: var(--primary); }

.stack-ops { display: flex; justify-content: space-between; width: 120px; font-size: 11px; color: var(--text-muted); margin-top: 8px; }

/* 队列 */
.queue-container { text-align: center; }
.queue-flow { display: flex; align-items: center; justify-content: center; gap: 8px; }

.queue-box { display: flex; gap: 4px; }

.queue-cell {
  width: 50px;
  height: 50px;
  border: 2px solid var(--border);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  background: var(--surface);
}

.queue-cell.front { border-color: var(--primary); background: var(--primary-light); }
.queue-end { font-size: 12px; color: var(--text-muted); }
.queue-labels { display: flex; justify-content: space-around; margin-top: 8px; font-size: 11px; color: var(--text-muted); width: 280px; margin: 8px auto 0; }

/* 二叉树 */
.tree-container { display: flex; justify-content: center; }
.tree-svg { width: 100%; max-width: 400px; }

/* 练习题 */
.exercises { display: flex; flex-direction: column; gap: 12px; }

.exercise-item {
  display: flex;
  gap: 12px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 16px;
}

.exercise-item.answered.correct { border-color: #34a853; background: rgba(52, 168, 83, 0.05); }

.quiz-number {
  width: 32px;
  height: 32px;
  background: var(--primary);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 14px;
  flex-shrink: 0;
}

.quiz-content { flex: 1; }
.quiz-question { font-weight: 600; color: var(--text); margin-bottom: 12px; }

.quiz-options { display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px; }

.quiz-options label {
  padding: 8px 12px;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: 8px;
  cursor: pointer;
  font-size: 13px;
}

.quiz-options label:hover { border-color: var(--primary); }
.quiz-options label.selected { border-color: var(--primary); background: var(--primary-light); }
.quiz-options label.correct { border-color: #34a853; }

.quiz-feedback { margin-top: 12px; padding: 8px 12px; background: var(--bg); border-radius: 6px; font-size: 13px; }

@media (max-width: 768px) {
  .ds-cards { grid-template-columns: repeat(3, 1fr); }
  .quiz-options { grid-template-columns: 1fr; }
}
</style>
