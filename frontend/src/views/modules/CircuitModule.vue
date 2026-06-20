<template>
  <div class="module-content circuit-module">
    <!-- 理论知识区域 -->
    <div class="theory-section">
      <h3 class="section-subtitle">📚 逻辑电路基础</h3>
      <div class="theory-content">
        <p><strong>数字逻辑电路</strong>是计算机硬件的基础，由基本的逻辑门组成，能够实现各种逻辑运算。</p>

        <div class="key-concept">
          <h4>🚪 基本逻辑门</h4>
          <div class="gates-grid">
            <div class="gate-card">
              <div class="gate-symbol">AND</div>
              <div class="gate-desc">与门：所有输入为1时输出1</div>
              <div class="gate-table">
                <div v-for="(row, i) in andTruthTable" :key="i">
                  <span>{{ row.in1 }}</span><span>{{ row.in2 }}</span>=<span>{{ row.out }}</span>
                </div>
              </div>
            </div>
            <div class="gate-card">
              <div class="gate-symbol">OR</div>
              <div class="gate-desc">或门：任一输入为1时输出1</div>
              <div class="gate-table">
                <div v-for="(row, i) in orTruthTable" :key="i">
                  <span>{{ row.in1 }}</span><span>{{ row.in2 }}</span>=<span>{{ row.out }}</span>
                </div>
              </div>
            </div>
            <div class="gate-card">
              <div class="gate-symbol">NOT</div>
              <div class="gate-desc">非门：输入取反</div>
              <div class="gate-table single">
                <div v-for="(row, i) in notTruthTable" :key="i">
                  <span>{{ row.in1 }}</span>=<span>{{ row.out }}</span>
                </div>
              </div>
            </div>
            <div class="gate-card">
              <div class="gate-symbol">NAND</div>
              <div class="gate-desc">与非门：AND的取反</div>
              <div class="gate-table">
                <div v-for="(row, i) in nandTruthTable" :key="i">
                  <span>{{ row.in1 }}</span><span>{{ row.in2 }}</span>=<span>{{ row.out }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="key-concept">
          <h4>🔧 复合逻辑门</h4>
          <ul>
            <li><strong>与非门（NAND）</strong>：万能门，可组合实现所有其他逻辑门</li>
            <li><strong>或非门（NOR）</strong>：也是万能门</li>
            <li><strong>异或门（XOR）</strong>：输入不同时输出1</li>
            <li><strong>同或门（XNOR）</strong>：输入相同时输出1</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- 交互式模拟器区域 -->
    <div class="simulator-section">
      <h3 class="section-subtitle">🎮 组合逻辑电路模拟器</h3>

      <div class="simulator-container">
        <!-- 电路设计区域 -->
        <div class="circuit-workspace">
          <div class="workspace-header">
            <span>电路工作台</span>
            <div class="workspace-tools">
              <button
                v-for="gate in gateTypes"
                :key="gate.id"
                :class="['tool-btn', { active: selectedTool === gate.id }]"
                @click="selectedTool = gate.id"
                :title="gate.name"
              >
                {{ gate.label }}
              </button>
              <button @click="deleteMode = !deleteMode" :class="['tool-btn', 'delete-btn', { active: deleteMode }]">
                删除
              </button>
              <button @click="clearCircuit" class="tool-btn">清空</button>
            </div>
          </div>

          <div class="circuit-board" @click="handleBoardClick" ref="boardRef">
            <!-- 网格背景 -->
            <div class="grid-bg"></div>

            <!-- 输入开关 -->
            <div
              v-for="(input, idx) in inputs"
              :key="'input-' + idx"
              class="circuit-input"
              :style="{ top: (80 + idx * 80) + 'px', left: '60px' }"
              @click.stop="toggleInput(idx)"
            >
              <div class="input-switch" :class="{ on: input.value }">
                <span class="switch-label">{{ input.label }}</span>
                <span class="switch-value">{{ input.value ? '1' : '0' }}</span>
              </div>
            </div>

            <!-- 已放置的元件 -->
            <div
              v-for="(component, idx) in circuitComponents"
              :key="'comp-' + idx"
              class="circuit-component"
              :class="[component.type, { selected: selectedComponent === idx, delete: deleteMode }]"
              :style="{ top: component.y + 'px', left: component.x + 'px' }"
              @click.stop="handleComponentClick(idx)"
            >
              <div class="component-label">{{ getGateLabel(component.type) }}</div>
              <div class="component-output">{{ component.output ? '1' : '0' }}</div>
            </div>

            <!-- 输出指示灯 -->
            <div
              v-for="(output, idx) in outputs"
              :key="'output-' + idx"
              class="circuit-output"
              :style="{ top: (80 + idx * 80) + 'px', right: '60px' }"
            >
              <div class="output-led" :class="{ on: output.value }">
                <span class="output-label">{{ output.label }}</span>
                <span class="output-value">{{ output.value ? '1' : '0' }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 真值表显示 -->
        <div class="truth-table-section">
          <div class="section-title">📋 真值表</div>
          <table class="truth-table">
            <thead>
              <tr>
                <th v-for="input in inputs" :key="input.label">{{ input.label }}</th>
                <th v-for="output in outputs" :key="output.label" class="output-col">{{ output.label }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(row, idx) in truthTableRows" :key="idx">
                <td v-for="input in inputs" :key="'i-' + input.label">{{ row.inputs[input.label] }}</td>
                <td v-for="output in outputs" :key="'o-' + output.label" class="output-col">{{ row.outputs[output.label] }}</td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- 预设电路 -->
        <div class="preset-circuits">
          <div class="section-title">🔧 预设电路</div>
          <div class="preset-buttons">
            <button @click="loadPreset('half-adder')" class="preset-btn">半加器</button>
            <button @click="loadPreset('full-adder')" class="preset-btn">全加器</button>
            <button @click="loadPreset('xor-gate')" class="preset-btn">异或门</button>
            <button @click="loadPreset('mux-2to1')" class="preset-btn">2选1多路复用器</button>
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

// 门类型
const gateTypes = [
  { id: 'AND', label: 'AND', name: '与门' },
  { id: 'OR', label: 'OR', name: '或门' },
  { id: 'NOT', label: 'NOT', name: '非门' },
  { id: 'NAND', label: 'NAND', name: '与非门' },
  { id: 'NOR', label: 'NOR', name: '或非门' },
  { id: 'XOR', label: 'XOR', name: '异或门' }
]

// 真值表
const andTruthTable = [
  { in1: 0, in2: 0, out: 0 },
  { in1: 0, in2: 1, out: 0 },
  { in1: 1, in2: 0, out: 0 },
  { in1: 1, in2: 1, out: 1 }
]

const orTruthTable = [
  { in1: 0, in2: 0, out: 0 },
  { in1: 0, in2: 1, out: 1 },
  { in1: 1, in2: 0, out: 1 },
  { in1: 1, in2: 1, out: 1 }
]

const notTruthTable = [
  { in1: 0, out: 1 },
  { in1: 1, out: 0 }
]

const nandTruthTable = [
  { in1: 0, in2: 0, out: 1 },
  { in1: 0, in2: 1, out: 1 },
  { in1: 1, in2: 0, out: 1 },
  { in1: 1, in2: 1, out: 0 }
]

// 状态
const selectedTool = ref('AND')
const deleteMode = ref(false)
const selectedComponent = ref(null)
const circuitComponents = ref([])
const boardRef = ref(null)

// 输入输出
const inputs = reactive([
  { label: 'A', value: 0 },
  { label: 'B', value: 0 }
])

const outputs = reactive([
  { label: 'Y', value: 0 }
])

function getGateLabel(type) {
  return gateTypes.find(g => g.id === type)?.label || type
}

function toggleInput(index) {
  inputs[index].value = inputs[index].value ? 0 : 1
  simulateCircuit()
}

function handleBoardClick(event) {
  if (deleteMode.value) return

  const rect = boardRef.value.getBoundingClientRect()
  const x = event.clientX - rect.left - 30
  const y = event.clientY - rect.top - 20

  if (x > 100 && x < rect.width - 150) {
    circuitComponents.value.push({
      type: selectedTool.value,
      x,
      y,
      inputs: [],
      output: 0
    })
    simulateCircuit()
  }
}

function handleComponentClick(idx) {
  if (deleteMode.value) {
    circuitComponents.value.splice(idx, 1)
    simulateCircuit()
  } else {
    selectedComponent.value = selectedComponent.value === idx ? null : idx
  }
}

function clearCircuit() {
  circuitComponents.value = []
  selectedComponent.value = null
  simulateCircuit()
}

// 模拟逻辑门
function simulateGate(type, a, b = 0) {
  switch (type) {
    case 'AND': return a && b
    case 'OR': return a || b
    case 'NOT': return a ? 0 : 1
    case 'NAND': return (a && b) ? 0 : 1
    case 'NOR': return (a || b) ? 0 : 1
    case 'XOR': return a !== b
    default: return 0
  }
}

// 简化的电路模拟
function simulateCircuit() {
  // 简化版：假设组件直接连接到输入和输出
  if (circuitComponents.value.length === 0) {
    outputs[0].value = 0
    return
  }

  // 第一个组件使用输入A和B
  let result = 0
  if (circuitComponents.value.length > 0) {
    const comp = circuitComponents.value[0]
    result = simulateGate(comp.type, inputs[0].value, inputs[1]?.value || 0)
  }

  // 最后一个组件决定输出
  if (circuitComponents.value.length > 1) {
    const lastComp = circuitComponents.value[circuitComponents.value.length - 1]
    result = simulateGate(lastComp.type, result, 0)
  }

  outputs[0].value = result
}

// 真值表
const truthTableRows = computed(() => {
  const rows = []
  const numInputs = inputs.length
  const numCombinations = Math.pow(2, numInputs)

  for (let i = 0; i < numCombinations; i++) {
    const row = { inputs: {}, outputs: {} }
    inputs.forEach((input, idx) => {
      row.inputs[input.label] = (i >> (numInputs - 1 - idx)) & 1
    })

    // 模拟当前电路
    const tempInputs = [...inputs]
    tempInputs.forEach((inp, idx) => {
      inp.value = row.inputs[inp.label]
    })
    simulateCircuit()

    outputs.forEach(output => {
      row.outputs[output.label] = output.value
    })

    rows.push(row)
  }

  return rows
})

// 预设电路
function loadPreset(preset) {
  circuitComponents.value = []
  selectedComponent.value = null

  switch (preset) {
    case 'half-adder':
      // 半加器: XOR输出S, AND输出C
      inputs[0].label = 'A'
      inputs[1].label = 'B'
      outputs[0].label = 'S'
      circuitComponents.value.push({ type: 'XOR', x: 300, y: 60, output: 0 })
      circuitComponents.value.push({ type: 'AND', x: 300, y: 140, output: 0 })
      break
    case 'full-adder':
      // 全加器简化版
      inputs[0].label = 'A'
      inputs[1].label = 'B'
      circuitComponents.value.push({ type: 'XOR', x: 300, y: 50, output: 0 })
      circuitComponents.value.push({ type: 'AND', x: 450, y: 50, output: 0 })
      break
    case 'xor-gate':
      // 异或门用NAND实现
      inputs[0].label = 'A'
      inputs[1].label = 'B'
      circuitComponents.value.push({ type: 'NAND', x: 280, y: 60, output: 0 })
      circuitComponents.value.push({ type: 'NAND', x: 280, y: 140, output: 0 })
      circuitComponents.value.push({ type: 'NAND', x: 420, y: 100, output: 0 })
      break
    case 'mux-2to1':
      // 2选1多路复用器
      inputs[0].label = 'D0'
      inputs[1].label = 'D1'
      circuitComponents.value.push({ type: 'AND', x: 280, y: 60, output: 0 })
      circuitComponents.value.push({ type: 'AND', x: 280, y: 140, output: 0 })
      circuitComponents.value.push({ type: 'OR', x: 420, y: 100, output: 0 })
      break
  }

  simulateCircuit()
}

// 练习题
const quizzes = reactive([
  {
    question: 'AND门的输出在什么情况下为1？',
    options: ['任一输入为1', '所有输入为1', '所有输入为0', '输入取反'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: 'NAND门是哪两个门的组合？',
    options: ['AND + NOT', 'OR + NOT', 'NOT + OR', 'XOR + AND'],
    answer: 0,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '异或门(XOR)的输出在什么情况下为1？',
    options: ['所有输入为1', '所有输入为0', '输入不同时', '输入相同时'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '半加器可以输出哪两个结果？',
    options: ['S(和)和C(进位)', 'A和B', '0和1', '与非和或非'],
    answer: 0,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '为什么说NAND门是"万能门"？',
    options: ['速度最快', '成本最低', '可以组合实现所有其他逻辑门', '功耗最低'],
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
.circuit-module { padding: 0; }

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

.key-concept h4 { color: var(--primary); margin-bottom: 12px; }

/* 门卡片 */
.gates-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
}

.gate-card {
  background: var(--bg);
  border-radius: 8px;
  padding: 12px;
  text-align: center;
}

.gate-symbol {
  background: var(--primary);
  color: white;
  padding: 6px 12px;
  border-radius: 6px;
  font-weight: 700;
  font-size: 14px;
  margin-bottom: 8px;
}

.gate-desc { font-size: 12px; color: var(--text-secondary); margin-bottom: 8px; }

.gate-table {
  display: flex;
  flex-direction: column;
  gap: 2px;
  font-family: monospace;
  font-size: 11px;
}

.gate-table div {
  display: flex;
  justify-content: center;
  gap: 4px;
}

.gate-table span { width: 20px; }
.gate-table.single { align-items: center; }

/* 模拟器 */
.circuit-workspace {
  background: var(--bg);
  border-radius: var(--radius);
  margin-bottom: 16px;
  overflow: hidden;
}

.workspace-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: var(--surface);
  border-bottom: 1px solid var(--border);
  font-weight: 600;
}

.workspace-tools { display: flex; gap: 8px; }

.tool-btn {
  padding: 6px 12px;
  border: 1px solid var(--border);
  border-radius: 6px;
  background: var(--bg);
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.tool-btn:hover { border-color: var(--primary); }
.tool-btn.active { background: var(--primary); color: white; border-color: var(--primary); }
.tool-btn.delete-btn.active { background: #dc2626; border-color: #dc2626; }

.circuit-board {
  position: relative;
  height: 300px;
  cursor: crosshair;
  overflow: hidden;
}

.grid-bg {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(var(--border) 1px, transparent 1px),
    linear-gradient(90deg, var(--border) 1px, transparent 1px);
  background-size: 20px 20px;
  opacity: 0.5;
}

/* 元件样式 */
.circuit-input, .circuit-output {
  position: absolute;
  z-index: 10;
}

.input-switch, .output-led {
  width: 60px;
  padding: 8px 12px;
  border-radius: 8px;
  text-align: center;
  font-weight: 600;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}

.input-switch {
  background: var(--surface);
  border: 2px solid var(--border);
}

.input-switch.on {
  background: #dcfce7;
  border-color: #22c55e;
}

.output-led {
  background: var(--surface);
  border: 2px solid var(--border);
}

.output-led.on {
  background: #fecaca;
  border-color: #ef4444;
  box-shadow: 0 0 10px rgba(239, 68, 68, 0.5);
}

.switch-label, .output-label { display: block; font-size: 11px; color: var(--text-muted); }
.switch-value, .output-value { font-size: 16px; }

.circuit-component {
  position: absolute;
  width: 60px;
  height: 50px;
  background: var(--surface);
  border: 2px solid var(--border);
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}

.circuit-component:hover { border-color: var(--primary); }
.circuit-component.selected { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(66, 133, 244, 0.3); }
.circuit-component.delete:hover { border-color: #dc2626; background: #fee2e2; }

.component-label {
  font-size: 11px;
  font-weight: 700;
  color: var(--primary);
}

.component-output {
  font-size: 14px;
  font-weight: 600;
  color: var(--text);
}

/* 真值表 */
.truth-table-section { margin-bottom: 16px; }
.section-title { font-weight: 600; margin-bottom: 12px; color: var(--text); }

.truth-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.truth-table th, .truth-table td {
  padding: 8px 12px;
  border: 1px solid var(--border);
  text-align: center;
}

.truth-table th { background: var(--bg); font-weight: 600; }
.truth-table .output-col { background: #fef3c7; }

/* 预设按钮 */
.preset-buttons { display: flex; flex-wrap: wrap; gap: 8px; }

.preset-btn {
  padding: 8px 16px;
  border: 1px solid var(--border);
  border-radius: 8px;
  background: var(--bg);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}

.preset-btn:hover { border-color: var(--primary); background: var(--primary-light); }

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
  .gates-grid { grid-template-columns: repeat(2, 1fr); }
  .quiz-options { grid-template-columns: 1fr; }
}
</style>
