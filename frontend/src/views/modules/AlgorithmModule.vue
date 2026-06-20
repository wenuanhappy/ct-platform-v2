<template>
  <div class="module-content algorithm-module">
    <!-- 理论知识区域 -->
    <div class="theory-section">
      <h3 class="section-subtitle">📚 经典算法基础</h3>
      <div class="theory-content">
        <p><strong>算法</strong>是解决特定问题的步骤和方法。了解经典算法有助于培养解决问题的思维能力和代码实现能力。</p>

        <div class="key-concept">
          <h4>🔄 排序算法对比</h4>
          <div class="algo-compare-table">
            <div class="compare-row header">
              <span>算法</span><span>时间(最好)</span><span>时间(最坏)</span><span>空间</span><span>稳定性</span>
            </div>
            <div class="compare-row"><span>冒泡排序</span><span>O(n)</span><span>O(n²)</span><span>O(1)</span><span>稳定</span></div>
            <div class="compare-row"><span>插入排序</span><span>O(n)</span><span>O(n²)</span><span>O(1)</span><span>稳定</span></div>
            <div class="compare-row"><span>选择排序</span><span>O(n²)</span><span>O(n²)</span><span>O(1)</span><span>不稳定</span></div>
            <div class="compare-row"><span>快速排序</span><span>O(n log n)</span><span>O(n²)</span><span>O(log n)</span><span>不稳定</span></div>
            <div class="compare-row"><span>归并排序</span><span>O(n log n)</span><span>O(n log n)</span><span>O(n)</span><span>稳定</span></div>
          </div>
        </div>
      </div>
    </div>

    <!-- 交互式模拟器区域 -->
    <div class="simulator-section">
      <h3 class="section-subtitle">🎮 排序算法可视化</h3>

      <div class="simulator-container">
        <!-- 控制面板 -->
        <div class="control-panel">
          <div class="control-group">
            <label>选择算法：</label>
            <div class="algo-buttons">
              <button
                v-for="algo in algorithms"
                :key="algo.id"
                :class="['algo-btn', { active: selectedAlgo === algo.id }]"
                @click="selectedAlgo = algo.id"
              >
                {{ algo.name }}
              </button>
            </div>
          </div>

          <div class="control-row">
            <div class="control-group">
              <label>数组大小: {{ arraySize }}</label>
              <input type="range" v-model.number="arraySize" min="5" max="50" @change="generateArray">
            </div>
            <div class="control-group">
              <label>速度: {{ speed }}ms</label>
              <input type="range" v-model.number="speed" min="50" max="1000" step="50">
            </div>
          </div>

          <div class="control-buttons">
            <button @click="generateArray" class="ctrl-btn reset">生成新数组</button>
            <button @click="startSort" class="ctrl-btn run" :disabled="isSorting">{{ isSorting ? '排序中...' : '开始排序' }}</button>
            <button @click="pauseSort" class="ctrl-btn pause" :disabled="!isSorting">暂停</button>
            <button @click="resetSort" class="ctrl-btn reset">重置</button>
          </div>
        </div>

        <!-- 排序可视化 -->
        <div class="sorting-visual">
          <div class="bars-container">
            <div
              v-for="(value, idx) in sortArray"
              :key="idx"
              class="bar"
              :class="{
                comparing: comparingIndices.includes(idx),
                swapping: swappingIndices.includes(idx),
                sorted: sortedIndices.includes(idx),
                pivot: pivotIndex === idx
              }"
              :style="{ height: (value / maxValue) * 180 + 'px' }"
            >
              <span class="bar-value">{{ value }}</span>
            </div>
          </div>
          <div class="sort-info">
            <span>比较次数: {{ compareCount }}</span>
            <span>交换次数: {{ swapCount }}</span>
            <span>当前状态: {{ statusText }}</span>
          </div>
        </div>

        <!-- 算法步骤说明 -->
        <div class="algo-explanation">
          <div class="algo-title">{{ currentAlgoInfo?.name }} 算法步骤：</div>
          <div class="algo-steps">
            <div v-for="(step, idx) in currentAlgoInfo?.steps" :key="idx" class="step-item" :class="{ active: currentStep === idx }">
              <span class="step-num">{{ idx + 1 }}</span>
              <span class="step-text">{{ step }}</span>
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

const arraySize = ref(20)
const selectedAlgo = ref('bubble')
const speed = ref(200)
const sortArray = ref([])
const isSorting = ref(false)
const isPaused = ref(false)
const comparingIndices = ref([])
const swappingIndices = ref([])
const sortedIndices = ref([])
const pivotIndex = ref(-1)
const compareCount = ref(0)
const swapCount = ref(0)
const currentStep = ref(0)
const maxValue = computed(() => Math.max(...sortArray.value) || 100)

const algorithms = [
  { id: 'bubble', name: '冒泡排序' },
  { id: 'selection', name: '选择排序' },
  { id: 'insertion', name: '插入排序' },
  { id: 'quick', name: '快速排序' }
]

const algoInfo = {
  bubble: {
    name: '冒泡排序',
    steps: [
      '从左到右比较相邻的两个元素',
      '如果前一个大于后一个，则交换',
      '重复步骤1-2，直到没有需要交换的元素',
      '每轮遍历后，最大的元素会"冒泡"到最后'
    ]
  },
  selection: {
    name: '选择排序',
    steps: [
      '在未排序部分中找到最小元素',
      '将它与未排序部分的第一个元素交换',
      '缩小子数组范围，重复上述步骤',
      '最终整个数组变得有序'
    ]
  },
  insertion: {
    name: '插入排序',
    steps: [
      '将数组分为已排序和未排序两部分',
      '从未排序部分取出一个元素',
      '在已排序部分找到正确的插入位置',
      '插入该元素，重复直到数组有序'
    ]
  },
  quick: {
    name: '快速排序',
    steps: [
      '选择一个基准元素(pivot)',
      '将数组分为小于基准和大于基准两部分',
      '对左右两部分递归进行快速排序',
      '当子数组大小为0或1时，递归结束'
    ]
  }
}

const currentAlgoInfo = computed(() => algoInfo[selectedAlgo.value])

const statusText = computed(() => {
  if (isPaused.value) return '已暂停'
  if (!isSorting.value) return '就绪'
  if (isSorting.value) return '排序中...'
  return '完成'
})

function generateArray() {
  sortArray.value = Array.from({ length: arraySize.value }, () => Math.floor(Math.random() * 100) + 5)
  resetStats()
}

function resetStats() {
  comparingIndices.value = []
  swappingIndices.value = []
  sortedIndices.value = []
  pivotIndex.value = -1
  compareCount.value = 0
  swapCount.value = 0
  currentStep.value = 0
}

function resetSort() {
  isSorting.value = false
  isPaused.value = false
  resetStats()
}

async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

async function startSort() {
  if (isSorting.value) return
  isSorting.value = true
  isPaused.value = false
  resetStats()

  const arr = [...sortArray.value]

  switch (selectedAlgo.value) {
    case 'bubble': await bubbleSort(arr); break
    case 'selection': await selectionSort(arr); break
    case 'insertion': await insertionSort(arr); break
    case 'quick': await quickSort(arr, 0, arr.length - 1); break
  }

  // 标记所有为已排序
  sortedIndices.value = arr.map((_, i) => i)
  sortArray.value = arr
  isSorting.value = false
}

function pauseSort() {
  isPaused.value = !isPaused.value
}

async function bubbleSort(arr) {
  const n = arr.length
  for (let i = 0; i < n - 1; i++) {
    for (let j = 0; j < n - i - 1; j++) {
      if (!isSorting.value) return
      while (isPaused.value) await sleep(100)

      comparingIndices.value = [j, j + 1]
      compareCount.value++
      currentStep.value = 0
      await sleep(1050 - speed.value)

      if (arr[j] > arr[j + 1]) {
        swappingIndices.value = [j, j + 1]
        swapCount.value++
        currentStep.value = 1
        ;[arr[j], arr[j + 1]] = [arr[j + 1], arr[j]]
        await sleep(1050 - speed.value)
        swappingIndices.value = []
      }
    }
    sortedIndices.value.push(n - 1 - i)
  }
}

async function selectionSort(arr) {
  const n = arr.length
  for (let i = 0; i < n - 1; i++) {
    let minIdx = i
    for (let j = i + 1; j < n; j++) {
      if (!isSorting.value) return
      while (isPaused.value) await sleep(100)

      comparingIndices.value = [minIdx, j]
      pivotIndex.value = i
      compareCount.value++
      currentStep.value = 0
      await sleep(1050 - speed.value)

      if (arr[j] < arr[minIdx]) {
        minIdx = j
      }
    }

    if (minIdx !== i) {
      swappingIndices.value = [i, minIdx]
      swapCount.value++
      currentStep.value = 1
      ;[arr[i], arr[minIdx]] = [arr[minIdx], arr[i]]
      await sleep(1050 - speed.value)
      swappingIndices.value = []
    }

    sortedIndices.value.push(i)
    comparingIndices.value = []
    pivotIndex.value = -1
  }
  sortedIndices.value.push(n - 1)
}

async function insertionSort(arr) {
  const n = arr.length
  for (let i = 1; i < n; i++) {
    if (!isSorting.value) return
    const key = arr[i]
    let j = i - 1

    comparingIndices.value = [i]
    pivotIndex.value = i
    currentStep.value = 0
    await sleep(1050 - speed.value)

    while (j >= 0 && arr[j] > key) {
      while (isPaused.value) await sleep(100)

      comparingIndices.value = [j, j + 1]
      swapCount.value++
      currentStep.value = 1
      await sleep(1050 - speed.value)

      arr[j + 1] = arr[j]
      swappingIndices.value = [j, j + 1]
      await sleep(1050 - speed.value)
      swappingIndices.value = []
      j--
    }
    arr[j + 1] = key
    sortArray.value = [...arr]
    comparingIndices.value = []
    pivotIndex.value = -1
  }
  sortedIndices.value = arr.map((_, i) => i)
}

async function quickSort(arr, low, high) {
  if (low < high && isSorting.value) {
    const pi = await partition(arr, low, high)
    await quickSort(arr, low, pi - 1)
    await quickSort(arr, pi + 1, high)
  } else if (low >= 0 && low < arr.length) {
    if (!sortedIndices.value.includes(low)) sortedIndices.value.push(low)
  }
}

async function partition(arr, low, high) {
  const pivot = arr[high]
  pivotIndex.value = high
  let i = low - 1

  for (let j = low; j < high; j++) {
    if (!isSorting.value) return i + 1
    while (isPaused.value) await sleep(100)

    comparingIndices.value = [j, high]
    compareCount.value++
    currentStep.value = 0
    await sleep(1050 - speed.value)

    if (arr[j] < pivot) {
      i++
      if (i !== j) {
        swappingIndices.value = [i, j]
        swapCount.value++
        currentStep.value = 1
        ;[arr[i], arr[j]] = [arr[j], arr[i]]
        await sleep(1050 - speed.value)
        swappingIndices.value = []
      }
    }
    sortArray.value = [...arr]
  }

  swappingIndices.value = [i + 1, high]
  swapCount.value++
  ;[arr[i + 1], arr[high]] = [arr[high], arr[i + 1]]
  await sleep(1050 - speed.value)
  swappingIndices.value = []
  sortArray.value = [...arr]
  sortedIndices.value.push(i + 1)
  pivotIndex.value = -1
  comparingIndices.value = []

  return i + 1
}

// 练习题
const quizzes = reactive([
  {
    question: '以下哪个排序算法是稳定的？',
    options: ['快速排序', '选择排序', '归并排序', '堆排序'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '快速排序的平均时间复杂度是？',
    options: ['O(n)', 'O(n log n)', 'O(n²)', 'O(log n)'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '冒泡排序中，最大元素会？',
    options: ['沉到最底部', '冒泡到顶部', '保持原位', '随机移动'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '以下哪个排序算法最坏情况下时间复杂度是O(n²)？',
    options: ['归并排序', '堆排序', '快速排序', '计数排序'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '插入排序适合什么样的数据？',
    options: ['完全随机', '基本有序', '完全逆序', '无规律'],
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
generateArray()
</script>

<style scoped>
.algorithm-module { padding: 0; }

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

/* 算法对比表 */
.algo-compare-table { border: 1px solid var(--border); border-radius: 8px; overflow: hidden; }

.compare-row {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 0.8fr 0.8fr;
  padding: 10px 12px;
  border-bottom: 1px solid var(--border);
  font-size: 13px;
}

.compare-row:last-child { border-bottom: none; }
.compare-row.header { background: var(--bg); font-weight: 600; }

/* 控制面板 */
.control-panel {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 16px;
  margin-bottom: 16px;
}

.control-group { margin-bottom: 12px; }
.control-group label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 13px; }

.control-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

.algo-buttons { display: flex; flex-wrap: wrap; gap: 8px; }

.algo-btn {
  padding: 8px 16px;
  border: 1px solid var(--border);
  border-radius: 8px;
  background: var(--surface);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}

.algo-btn:hover { border-color: var(--primary); }
.algo-btn.active { background: var(--primary); color: white; border-color: var(--primary); }

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

.control-buttons { display: flex; gap: 8px; margin-top: 16px; }

.ctrl-btn {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.ctrl-btn.run { background: var(--primary); color: white; }
.ctrl-btn.pause { background: #fef3c7; color: #92400e; }
.ctrl-btn.reset { background: var(--bg); color: var(--text); border: 1px solid var(--border); }
.ctrl-btn:disabled { opacity: 0.5; cursor: not-allowed; }
.ctrl-btn:hover:not(:disabled) { transform: translateY(-1px); }

/* 排序可视化 */
.sorting-visual {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 20px;
  margin-bottom: 16px;
}

.bars-container {
  display: flex;
  align-items: flex-end;
  justify-content: center;
  height: 200px;
  gap: 2px;
  padding-bottom: 30px;
}

.bar {
  width: 100%;
  max-width: 30px;
  min-width: 8px;
  background: var(--primary);
  border-radius: 4px 4px 0 0;
  display: flex;
  align-items: flex-end;
  justify-content: center;
  transition: all 0.15s;
  position: relative;
}

.bar-value {
  position: absolute;
  bottom: -24px;
  font-size: 10px;
  color: var(--text-muted);
}

.bar.comparing { background: #f59e0b; }
.bar.swapping { background: #ef4444; transform: scaleY(1.05); }
.bar.sorted { background: #22c55e; }
.bar.pivot { background: #8b5cf6; }

.sort-info {
  display: flex;
  justify-content: center;
  gap: 24px;
  margin-top: 32px;
  font-size: 13px;
  color: var(--text-secondary);
}

/* 算法说明 */
.algo-explanation {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 16px;
}

.algo-title { font-weight: 600; margin-bottom: 12px; color: var(--text); }

.algo-steps { display: flex; flex-direction: column; gap: 8px; }

.step-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 8px 12px;
  background: var(--surface);
  border-radius: 8px;
  font-size: 13px;
  opacity: 0.6;
  transition: all 0.2s;
}

.step-item.active { opacity: 1; background: var(--primary-light); border-left: 3px solid var(--primary); }

.step-num {
  width: 20px;
  height: 20px;
  background: var(--primary);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
  font-weight: 700;
  flex-shrink: 0;
}

.step-text { color: var(--text-secondary); line-height: 1.5; }

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
  .control-row { grid-template-columns: 1fr; }
  .quiz-options { grid-template-columns: 1fr; }
}
</style>
