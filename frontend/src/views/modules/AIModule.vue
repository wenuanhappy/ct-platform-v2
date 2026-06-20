<template>
  <div class="module-content ai-module">
    <!-- 理论知识区域 -->
    <div class="theory-section">
      <h3 class="section-subtitle">📚 人工智能基础</h3>
      <div class="theory-content">
        <p><strong>人工智能（Artificial Intelligence）</strong>是让计算机具有人类智能的技术，包括学习、推理、感知、语言理解等能力。</p>

        <div class="key-concept">
          <h4>🧠 AI 主要分支</h4>
          <div class="ai-branches">
            <div class="branch-card">
              <div class="branch-icon">🤖</div>
              <div class="branch-name">机器学习</div>
              <div class="branch-desc">让计算机从数据中学习规律</div>
            </div>
            <div class="branch-card">
              <div class="branch-icon">🧠</div>
              <div class="branch-name">深度学习</div>
              <div class="branch-desc">使用神经网络模拟人脑</div>
            </div>
            <div class="branch-card">
              <div class="branch-icon">💬</div>
              <div class="branch-name">自然语言处理</div>
              <div class="branch-desc">让计算机理解和生成语言</div>
            </div>
            <div class="branch-card">
              <div class="branch-icon">👁️</div>
              <div class="branch-name">计算机视觉</div>
              <div class="branch-desc">让计算机"看懂"图像和视频</div>
            </div>
          </div>
        </div>

        <div class="key-concept">
          <h4>🔢 神经网络基础</h4>
          <p>神经网络由<strong>输入层</strong>、<strong>隐藏层</strong>和<strong>输出层</strong>组成，每层包含多个神经元。</p>
          <div class="neural-diagram">
            <div class="layer input-layer">
              <div class="layer-label">输入层</div>
              <div class="neurons">
                <div class="neuron" v-for="n in 3" :key="n">x{{ n }}</div>
              </div>
            </div>
            <div class="layer hidden-layer">
              <div class="layer-label">隐藏层</div>
              <div class="neurons">
                <div class="neuron" v-for="n in 4" :key="n">h{{ n }}</div>
              </div>
            </div>
            <div class="layer output-layer">
              <div class="layer-label">输出层</div>
              <div class="neurons">
                <div class="neuron" v-for="n in 2" :key="n">y{{ n }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 交互式模拟器区域 -->
    <div class="simulator-section">
      <h3 class="section-subtitle">🎮 AI 模拟器</h3>

      <div class="simulator-container">
        <!-- 模拟器选择 -->
        <div class="sim-tabs">
          <button
            v-for="sim in simulations"
            :key="sim.id"
            :class="['sim-tab', { active: activeSim === sim.id }]"
            @click="activeSim = sim.id"
          >
            {{ sim.name }}
          </button>
        </div>

        <!-- 感知机模拟 -->
        <div v-if="activeSim === 'perceptron'" class="sim-content">
          <div class="sim-description">
            <p><strong>感知机（Perceptron）</strong>是最简单的神经网络，只能解决线性可分问题。</p>
          </div>

          <div class="perceptron-controls">
            <div class="control-group">
              <label>输入 x1: {{ inputs.x1 }}</label>
              <input type="range" v-model.number="inputs.x1" min="0" max="1" step="0.1">
            </div>
            <div class="control-group">
              <label>输入 x2: {{ inputs.x2 }}</label>
              <input type="range" v-model.number="inputs.x2" min="0" max="1" step="0.1">
            </div>
            <div class="weights-display">
              <span>权重 w1: {{ weights.w1.toFixed(2) }}</span>
              <span>权重 w2: {{ weights.w2.toFixed(2) }}</span>
              <span>偏置 b: {{ weights.bias.toFixed(2) }}</span>
            </div>
            <button @click="trainPerceptron" class="train-btn">训练一步</button>
            <button @click="resetPerceptron" class="reset-btn">重置</button>
          </div>

          <div class="perceptron-visual">
            <div class="input-display">
              <div class="input-node" :class="{ active: inputs.x1 > 0.5 }">x1={{ inputs.x1.toFixed(1) }}</div>
              <div class="input-node" :class="{ active: inputs.x2 > 0.5 }">x2={{ inputs.x2.toFixed(1) }}</div>
            </div>
            <div class="synapses">
              <div class="synapse">
                <span class="syn-weight">{{ weights.w1.toFixed(2) }}</span>
              </div>
              <div class="synapse">
                <span class="syn-weight">{{ weights.w2.toFixed(2) }}</span>
              </div>
            </div>
            <div class="perceptron-node" :class="{ active: perceptronOutput > 0.5 }">
              <div class="node-label">∑ + σ</div>
              <div class="node-output">y = {{ perceptronOutput.toFixed(2) }}</div>
            </div>
          </div>

          <div class="training-log">
            <div class="log-title">训练日志</div>
            <div v-for="(log, i) in trainingLogs.slice(-5)" :key="i" class="log-item">
              第 {{ log.step }} 步: 输入({{ log.x1 }}, {{ log.x2 }}) → 输出 {{ log.output.toFixed(2) }} (期望 {{ log.target }})
            </div>
          </div>
        </div>

        <!-- K近邻模拟 -->
        <div v-else-if="activeSim === 'knn'" class="sim-content">
          <div class="sim-description">
            <p><strong>K近邻算法（KNN）</strong>：通过计算距离找出最近的K个邻居，投票决定新数据的类别。</p>
          </div>

          <div class="knn-visual">
            <div class="scatter-plot">
              <div class="plot-area">
                <div
                  v-for="(point, i) in knnPoints"
                  :key="i"
                  class="data-point"
                  :class="[point.category, { nearest: point.nearest }]"
                  :style="{ left: point.x + '%', top: point.y + '%' }"
                  @click="toggleNearest(i)"
                >
                  {{ point.label }}
                </div>
                <div
                  v-if="newPoint"
                  class="data-point new-point"
                  :style="{ left: newPoint.x + '%', top: newPoint.y + '%' }"
                >
                  ?
                </div>
              </div>
              <div class="plot-legend">
                <span class="legend-item class-a">A类</span>
                <span class="legend-item class-b">B类</span>
              </div>
            </div>

            <div class="knn-controls">
              <div class="control-group">
                <label>K值: {{ kValue }}</label>
                <input type="range" v-model.number="kValue" min="1" max="7" step="2">
              </div>
              <div class="control-group">
                <button @click="generateNewPoint" class="action-btn">生成新点</button>
                <button @click="classifyNewPoint" class="action-btn classify">分类新点</button>
              </div>
              <div class="kneighbors-list" v-if="neighbors.length > 0">
                <div class="list-title">最近的 {{ kValue }} 个邻居:</div>
                <div v-for="(n, i) in neighbors" :key="i" class="neighbor-item">
                  <span class="neighbor-rank">{{ i + 1 }}</span>
                  <span class="neighbor-label">{{ n.label }}</span>
                  <span class="neighbor-category">{{ n.category === 'a' ? 'A类' : 'B类' }}</span>
                  <span class="neighbor-dist">距离: {{ n.distance.toFixed(2) }}</span>
                </div>
              </div>
              <div class="classification-result" v-if="classificationResult">
                分类结果: <strong>{{ classificationResult === 'a' ? 'A类' : 'B类' }}</strong>
              </div>
            </div>
          </div>
        </div>

        <!-- 决策树模拟 -->
        <div v-else-if="activeSim === 'decisiontree'" class="sim-content">
          <div class="sim-description">
            <p><strong>决策树</strong>：通过一系列的是/否问题进行决策，类似于人类做决策的思维过程。</p>
          </div>

          <div class="decision-tree-visual">
            <svg viewBox="0 0 400 300" class="tree-svg">
              <!-- 根节点 -->
              <g class="tree-node root" transform="translate(200, 30)">
                <circle r="25" fill="var(--primary)" />
                <text y="5" text-anchor="middle" fill="white" font-size="12">年龄?</text>
              </g>
              <!-- 边 -->
              <line x1="200" y1="55" x2="120" y2="120" stroke="var(--border)" />
              <line x1="200" y1="55" x2="280" y2="120" stroke="var(--border)" />
              <!-- 第二层 -->
              <g class="tree-node" transform="translate(120, 140)">
                <circle r="22" fill="var(--primary)" opacity="0.8" />
                <text y="4" text-anchor="middle" fill="white" font-size="11">有车?</text>
              </g>
              <g class="tree-node" transform="translate(280, 140)">
                <circle r="22" fill="var(--primary)" opacity="0.8" />
                <text y="4" text-anchor="middle" fill="white" font-size="11">有房?</text>
              </g>
              <!-- 边2 -->
              <line x1="120" y1="162" x2="80" y2="220" stroke="var(--border)" />
              <line x1="120" y1="162" x2="160" y2="220" stroke="var(--border)" />
              <line x1="280" y1="162" x2="240" y2="220" stroke="var(--border)" />
              <line x1="280" y1="162" x2="320" y2="220" stroke="var(--border)" />
              <!-- 叶子节点 -->
              <g class="tree-node leaf" transform="translate(80, 250)">
                <rect x="-20" y="-12" width="40" height="24" rx="4" fill="#22c55e" />
                <text y="4" text-anchor="middle" fill="white" font-size="11">是</text>
              </g>
              <g class="tree-node leaf" transform="translate(160, 250)">
                <rect x="-20" y="-12" width="40" height="24" rx="4" fill="#ef4444" />
                <text y="4" text-anchor="middle" fill="white" font-size="11">否</text>
              </g>
              <g class="tree-node leaf" transform="translate(240, 250)">
                <rect x="-20" y="-12" width="40" height="24" rx="4" fill="#22c55e" />
                <text y="4" text-anchor="middle" fill="white" font-size="11">是</text>
              </g>
              <g class="tree-node leaf" transform="translate(320, 250)">
                <rect x="-20" y="-12" width="40" height="24" rx="4" fill="#ef4444" />
                <text y="4" text-anchor="middle" fill="white" font-size="11">否</text>
              </g>
            </svg>
          </div>

          <div class="decision-controls">
            <div class="control-group">
              <label>年龄:</label>
              <select v-model="testCase.age">
                <option value="young">年轻</option>
                <option value="old">年长</option>
              </select>
            </div>
            <div class="control-group">
              <label>有车:</label>
              <select v-model="testCase.hasCar">
                <option :value="true">是</option>
                <option :value="false">否</option>
              </select>
            </div>
            <div class="control-group">
              <label>有房:</label>
              <select v-model="testCase.hasHouse">
                <option :value="true">是</option>
                <option :value="false">否</option>
              </select>
            </div>
            <button @click="runDecisionTree" class="action-btn classify">决策</button>
          </div>

          <div class="decision-result" v-if="decisionResult">
            决策结果: <strong>{{ decisionResult }}</strong>
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

const activeSim = ref('perceptron')

const simulations = [
  { id: 'perceptron', name: '感知机' },
  { id: 'knn', name: 'K近邻' },
  { id: 'decisiontree', name: '决策树' }
]

// 感知机状态
const inputs = reactive({ x1: 0.5, x2: 0.5 })
const weights = reactive({ w1: 0.5, w2: 0.5, bias: -0.3 })
const trainingLogs = reactive([])
const learningRate = 0.1

const perceptronOutput = computed(() => {
  const raw = inputs.x1 * weights.w1 + inputs.x2 * weights.w2 + weights.bias
  return 1 / (1 + Math.exp(-raw)) // Sigmoid
})

function trainPerceptron() {
  // AND问题的训练数据
  const data = [
    { x1: 0, x2: 0, target: 0 },
    { x1: 0, x2: 1, target: 0 },
    { x1: 1, x2: 0, target: 0 },
    { x1: 1, x2: 1, target: 1 }
  ]

  const sample = data[Math.floor(Math.random() * 4)]
  const input = { x1: sample.x1, x2: sample.x2 }
  inputs.x1 = input.x1
  inputs.x2 = input.x2

  const raw = input.x1 * weights.w1 + input.x2 * weights.w2 + weights.bias
  const output = 1 / (1 + Math.exp(-raw))
  const error = sample.target - output

  weights.w1 += learningRate * error * input.x1
  weights.w2 += learningRate * error * input.x2
  weights.bias += learningRate * error

  trainingLogs.push({
    step: trainingLogs.length + 1,
    x1: input.x1,
    x2: input.x2,
    output,
    target: sample.target
  })

  if (trainingLogs.length > 20) trainingLogs.shift()
}

function resetPerceptron() {
  weights.w1 = 0.5
  weights.w2 = 0.5
  weights.bias = -0.3
  trainingLogs.length = 0
}

// K近邻状态
const kValue = ref(3)
const knnPoints = reactive([
  { x: 20, y: 30, category: 'a', label: 'A1', nearest: false },
  { x: 35, y: 25, category: 'a', label: 'A2', nearest: false },
  { x: 25, y: 45, category: 'a', label: 'A3', nearest: false },
  { x: 70, y: 60, category: 'b', label: 'B1', nearest: false },
  { x: 80, y: 70, category: 'b', label: 'B2', nearest: false },
  { x: 75, y: 80, category: 'b', label: 'B3', nearest: false },
  { x: 60, y: 45, category: 'a', label: 'A4', nearest: false },
  { x: 85, y: 55, category: 'b', label: 'B4', nearest: false }
])
const newPoint = ref(null)
const neighbors = ref([])
const classificationResult = ref('')

function generateNewPoint() {
  knnPoints.forEach(p => p.nearest = false)
  newPoint.value = {
    x: 30 + Math.random() * 40,
    y: 30 + Math.random() * 40
  }
  neighbors.value = []
  classificationResult.value = ''
}

function toggleNearest(idx) {
  knnPoints[idx].nearest = !knnPoints[idx].nearest
}

function classifyNewPoint() {
  if (!newPoint.value) return

  const distances = knnPoints.map(p => ({
    ...p,
    distance: Math.sqrt(Math.pow(p.x - newPoint.value.x, 2) + Math.pow(p.y - newPoint.value.y, 2))
  })).sort((a, b) => a.distance - b.distance)

  neighbors.value = distances.slice(0, kValue.value)

  const categoryCount = { a: 0, b: 0 }
  neighbors.value.forEach(n => categoryCount[n.category]++)
  classificationResult.value = categoryCount.a > categoryCount.b ? 'a' : 'b'

  knnPoints.forEach(p => p.nearest = false)
  neighbors.value.forEach(n => {
    const point = knnPoints.find(p => p.label === n.label)
    if (point) point.nearest = true
  })
}

// 决策树状态
const testCase = reactive({
  age: 'young',
  hasCar: false,
  hasHouse: false
})
const decisionResult = ref('')

function runDecisionTree() {
  // 简化决策: 先看年龄
  if (testCase.age === 'young') {
    // 年轻人看有没车
    decisionResult.value = testCase.hasCar ? '通过' : '不通过'
  } else {
    // 年长者看有没房
    decisionResult.value = testCase.hasHouse ? '通过' : '不通过'
  }
}

// 练习题
const quizzes = reactive([
  {
    question: '人工智能的英文缩写是什么？',
    options: ['AI', 'ML', 'DL', 'NN'],
    answer: 0,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '感知机属于哪种类型的算法？',
    options: ['无监督学习', '监督学习', '强化学习', '迁移学习'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: 'K近邻算法(KNN)是基于什么的算法？',
    options: ['距离度量', '概率统计', '神经网络', '决策边界'],
    answer: 0,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '神经网络中的"隐藏层"位于？',
    options: ['输入层之前', '输入层和输出层之间', '输出层之后', '与输入输出层并列'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '深度学习中使用的主要模型是？',
    options: ['决策树', '支持向量机', '神经网络', '线性回归'],
    answer: 2,
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
.ai-module { padding: 0; }

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

/* AI分支卡片 */
.ai-branches {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
}

.branch-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 16px;
  text-align: center;
}

.branch-icon { font-size: 32px; margin-bottom: 8px; }
.branch-name { font-weight: 600; margin-bottom: 4px; font-size: 13px; }
.branch-desc { font-size: 11px; color: var(--text-muted); }

/* 神经网络图 */
.neural-diagram {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 20px;
  background: var(--bg);
  border-radius: 8px;
  margin-top: 12px;
}

.layer { text-align: center; }
.layer-label { font-size: 11px; color: var(--text-muted); margin-bottom: 8px; }

.neurons { display: flex; flex-direction: column; gap: 8px; }

.neuron {
  width: 50px;
  height: 50px;
  border: 2px solid var(--primary);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 600;
  background: var(--surface);
}

/* 模拟器 */
.sim-tabs { display: flex; gap: 8px; margin-bottom: 16px; }

.sim-tab {
  padding: 8px 16px;
  border: 1px solid var(--border);
  border-radius: 8px;
  background: var(--bg);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}

.sim-tab.active { background: var(--primary); color: white; border-color: var(--primary); }

.sim-content { background: var(--bg); border-radius: var(--radius); padding: 20px; }

.sim-description { margin-bottom: 16px; font-size: 13px; color: var(--text-secondary); }

/* 感知机 */
.perceptron-controls { margin-bottom: 16px; }

.control-group { margin-bottom: 12px; }
.control-group label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 13px; }

.control-group select {
  padding: 8px 12px;
  border: 1px solid var(--border);
  border-radius: 8px;
  font-size: 13px;
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

.weights-display { display: flex; gap: 16px; margin: 12px 0; font-size: 12px; color: var(--text-secondary); }

.train-btn, .reset-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  margin-right: 8px;
}

.train-btn { background: var(--primary); color: white; }
.reset-btn { background: var(--bg); border: 1px solid var(--border); color: var(--text); }

.perceptron-visual {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
  padding: 20px;
  background: var(--surface);
  border-radius: 8px;
  margin-bottom: 16px;
}

.input-display { display: flex; flex-direction: column; gap: 20px; }

.input-node {
  padding: 12px 16px;
  border: 2px solid var(--border);
  border-radius: 8px;
  font-weight: 600;
  font-size: 14px;
  background: var(--bg);
}

.input-node.active { border-color: var(--primary); background: var(--primary-light); }

.synapses { display: flex; flex-direction: column; gap: 30px; }

.synapse {
  padding: 8px 16px;
  background: var(--bg);
  border-radius: 4px;
  text-align: center;
  font-size: 12px;
  color: var(--text-muted);
}

.perceptron-node {
  width: 80px;
  height: 80px;
  border: 3px solid var(--border);
  border-radius: 50%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: var(--surface);
  transition: all 0.3s;
}

.perceptron-node.active { border-color: #22c55e; background: #dcfce7; }

.node-label { font-size: 11px; color: var(--text-muted); }
.node-output { font-size: 14px; font-weight: 700; color: var(--text); }

.training-log {
  background: var(--surface);
  border-radius: 8px;
  padding: 12px;
}

.log-title { font-weight: 600; margin-bottom: 8px; font-size: 12px; }
.log-item { font-size: 11px; padding: 4px 0; border-bottom: 1px solid var(--border); color: var(--text-secondary); }
.log-item:last-child { border-bottom: none; }

/* KNN */
.knn-visual { display: flex; gap: 20px; }

.scatter-plot {
  flex: 1;
  background: var(--surface);
  border-radius: 8px;
  padding: 16px;
  position: relative;
}

.plot-area {
  position: relative;
  height: 300px;
  background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
  border-radius: 8px;
  overflow: hidden;
}

.data-point {
  position: absolute;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  font-weight: 700;
  cursor: pointer;
  transform: translate(-50%, -50%);
  transition: all 0.2s;
}

.data-point.class-a { background: #3b82f6; color: white; }
.data-point.class-b { background: #22c55e; color: white; }
.data-point.nearest { box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.5); transform: translate(-50%, -50%) scale(1.2); }
.data-point.new-point { background: #f59e0b; color: white; }

.plot-legend { display: flex; gap: 16px; margin-top: 12px; justify-content: center; }

.legend-item {
  padding: 4px 12px;
  border-radius: 4px;
  font-size: 12px;
}

.legend-item.class-a { background: #3b82f6; color: white; }
.legend-item.class-b { background: #22c55e; color: white; }

.knn-controls { flex: 1; }

.action-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  margin-right: 8px;
  background: var(--bg);
  border: 1px solid var(--border);
}

.action-btn.classify { background: var(--primary); color: white; border-color: var(--primary); }

.kneighbors-list { margin-top: 16px; }

.list-title { font-weight: 600; font-size: 12px; margin-bottom: 8px; }

.neighbor-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px 8px;
  background: var(--surface);
  border-radius: 6px;
  margin-bottom: 4px;
  font-size: 12px;
}

.neighbor-rank { width: 20px; height: 20px; background: var(--primary); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 10px; }
.neighbor-label { font-weight: 600; min-width: 30px; }
.neighbor-category { flex: 1; }
.neighbor-dist { color: var(--text-muted); }

.classification-result {
  margin-top: 16px;
  padding: 12px;
  background: var(--primary-light);
  border-radius: 8px;
  font-size: 14px;
}

/* 决策树 */
.decision-tree-visual { margin-bottom: 16px; }

.tree-svg { width: 100%; max-width: 400px; margin: 0 auto; display: block; }

.decision-controls { display: flex; gap: 12px; align-items: flex-end; flex-wrap: wrap; }

.decision-result {
  margin-top: 16px;
  padding: 12px;
  background: #dcfce7;
  border-radius: 8px;
  font-size: 14px;
}

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
  .ai-branches { grid-template-columns: repeat(2, 1fr); }
  .knn-visual { flex-direction: column; }
  .quiz-options { grid-template-columns: 1fr; }
}
</style>
