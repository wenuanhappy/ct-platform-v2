<template>
  <div class="turing-module">
    <!-- 控制面板 -->
    <div class="control-panel">
      <div class="control-row">
        <div class="control-group">
          <label>预设程序：</label>
          <select v-model="selectedProgram" @change="loadProgram">
            <option value="binary-increment">二进制加1</option>
            <option value="copy">复制字符串</option>
            <option value="palindrome">回文检测</option>
            <option value="custom">自定义指令</option>
          </select>
        </div>
        <div class="speed-control">
          <label>速度：</label>
          <input type="range" v-model="speed" min="100" max="2000" step="100">
          <span>{{ 2100 - speed }}ms</span>
        </div>
      </div>
      <div class="control-buttons">
        <button @click="resetSimulator" class="btn-control btn-reset">重置</button>
        <button @click="stepExecute" class="btn-control btn-step" :disabled="isRunning">单步</button>
        <button @click="autoRun" class="btn-control btn-run" :disabled="isRunning">{{ isRunning ? '运行中...' : '自动运行' }}</button>
        <button @click="stopRun" class="btn-control btn-stop" :disabled="!isRunning">停止</button>
      </div>
    </div>

    <!-- 状态栏 -->
    <div class="state-bar">
      <div class="state-item">
        <span class="state-label">状态</span>
        <span class="state-value" :class="currentState">{{ currentState }}</span>
      </div>
      <div class="state-item">
        <span class="state-label">读取</span>
        <span class="state-value">{{ tape[headPosition] }}</span>
      </div>
      <div class="state-item">
        <span class="state-label">步数</span>
        <span class="state-value">{{ stepCount }}</span>
      </div>
      <div class="state-item">
        <span class="state-label">结果</span>
        <span class="state-value" :class="executionResult">{{ executionMessage }}</span>
      </div>
    </div>

    <!-- 纸带显示 -->
    <div class="tape-section">
      <div class="tape-header">
        <span class="tape-label">📍 纸带 Tape</span>
        <span class="head-position">读写头位置: {{ headPosition }}</span>
      </div>
      <div class="tape-viewport">
        <div class="tape" :style="{ transform: `translateX(${-headPosition * cellWidth + 150}px)` }">
          <div
            v-for="(cell, index) in tape"
            :key="index"
            class="tape-cell"
            :class="{ active: index === headPosition, visited: visitedCells.includes(index) }"
          >
            <div class="cell-index">{{ index }}</div>
            <div class="cell-value">{{ cell }}</div>
          </div>
        </div>
      </div>
      <div class="head-indicator">
        <span class="head-arrow">▼</span>
      </div>
    </div>

    <!-- 当前指令 -->
    <div class="instruction-panel" v-if="currentInstruction">
      <div class="instruction-label">当前指令</div>
      <div class="instruction-content">
        <span class="instr-part">状态 <strong>{{ currentInstruction.currentState }}</strong></span>
        <span class="instr-op">+</span>
        <span class="instr-part">读 <strong>{{ currentInstruction.readSymbol }}</strong></span>
        <span class="instr-op">→</span>
        <span class="instr-part">写 <strong>{{ currentInstruction.writeSymbol }}</strong></span>
        <span class="instr-op">,</span>
        <span class="instr-part">移动 <strong>{{ currentInstruction.moveDirection === 'L' ? '左' : currentInstruction.moveDirection === 'R' ? '右' : '停' }}</strong></span>
        <span class="instr-op">,</span>
        <span class="instr-part">新状态 <strong>{{ currentInstruction.nextState }}</strong></span>
      </div>
    </div>

    <!-- 自定义指令编辑 -->
    <div class="rules-editor" v-if="selectedProgram === 'custom'">
      <div class="editor-header">
        <span>📝 指令编辑</span>
        <button @click="addRule" class="btn-add">+ 添加</button>
      </div>
      <div class="rules-list">
        <div class="rule-row" v-for="(rule, index) in customRules" :key="index">
          <input v-model="rule.state" placeholder="状态" class="rule-input">
          <span class="rule-op">+</span>
          <input v-model="rule.read" placeholder="读" class="rule-input rule-sm">
          <span class="rule-op">→</span>
          <input v-model="rule.write" placeholder="写" class="rule-input rule-sm">
          <span class="rule-op">,</span>
          <select v-model="rule.move" class="rule-select">
            <option value="L">左</option>
            <option value="R">右</option>
            <option value="S">停</option>
          </select>
          <span class="rule-op">,</span>
          <input v-model="rule.nextState" placeholder="新状态" class="rule-input">
          <button @click="removeRule(index)" class="btn-del">×</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onUnmounted } from 'vue'

const cellWidth = 60
const tapeLength = 31
const initialPosition = 15

const tape = ref(Array(tapeLength).fill('B'))
const headPosition = ref(initialPosition)
const currentState = ref('q0')
const stepCount = ref(0)
const visitedCells = ref([])
const isRunning = ref(false)
const currentInstruction = ref(null)
const speed = ref(500)
const selectedProgram = ref('binary-increment')
const executionResult = ref('')
const executionMessage = ref('就绪')

const customRules = reactive([
  { state: 'q0', read: '0', write: '0', move: 'R', nextState: 'q0' },
  { state: 'q0', read: '1', write: '1', move: 'R', nextState: 'q0' },
  { state: 'q0', read: 'B', write: 'B', move: 'S', nextState: 'halt' }
])

const programs = {
  'binary-increment': {
    initialTape: '00000111B'.split('').map((c, i) => i < 9 ? c : 'B'),
    rules: [
      { state: 'q0', read: '0', write: '0', move: 'R', nextState: 'q0' },
      { state: 'q0', read: '1', write: '1', move: 'R', nextState: 'q0' },
      { state: 'q0', read: 'B', write: 'B', move: 'L', nextState: 'q1' },
      { state: 'q1', read: '0', write: '1', move: 'S', nextState: 'halt' },
      { state: 'q1', read: '1', write: '0', move: 'L', nextState: 'q1' },
      { state: 'q1', read: 'B', write: '1', move: 'S', nextState: 'halt' }
    ],
    initialState: 'q0',
    initialPosition: 0
  },
  'copy': {
    initialTape: 'XXABY'.split('').map((c, i) => c),
    rules: [
      { state: 'q0', read: 'X', write: 'X', move: 'R', nextState: 'q0' },
      { state: 'q0', read: 'A', write: 'A', move: 'R', nextState: 'q0' },
      { state: 'q0', read: 'B', write: 'B', move: 'R', nextState: 'q0' },
      { state: 'q0', read: 'Y', write: 'Y', move: 'L', nextState: 'q1' },
      { state: 'q0', read: 'B', write: 'B', move: 'L', nextState: 'q1' },
      { state: 'q1', read: 'A', write: 'X', move: 'R', nextState: 'q2' },
      { state: 'q1', read: 'B', write: 'B', move: 'S', nextState: 'halt' },
      { state: 'q2', read: 'A', write: 'A', move: 'R', nextState: 'q2' },
      { state: 'q2', read: 'B', write: 'A', move: 'R', nextState: 'q3' },
      { state: 'q3', read: 'B', write: 'B', move: 'L', nextState: 'q1' }
    ],
    initialState: 'q0',
    initialPosition: 0
  },
  'palindrome': {
    initialTape: '011010B'.split('').map((c, i) => c),
    rules: [
      { state: 'q0', read: '0', write: 'X', move: 'R', nextState: 'q1' },
      { state: 'q0', read: '1', write: 'X', move: 'R', nextState: 'q1' },
      { state: 'q0', read: 'B', write: 'B', move: 'S', nextState: 'accept' },
      { state: 'q1', read: '0', write: '0', move: 'R', nextState: 'q1' },
      { state: 'q1', read: '1', write: '1', move: 'R', nextState: 'q1' },
      { state: 'q1', read: 'B', write: 'B', move: 'L', nextState: 'q2' },
      { state: 'q2', read: '0', write: '0', move: 'L', nextState: 'q2' },
      { state: 'q2', read: '1', write: '1', move: 'L', nextState: 'q2' },
      { state: 'q2', read: 'X', write: 'X', move: 'R', nextState: 'q0' }
    ],
    initialState: 'q0',
    initialPosition: 0
  }
}

const currentRules = computed(() => {
  if (selectedProgram.value === 'custom') return customRules
  return programs[selectedProgram.value]?.rules || []
})

let runInterval = null

function loadProgram() {
  resetSimulator()
  if (selectedProgram.value !== 'custom' && programs[selectedProgram.value]) {
    const program = programs[selectedProgram.value]
    tape.value = [...program.initialTape, ...Array(tapeLength - program.initialTape.length).fill('B')]
    headPosition.value = program.initialPosition
    currentState.value = program.initialState
  }
}

function stepExecute() {
  if (isRunning.value) return
  const currentSymbol = tape.value[headPosition.value]
  const rule = currentRules.value.find(r => r.state === currentState.value && r.read === currentSymbol)

  if (!rule || rule.nextState === 'halt' || rule.nextState === 'accept' || rule.nextState === 'reject') {
    executionResult.value = 'halted'
    executionMessage.value = rule?.nextState === 'accept' ? '接受' : rule?.nextState === 'reject' ? '拒绝' : '完成'
    isRunning.value = false
    return
  }

  currentInstruction.value = rule
  tape.value[headPosition.value] = rule.write
  currentState.value = rule.nextState

  if (rule.move === 'L') {
    if (headPosition.value > 0) headPosition.value--
  } else if (rule.move === 'R') {
    if (headPosition.value < tapeLength - 1) headPosition.value++
  }

  visitedCells.value.push(headPosition.value)
  stepCount.value++
}

function autoRun() {
  if (isRunning.value) return
  isRunning.value = true
  executionResult.value = 'running'
  executionMessage.value = '运行中'
  runInterval = setInterval(() => {
    stepExecute()
    if (executionResult.value === 'halted') stopRun()
  }, 2100 - speed.value)
}

function stopRun() {
  if (runInterval) { clearInterval(runInterval); runInterval = null }
  isRunning.value = false
}

function resetSimulator() {
  stopRun()
  tape.value = Array(tapeLength).fill('B')
  headPosition.value = initialPosition
  currentState.value = 'q0'
  stepCount.value = 0
  visitedCells.value = []
  currentInstruction.value = null
  executionResult.value = ''
  executionMessage.value = '就绪'
}

function addRule() {
  customRules.push({ state: 'q0', read: '0', write: '0', move: 'R', nextState: 'q0' })
}

function removeRule(index) {
  customRules.splice(index, 1)
}

loadProgram()

onUnmounted(() => stopRun())
</script>

<style scoped>
.turing-module {
  padding: 16px;
  background: var(--bg);
  min-height: 100%;
}

/* 控制面板 */
.control-panel {
  background: var(--surface);
  border-radius: var(--radius);
  padding: 14px;
  margin-bottom: 14px;
}

.control-row {
  display: flex;
  gap: 16px;
  margin-bottom: 12px;
  flex-wrap: wrap;
}

.control-group {
  flex: 1;
  min-width: 150px;
}

.control-group label {
  display: block;
  font-size: 12px;
  color: var(--text-secondary);
  margin-bottom: 4px;
}

.control-group select {
  width: 100%;
  padding: 8px 10px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 13px;
  background: var(--bg);
}

.speed-control {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
  min-width: 200px;
}

.speed-control label {
  font-size: 12px;
  color: var(--text-secondary);
  white-space: nowrap;
}

.speed-control input[type="range"] {
  flex: 1;
}

.speed-control span {
  font-size: 12px;
  color: var(--text-muted);
  min-width: 45px;
}

.control-buttons {
  display: flex;
  gap: 8px;
}

.btn-control {
  flex: 1;
  padding: 8px 12px;
  border: none;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-reset { background: #e5e7eb; color: #374151; }
.btn-step { background: #dbeafe; color: #1d4ed8; }
.btn-run { background: #dcfce7; color: #166534; }
.btn-stop { background: #fee2e2; color: #dc2626; }
.btn-control:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-control:hover:not(:disabled) { transform: translateY(-1px); }

/* 状态栏 */
.state-bar {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 10px;
  margin-bottom: 14px;
}

.state-item {
  background: var(--surface);
  padding: 10px 12px;
  border-radius: var(--radius);
  text-align: center;
}

.state-label {
  display: block;
  font-size: 11px;
  color: var(--text-muted);
  margin-bottom: 4px;
}

.state-value {
  font-size: 14px;
  font-weight: 700;
  color: var(--text);
}

.state-value.running { color: #166534; }
.state-value.halted { color: #dc2626; }
.state-value.q0, .state-value.q1, .state-value.q2, .state-value.q3 { color: var(--primary); }

/* 纸带 */
.tape-section {
  background: var(--surface);
  border-radius: var(--radius);
  padding: 14px;
  margin-bottom: 14px;
}

.tape-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.tape-label {
  font-size: 13px;
  font-weight: 600;
  color: var(--text);
}

.head-position {
  font-size: 11px;
  color: var(--text-secondary);
}

.tape-viewport {
  overflow-x: auto;
  padding: 8px 0;
}

.tape {
  display: flex;
  transition: transform 0.3s ease;
  min-width: max-content;
}

.tape-cell {
  width: 56px;
  height: 56px;
  border: 2px solid var(--border);
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: var(--surface);
  transition: all 0.2s;
  margin: 0 2px;
  flex-shrink: 0;
}

.tape-cell.active {
  border-color: var(--primary);
  background: var(--primary-light);
  transform: scale(1.05);
}

.tape-cell.visited {
  background: #fef3c7;
}

.cell-index {
  font-size: 9px;
  color: var(--text-muted);
}

.cell-value {
  font-size: 16px;
  font-weight: 700;
  color: var(--text);
}

.head-indicator {
  text-align: center;
  margin-top: 6px;
}

.head-arrow {
  color: var(--primary);
  font-size: 16px;
}

/* 当前指令 */
.instruction-panel {
  background: #dbeafe;
  border-radius: var(--radius);
  padding: 12px;
  margin-bottom: 14px;
}

.instruction-label {
  font-size: 11px;
  color: var(--primary);
  font-weight: 600;
  margin-bottom: 6px;
}

.instruction-content {
  font-size: 13px;
  color: var(--text);
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  align-items: center;
}

.instr-part strong {
  color: var(--primary);
}

.instr-op {
  color: var(--primary);
  font-weight: 600;
}

/* 规则编辑 */
.rules-editor {
  background: var(--surface);
  border-radius: var(--radius);
  padding: 14px;
}

.editor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
  font-size: 13px;
  font-weight: 600;
  color: var(--text);
}

.btn-add {
  background: var(--primary-light);
  color: var(--primary);
  border: none;
  border-radius: 4px;
  padding: 4px 10px;
  cursor: pointer;
  font-size: 12px;
}

.rules-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.rule-row {
  display: flex;
  align-items: center;
  gap: 4px;
  flex-wrap: wrap;
}

.rule-input {
  padding: 6px 8px;
  border: 1px solid var(--border);
  border-radius: 4px;
  width: 50px;
  font-size: 12px;
}

.rule-input.rule-sm { width: 36px; }

.rule-select {
  padding: 6px 8px;
  border: 1px solid var(--border);
  border-radius: 4px;
  font-size: 12px;
}

.rule-op {
  color: var(--primary);
  font-weight: 600;
  font-size: 12px;
}

.btn-del {
  background: #fee2e2;
  color: #dc2626;
  border: none;
  border-radius: 50%;
  width: 22px;
  height: 22px;
  cursor: pointer;
  font-size: 14px;
  line-height: 1;
}
</style>
