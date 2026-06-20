<template>
  <div class="module-content cellular-module">
    <!-- 理论知识区域 -->
    <div class="theory-section">
      <h3 class="section-subtitle">📚 元胞自动机基础</h3>
      <div class="theory-content">
        <p><strong>元胞自动机（Cellular Automaton）</strong>是一种离散模型，由大量简单的格子（元胞）组成，每个元胞根据周围元胞的状态按照一定规则进行更新。</p>

        <div class="key-concept">
          <h4>🔬 经典元胞自动机</h4>
          <p>冯·诺依曼提出的二维元胞自动机是早期研究，但更著名的是<strong>一维元胞自动机</strong>，由数学家斯蒂芬·沃尔夫勒姆（Stephen Wolfram）系统研究。</p>
        </div>

        <div class="key-concept">
          <h4>📐 沃尔夫勒姆规则</h4>
          <p>一维元胞自动机每个元胞只有两个状态（0或1），更新规则基于当前元胞及其左右两个邻居的状态，共2³=8种情况，每种情况对应一个输出，形成一个8位二进制数（0-255）。</p>

          <div class="rule-example">
            <div class="rule-title">规则30的转换表：</div>
            <div class="rule-table">
              <div class="rule-row header">
                <span>111</span><span>110</span><span>101</span><span>100</span><span>011</span><span>010</span><span>001</span><span>000</span>
              </div>
              <div class="rule-row">
                <span>0</span><span>0</span><span>0</span><span>1</span><span>1</span><span>1</span><span>1</span><span>0</span>
              </div>
            </div>
            <p class="rule-desc">二进制：00011110 = 30</p>
          </div>
        </div>

        <div class="key-concept">
          <h4>🎯 典型应用</h4>
          <ul>
            <li><strong>生命游戏（Game of Life）</strong>：模拟生命演化的经典二维元胞自动机</li>
            <li><strong>交通流模拟</strong>：模拟道路上车辆的运动</li>
            <li><strong>森林火灾传播</strong>：模拟火灾在森林中的蔓延</li>
            <li><strong>扩散模拟</strong>：模拟气体或液体的扩散过程</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- 交互式模拟器区域 -->
    <div class="simulator-section">
      <h3 class="section-subtitle">🎮 一维元胞自动机模拟器</h3>

      <div class="simulator-container">
        <!-- 控制面板 -->
        <div class="control-panel">
          <div class="control-row">
            <div class="control-group">
              <label>选择规则（0-255）：</label>
              <input type="number" v-model.number="selectedRule" min="0" max="255" class="rule-input">
            </div>
            <div class="control-group">
              <label>预设规则：</label>
              <select v-model.number="selectedRule">
                <option v-for="r in presetRules" :key="r.value" :value="r.value">{{ r.name }} (规则{{ r.value }})</option>
              </select>
            </div>
          </div>

          <div class="control-row">
            <div class="control-group">
              <label>网格宽度：{{ gridWidth }}</label>
              <input type="range" v-model.number="gridWidth" min="21" max="101" step="10">
            </div>
            <div class="control-group">
              <label>行数（历史）：{{ rowCount }}</label>
              <input type="range" v-model.number="rowCount" min="10" max="50" step="5">
            </div>
          </div>

          <div class="control-buttons">
            <button @click="initializeGrid" class="btn-control btn-reset">初始化</button>
            <button @click="setRandomInitial" class="btn-control btn-step">随机初始</button>
            <button @click="stepForward" class="btn-control btn-step">单步执行</button>
            <button @click="startAutoRun" class="btn-control btn-run" :disabled="isRunning">{{ isRunning ? '运行中...' : '自动运行' }}</button>
            <button @click="stopAutoRun" class="btn-control btn-stop" :disabled="!isRunning">停止</button>
          </div>

          <div class="speed-control">
            <label>运行速度：</label>
            <input type="range" v-model="speed" min="50" max="1000" step="50">
            <span>{{ 1050 - speed }}ms</span>
          </div>
        </div>

        <!-- 可视化区域 -->
        <div class="grid-container">
          <div class="grid-info">
            <span>规则 {{ selectedRule }} (二进制: {{ ruleBinary }})</span>
            <span>代数: {{ generation }}</span>
          </div>
          <div class="cellular-grid">
            <div v-for="(row, rowIndex) in grid" :key="rowIndex" class="grid-row">
              <div
                v-for="(cell, colIndex) in row"
                :key="colIndex"
                class="grid-cell"
                :class="{ alive: cell === 1, current: rowIndex === generation - 1 && colIndex === currentIndex }"
                :style="{ backgroundColor: cell === 1 ? activeColor : '#fff', borderColor: cell === 1 ? activeColor : '#e5e7eb' }"
              ></div>
            </div>
          </div>
        </div>

        <!-- 转换规则可视化 -->
        <div class="rules-visualization">
          <div class="rules-title">当前规则的转换表</div>
          <div class="rules-grid">
            <div v-for="(value, index) in ruleTable" :key="index" class="rule-item">
              <div class="rule-inputs">
                <span class="cell" :class="{ alive: getPatternBit(index, 2) }"></span>
                <span class="cell" :class="{ alive: getPatternBit(index, 1) }"></span>
                <span class="cell" :class="{ alive: getPatternBit(index, 0) }"></span>
              </div>
              <span class="arrow">→</span>
              <span class="result-cell" :class="{ alive: value === 1 }"></span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 练习题区域 -->
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
import { ref, reactive, computed, watch } from 'vue'

// 配置
const gridWidth = ref(51)
const rowCount = ref(30)
const selectedRule = ref(30)
const generation = ref(1)
const currentIndex = ref(Math.floor(gridWidth.value / 2))
const isRunning = ref(false)
const speed = ref(200)
const activeColor = ref('#4285f4')

let grid = ref([])
let runInterval = null

const presetRules = [
  { value: 30, name: '混沌' },
  { value: 90, name: '规则90（产生分形）' },
  { value: 110, name: '规则110（通用计算）' },
  { value: 184, name: '规则184（交通流）' },
  { value: 226, name: '规则226' },
  { value: 255, name: '规则255（全1）' },
  { value: 0, name: '规则0（全0）' }
]

const ruleBinary = computed(() => selectedRule.value.toString(2).padStart(8, '0'))

const ruleTable = computed(() => {
  const table = []
  for (let i = 7; i >= 0; i--) {
    table.push((selectedRule.value >> i) & 1)
  }
  return table
})

function getPatternBit(patternIndex, bitPosition) {
  return ((7 - patternIndex) >> (2 - bitPosition)) & 1
}

function initializeGrid() {
  grid.value = []
  const initialRow = Array(gridWidth.value).fill(0)
  initialRow[Math.floor(gridWidth.value / 2)] = 1
  grid.value.push(initialRow)
  generation.value = 1
}

function setRandomInitial() {
  grid.value = []
  const initialRow = Array(gridWidth.value).fill(0)
  const center = Math.floor(gridWidth.value / 2)
  // 随机种子
  for (let i = center - 3; i <= center + 3; i++) {
    initialRow[i] = Math.random() > 0.5 ? 1 : 0
  }
  grid.value.push(initialRow)
  generation.value = 1
}

function computeNextRow(currentRow) {
  const nextRow = []
  for (let i = 0; i < currentRow.length; i++) {
    const left = currentRow[i - 1] ?? 0
    const center = currentRow[i]
    const right = currentRow[i + 1] ?? 0
    const pattern = (left << 2) | (center << 1) | right
    const nextValue = (selectedRule.value >> pattern) & 1
    nextRow.push(nextValue)
  }
  return nextRow
}

function stepForward() {
  if (grid.value.length === 0) {
    initializeGrid()
  }

  const currentRow = grid.value[grid.value.length - 1]
  const nextRow = computeNextRow(currentRow)
  grid.value.push(nextRow)
  generation.value++

  // 保持行数限制
  if (grid.value.length > rowCount.value) {
    grid.value.shift()
  }

  currentIndex.value = Math.floor(gridWidth.value / 2)
}

function startAutoRun() {
  if (isRunning.value) return
  isRunning.value = true

  if (grid.value.length === 0) {
    initializeGrid()
  }

  runInterval = setInterval(() => {
    stepForward()
  }, 1050 - speed.value)
}

function stopAutoRun() {
  if (runInterval) {
    clearInterval(runInterval)
    runInterval = null
  }
  isRunning.value = false
}

// 监听规则变化，重新计算
watch(selectedRule, () => {
  if (grid.value.length > 0) {
    // 重新计算所有行
    const originalFirstRow = [...grid.value[0]]
    grid.value = [originalFirstRow]
    generation.value = 1

    for (let i = 1; i < originalFirstRow.length; i++) {
      stepForward()
    }
  }
})

// 监听宽度变化
watch(gridWidth, () => {
  initializeGrid()
})

const quizzes = reactive([
  {
    question: '一维元胞自动机的规则编号范围是多少？',
    options: ['0-100', '0-255', '0-512', '0-1024'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '一维元胞自动机的每个元胞有几个邻居？',
    options: ['1个', '2个', '3个', '4个'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '规则30属于哪种类型的行为？',
    options: ['周期性', '稳定性', '混沌', '分形'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '著名的"生命游戏"是几维的元胞自动机？',
    options: ['0维', '1维', '2维', '3维'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '规则110被证明具有什么特性？',
    options: ['可逆性', '通用计算能力', '周期性', '稳定性'],
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

// 初始化
initializeGrid()
</script>

<style scoped>
.cellular-module { padding: 0; }

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

.theory-content p {
  color: var(--text-secondary);
  line-height: 1.8;
  margin-bottom: 16px;
}

.key-concept {
  background: var(--surface);
  border-radius: var(--radius);
  padding: 16px;
  margin-bottom: 16px;
}

.key-concept h4 {
  color: var(--primary);
  margin-bottom: 12px;
}

/* 规则示例 */
.rule-example {
  background: var(--bg);
  padding: 12px;
  border-radius: 8px;
  margin-top: 12px;
}

.rule-table {
  display: flex;
  justify-content: center;
  gap: 4px;
  margin: 8px 0;
}

.rule-row {
  display: flex;
  gap: 2px;
}

.rule-row span {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 4px;
  font-size: 11px;
  font-family: monospace;
}

.rule-row.header span { background: var(--primary-light); font-weight: 600; }
.rule-desc { font-size: 12px; color: var(--text-muted); text-align: center; margin: 8px 0 0; }

/* 控制面板 */
.control-panel {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 16px;
  margin-bottom: 16px;
}

.control-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 16px;
}

.control-group { margin-bottom: 8px; }
.control-group label {
  display: block;
  margin-bottom: 6px;
  font-weight: 600;
  font-size: 13px;
  color: var(--text);
}

.rule-input, .control-group select {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid var(--border);
  border-radius: 8px;
  font-size: 14px;
}

input[type="range"] {
  width: 100%;
  height: 6px;
  border-radius: 3px;
  background: var(--border);
  -webkit-appearance: none;
}

input[type="range"]::-webkit-slider-thumb {
  -webkit-appearance: none;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: var(--primary);
  cursor: pointer;
}

.control-buttons {
  display: flex;
  gap: 8px;
  margin-bottom: 12px;
}

.btn-control {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-run { background: var(--primary); color: white; }
.btn-step { background: #dbeafe; color: #1d4ed8; }
.btn-reset { background: #e5e7eb; color: #374151; }
.btn-stop { background: #fee2e2; color: #dc2626; }
.btn-control:disabled { opacity: 0.5; }
.btn-control:hover:not(:disabled) { transform: translateY(-1px); }

.speed-control {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 13px;
  color: var(--text-secondary);
}

/* 网格可视化 */
.grid-container {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 16px;
  margin-bottom: 16px;
  overflow-x: auto;
}

.grid-info {
  display: flex;
  justify-content: space-between;
  margin-bottom: 12px;
  font-size: 13px;
  color: var(--text-secondary);
}

.cellular-grid {
  display: flex;
  flex-direction: column;
  gap: 0;
  align-items: center;
}

.grid-row {
  display: flex;
  gap: 0;
}

.grid-cell {
  width: 10px;
  height: 10px;
  border: 1px solid;
  transition: background-color 0.1s;
}

.grid-cell.alive {
  background-color: var(--primary) !important;
}

/* 规则可视化 */
.rules-visualization {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 16px;
}

.rules-title {
  font-weight: 600;
  margin-bottom: 12px;
  color: var(--text);
  font-size: 13px;
}

.rules-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  justify-content: center;
}

.rule-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 10px;
  background: var(--surface);
  border-radius: 8px;
  font-size: 12px;
}

.rule-inputs {
  display: flex;
  gap: 2px;
}

.cell, .result-cell {
  width: 12px;
  height: 12px;
  border: 1px solid var(--border);
  border-radius: 2px;
  background: #fff;
}

.result-cell { background: var(--bg); }
.cell.alive, .result-cell.alive { background: var(--primary); }
.arrow { color: var(--primary); font-weight: 600; }

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

.exercise-item.answered.correct {
  border-color: #34a853;
  background: rgba(52, 168, 83, 0.05);
}

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

.quiz-question {
  font-weight: 600;
  color: var(--text);
  margin-bottom: 12px;
}

.quiz-options {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
}

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

.quiz-feedback {
  margin-top: 12px;
  padding: 8px 12px;
  background: var(--bg);
  border-radius: 6px;
  font-size: 13px;
}

@media (max-width: 768px) {
  .control-row { grid-template-columns: 1fr; }
}
</style>
