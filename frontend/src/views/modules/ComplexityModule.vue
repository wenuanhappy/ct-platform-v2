<template>
  <div class="module-content complexity-module">
    <!-- 理论知识区域 -->
    <div class="theory-section">
      <h3 class="section-subtitle">📚 算法复杂度基础</h3>
      <div class="theory-content">
        <p>算法复杂度分析是评估算法效率的重要方法，主要包括<strong>时间复杂度</strong>和<strong>空间复杂度</strong>。</p>

        <div class="key-concept">
          <h4>⏱️ 时间复杂度</h4>
          <p>时间复杂度表示算法执行时间与输入规模之间的关系。通常用<strong>大O表示法</strong>表示。</p>
          <div class="complexity-table">
            <div class="complexity-row header">
              <span>复杂度</span>
              <span>名称</span>
              <span>示例</span>
            </div>
            <div class="complexity-row">
              <span class="complexity-tag O1">O(1)</span>
              <span>常数时间</span>
              <span>数组访问</span>
            </div>
            <div class="complexity-row">
              <span class="complexity-tag OlogN">O(log n)</span>
              <span>对数时间</span>
              <span>二分查找</span>
            </div>
            <div class="complexity-row">
              <span class="complexity-tag On">O(n)</span>
              <span>线性时间</span>
              <span>遍历数组</span>
            </div>
            <div class="complexity-row">
              <span class="complexity-tag Onlogn">O(n log n)</span>
              <span>线性对数时间</span>
              <span>快速排序</span>
            </div>
            <div class="complexity-row">
              <span class="complexity-tag On2">O(n²)</span>
              <span>平方时间</span>
              <span>冒泡排序</span>
            </div>
            <div class="complexity-row">
              <span class="complexity-tag O2n">O(2ⁿ)</span>
              <span>指数时间</span>
              <span>递归斐波那契</span>
            </div>
          </div>
        </div>

        <div class="key-concept">
          <h4>💾 空间复杂度</h4>
          <p>空间复杂度表示算法所需的内存空间与输入规模之间的关系。</p>
          <ul>
            <li><strong>O(1)</strong>：常数空间，只使用固定数量的变量</li>
            <li><strong>O(n)</strong>：线性空间，需要存储n个元素的数组</li>
            <li><strong>O(n²)</strong>：平方空间，如二维矩阵</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- 交互式模拟器区域 -->
    <div class="simulator-section">
      <h3 class="section-subtitle">🎮 复杂度可视化比较器</h3>

      <div class="simulator-container">
        <!-- 控制面板 -->
        <div class="control-panel">
          <div class="control-group">
            <label>选择要比较的复杂度：</label>
            <div class="complexity-checkboxes">
              <label v-for="c in complexityList" :key="c.id">
                <input type="checkbox" v-model="c.selected" @change="updateChart">
                <span :class="'complexity-tag ' + c.className">{{ c.label }}</span>
              </label>
            </div>
          </div>

          <div class="control-group">
            <label>输入规模 n: {{ inputSize }}</label>
            <input type="range" v-model.number="inputSize" min="5" max="100" step="5" @input="updateChart">
          </div>

          <div class="control-buttons">
            <button @click="runComparison" class="btn-control btn-run">运行比较</button>
            <button @click="resetChart" class="btn-control btn-reset">重置</button>
          </div>
        </div>

        <!-- 可视化图表 -->
        <div class="chart-container">
          <div class="chart-canvas" ref="chartCanvas">
            <div class="chart-y-axis">
              <span v-for="(tick, i) in yAxisTicks" :key="i" class="y-tick">
                {{ tick.label }}
              </span>
            </div>
            <div class="chart-area">
              <div class="grid-lines">
                <div v-for="i in 5" :key="i" class="grid-line horizontal"></div>
              </div>
              <svg class="chart-svg" :viewBox="`0 0 ${chartWidth} ${chartHeight}`">
                <!-- 绘制每条曲线 -->
                <g v-for="c in selectedComplexities" :key="c.id">
                  <path
                    :d="getPathD(c.function)"
                    fill="none"
                    :stroke="c.color"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  />
                  <circle
                    v-for="(point, i) in getPoints(c.function)"
                    :key="i"
                    :cx="point.x"
                    :cy="point.y"
                    r="4"
                    :fill="c.color"
                  />
                </g>
              </svg>
              <div class="chart-x-axis">
                <span v-for="(tick, i) in xAxisTicks" :key="i" class="x-tick" :style="{ left: tick.pos + '%' }">
                  {{ tick.label }}
                </span>
              </div>
            </div>
          </div>
          <div class="chart-legend">
            <div v-for="c in selectedComplexities" :key="c.id" class="legend-item">
              <span class="legend-color" :style="{ background: c.color }"></span>
              <span class="legend-label">{{ c.label }}</span>
              <span class="legend-value">{{ c.currentValue }}</span>
            </div>
          </div>
        </div>

        <!-- 操作计数演示 -->
        <div class="operation-counter">
          <div class="counter-title">当 n = {{ inputSize }} 时，各算法的操作次数：</div>
          <div class="counter-grid">
            <div v-for="c in selectedComplexities" :key="c.id" class="counter-item" :style="{ borderColor: c.color }">
              <div class="counter-label">{{ c.label }}</div>
              <div class="counter-value" :style="{ color: c.color }">{{ formatNumber(c.currentValue) }}</div>
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
import { ref, reactive, computed } from 'vue'

const inputSize = ref(30)
const chartWidth = 500
const chartHeight = 300

const complexityList = reactive([
  { id: 'O1', label: 'O(1)', className: 'O1', color: '#22c55e', selected: false, function: () => 1, currentValue: 0 },
  { id: 'OlogN', label: 'O(log n)', className: 'OlogN', color: '#3b82f6', selected: true, function: n => Math.log2(n), currentValue: 0 },
  { id: 'On', label: 'O(n)', className: 'On', color: '#f59e0b', selected: true, function: n => n, currentValue: 0 },
  { id: 'Onlogn', label: 'O(n log n)', className: 'Onlogn', color: '#ef4444', selected: true, function: n => n * Math.log2(n), currentValue: 0 },
  { id: 'On2', label: 'O(n²)', className: 'On2', color: '#8b5cf6', selected: false, function: n => n * n, currentValue: 0 },
  { id: 'O2n', label: 'O(2ⁿ)', className: 'O2n', color: '#ec4899', selected: false, function: n => Math.pow(2, Math.min(n, 10)), currentValue: 0 }
])

const selectedComplexities = computed(() => complexityList.filter(c => c.selected))

const yAxisTicks = computed(() => {
  const max = Math.max(...selectedComplexities.value.map(c => c.function(inputSize.value)))
  const ticks = []
  for (let i = 0; i <= 4; i++) {
    ticks.push({ label: formatNumber(max * i / 4) })
  }
  return ticks.reverse()
})

const xAxisTicks = computed(() => [
  { label: '0', pos: 0 },
  { label: Math.floor(inputSize.value / 2).toString(), pos: 50 },
  { label: inputSize.value.toString(), pos: 100 }
])

function getPoints(fn) {
  const points = []
  for (let i = 0; i <= inputSize.value; i += Math.max(1, Math.floor(inputSize.value / 20))) {
    points.push({
      x: (i / inputSize.value) * chartWidth,
      y: chartHeight - (fn(i) / fn(inputSize.value)) * chartHeight * 0.9
    })
  }
  return points
}

function getPathD(fn) {
  const points = getPoints(fn)
  if (points.length === 0) return ''
  return 'M ' + points.map(p => `${p.x},${p.y}`).join(' L ')
}

function updateChart() {
  selectedComplexities.value.forEach(c => {
    c.currentValue = Math.round(c.function(inputSize.value))
  })
}

function runComparison() {
  updateChart()
}

function resetChart() {
  inputSize.value = 30
  complexityList.forEach(c => {
    if (c.id === 'OlogN' || c.id === 'On') c.selected = true
    else c.selected = false
  })
  updateChart()
}

function formatNumber(n) {
  if (n >= 1e9) return (n / 1e9).toFixed(1) + 'B'
  if (n >= 1e6) return (n / 1e6).toFixed(1) + 'M'
  if (n >= 1e3) return (n / 1e3).toFixed(1) + 'K'
  return Math.round(n).toString()
}

const quizzes = reactive([
  {
    question: '下面哪个时间复杂度最慢？',
    options: ['O(1)', 'O(log n)', 'O(n²)', 'O(n)'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '二分查找的时间复杂度是多少？',
    options: ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '如果数据规模变为原来的2倍，O(n)算法的时间会变为原来的多少倍？',
    options: ['1倍', '2倍', '4倍', '指数倍'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '快速排序的平均时间复杂度是？',
    options: ['O(n)', 'O(n log n)', 'O(n²)', 'O(2ⁿ)'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '访问数组第i个元素的时间复杂度是？',
    options: ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'],
    answer: 0,
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
updateChart()
</script>

<style scoped>
.complexity-module { padding: 0; }

.section-subtitle {
  font-size: 16px;
  color: var(--text);
  margin-bottom: 16px;
  padding-bottom: 8px;
  border-bottom: 2px solid var(--primary-light);
}

/* 理论区域 */
.theory-section {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 20px;
  margin-bottom: 24px;
}

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

.complexity-table {
  border: 1px solid var(--border);
  border-radius: 8px;
  overflow: hidden;
}

.complexity-row {
  display: grid;
  grid-template-columns: 100px 1fr 1fr;
  padding: 10px 12px;
  border-bottom: 1px solid var(--border);
}

.complexity-row:last-child { border-bottom: none; }
.complexity-row.header { background: var(--bg); font-weight: 600; }

.complexity-tag {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
  font-family: monospace;
}

.complexity-tag.O1 { background: #dcfce7; color: #166534; }
.complexity-tag.OlogN { background: #dbeafe; color: #1d4ed8; }
.complexity-tag.On { background: #fef3c7; color: #92400e; }
.complexity-tag.Onlogn { background: #fee2e2; color: #dc2626; }
.complexity-tag.On2 { background: #f3e8ff; color: #7c3aed; }
.complexity-tag.O2n { background: #fce7f3; color: #be185d; }

/* 模拟器区域 */
.simulator-section {
  background: var(--surface);
  border-radius: var(--radius);
  padding: 20px;
  margin-bottom: 24px;
}

.control-panel {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 16px;
  margin-bottom: 16px;
}

.control-group { margin-bottom: 16px; }
.control-group:last-child { margin-bottom: 0; }

.control-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: var(--text);
}

.complexity-checkboxes {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.complexity-checkboxes label {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
}

.complexity-checkboxes input[type="checkbox"] {
  width: 16px;
  height: 16px;
}

input[type="range"] {
  width: 100%;
  height: 6px;
  border-radius: 3px;
  background: var(--border);
  outline: none;
  -webkit-appearance: none;
}

input[type="range"]::-webkit-slider-thumb {
  -webkit-appearance: none;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: var(--primary);
  cursor: pointer;
}

.control-buttons {
  display: flex;
  gap: 12px;
  margin-top: 16px;
}

.btn-control {
  flex: 1;
  padding: 10px 16px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-run { background: var(--primary); color: white; }
.btn-reset { background: var(--bg); color: var(--text); border: 1px solid var(--border); }
.btn-control:hover { transform: translateY(-1px); }

/* 图表区域 */
.chart-container {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 16px;
  margin-bottom: 16px;
}

.chart-canvas {
  position: relative;
  height: 300px;
  margin-bottom: 16px;
}

.chart-y-axis {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 30px;
  width: 60px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 10px 0;
}

.y-tick, .x-tick {
  font-size: 11px;
  color: var(--text-muted);
}

.chart-area {
  position: relative;
  margin-left: 60px;
  height: 100%;
}

.grid-lines {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.grid-line.horizontal {
  border-bottom: 1px dashed var(--border);
}

.chart-svg {
  width: 100%;
  height: 100%;
}

.chart-x-axis {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 25px;
  border-top: 1px solid var(--border);
}

.x-tick {
  position: absolute;
  transform: translateX(-50%);
  bottom: 5px;
}

.chart-legend {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  justify-content: center;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
}

.legend-color {
  width: 16px;
  height: 4px;
  border-radius: 2px;
}

.legend-label {
  font-size: 12px;
  font-weight: 600;
  font-family: monospace;
}

.legend-value {
  font-size: 12px;
  color: var(--text-muted);
}

/* 操作计数 */
.operation-counter {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 16px;
}

.counter-title {
  font-weight: 600;
  margin-bottom: 12px;
  color: var(--text);
}

.counter-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 12px;
}

.counter-item {
  background: var(--surface);
  border: 2px solid;
  border-radius: 8px;
  padding: 12px;
  text-align: center;
}

.counter-label {
  font-size: 12px;
  color: var(--text-secondary);
  margin-bottom: 4px;
}

.counter-value {
  font-size: 16px;
  font-weight: 700;
  font-family: monospace;
}

/* 练习题 */
.exercises {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

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
.quiz-options label.correct { border-color: #34a853; background: rgba(52, 168, 83, 0.1); }

.quiz-feedback {
  margin-top: 12px;
  padding: 8px 12px;
  background: var(--bg);
  border-radius: 6px;
  font-size: 13px;
}
</style>
