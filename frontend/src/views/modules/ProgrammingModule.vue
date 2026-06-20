<template>
  <div class="module-content programming-module">
    <!-- 理论知识区域 -->
    <div class="theory-section">
      <h3 class="section-subtitle">📚 程序设计基础</h3>
      <div class="theory-content">
        <p><strong>程序设计</strong>是使用编程语言表达算法解决问题的过程。掌握程序设计的基本概念和思维方法，是成为优秀程序员的基础。</p>

        <div class="key-concept">
          <h4>🧱 程序设计基础概念</h4>
          <ul>
            <li><strong>变量与数据类型</strong>：存储数据的容器，如整数、浮点数、字符串等</li>
            <li><strong>控制结构</strong>：顺序执行、条件分支（if/else）、循环（for/while）</li>
            <li><strong>函数</strong>：封装可复用的代码块，提高代码组织性和可维护性</li>
            <li><strong>数据结构</strong>：数组、链表、栈、队列、树等组织和存储数据的方式</li>
          </ul>
        </div>

        <div class="key-concept">
          <h4>🔄 程序执行流程</h4>
          <div class="flow-diagram">
            <div class="flow-step">开始</div>
            <div class="flow-arrow">↓</div>
            <div class="flow-step">输入数据</div>
            <div class="flow-arrow">↓</div>
            <div class="flow-step">处理/计算</div>
            <div class="flow-arrow">↓</div>
            <div class="flow-step">输出结果</div>
            <div class="flow-arrow">↓</div>
            <div class="flow-step">结束</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 交互式模拟器区域 -->
    <div class="simulator-section">
      <h3 class="section-subtitle">🎮 程序执行追踪器</h3>

      <div class="simulator-container">
        <!-- 代码编辑器 -->
        <div class="code-editor-section">
          <div class="editor-header">
            <span>代码编辑器</span>
            <select v-model="selectedLanguage" class="lang-select">
              <option value="javascript">JavaScript</option>
              <option value="python">Python</option>
              <option value="java">Java</option>
            </select>
          </div>
          <div class="code-editor">
            <div class="line-numbers">
              <div v-for="n in codeLines" :key="n" class="line-num">{{ n }}</div>
            </div>
            <textarea
              v-model="code"
              @input="updateLineNumbers"
              @keydown.tab.prevent="handleTab"
              class="code-textarea"
              spellcheck="false"
              placeholder="在这里输入代码..."
            ></textarea>
          </div>
        </div>

        <!-- 控制按钮 -->
        <div class="control-bar">
          <div class="control-left">
            <button @click="runCode" class="ctrl-btn run" :disabled="isRunning">
              ▶ {{ isRunning ? '运行中...' : '运行代码' }}
            </button>
            <button @click="stepRun" class="ctrl-btn step" :disabled="isRunning">⏭ 单步执行</button>
            <button @click="resetCode" class="ctrl-btn reset">↺ 重置</button>
          </div>
          <div class="control-right">
            <button @click="loadExample" class="ctrl-btn example">📝 加载示例</button>
          </div>
        </div>

        <!-- 执行结果 -->
        <div class="execution-area">
          <!-- 变量表 -->
          <div class="variables-panel">
            <div class="panel-header">📊 变量状态</div>
            <div class="variables-list">
              <div v-for="(value, name) in variables" :key="name" class="var-item">
                <span class="var-name">{{ name }}</span>
                <span class="var-type">{{ typeof value }}</span>
                <span class="var-value">{{ formatValue(value) }}</span>
              </div>
              <div v-if="Object.keys(variables).length === 0" class="empty-msg">
                暂无变量数据
              </div>
            </div>
          </div>

          <!-- 输出 -->
          <div class="output-panel">
            <div class="panel-header">📤 输出</div>
            <div class="output-content">
              <div v-for="(line, idx) in output" :key="idx" class="output-line" :class="{ error: line.type === 'error' }">
                {{ line.text }}
              </div>
              <div v-if="output.length === 0" class="empty-msg">
                控制台输出将显示在这里
              </div>
            </div>
          </div>

          <!-- 堆栈跟踪 -->
          <div class="stack-panel">
            <div class="panel-header">🔍 执行跟踪</div>
            <div class="stack-content">
              <div v-for="(step, idx) in executionTrace" :key="idx" class="trace-item" :class="{ current: idx === currentTraceIndex }">
                <span class="trace-line">行 {{ step.line }}</span>
                <span class="trace-code">{{ step.code }}</span>
                <span class="trace-result">{{ step.result }}</span>
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

const code = ref(`// 计算 1 到 10 的和
let sum = 0;
for (let i = 1; i <= 10; i++) {
  sum += i;
  console.log("i =", i, "sum =", sum);
}
console.log("最终结果:", sum);`)

const selectedLanguage = ref('javascript')
const isRunning = ref(false)
const variables = reactive({})
const output = reactive([])
const executionTrace = reactive([])
const currentTraceIndex = ref(-1)
const codeLines = ref(1)

const examples = {
  javascript: `// 计算 1 到 10 的和
let sum = 0;
for (let i = 1; i <= 10; i++) {
  sum += i;
  console.log("i =", i, "sum =", sum);
}
console.log("最终结果:", sum);`,

  python: `# 计算 1 到 10 的和
sum = 0
for i in range(1, 11):
    sum += i
    print(f"i = {i}, sum = {sum}")
print(f"最终结果: {sum}")`,

  java: `// 计算 1 到 10 的和
public class Sum {
    public static void main(String[] args) {
        int sum = 0;
        for (int i = 1; i <= 10; i++) {
            sum += i;
            System.out.println("i = " + i + ", sum = " + sum);
        }
        System.out.println("最终结果: " + sum);
    }
}`
}

function updateLineNumbers() {
  codeLines.value = code.value.split('\n').length
}

function handleTab(e) {
  const textarea = e.target
  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  code.value = code.value.substring(0, start) + '  ' + code.value.substring(end)
  setTimeout(() => {
    textarea.selectionStart = textarea.selectionEnd = start + 2
  }, 0)
}

function loadExample() {
  code.value = examples[selectedLanguage.value]
  updateLineNumbers()
}

function resetCode() {
  output.length = 0
  Object.keys(variables).forEach(k => delete variables[k])
  executionTrace.length = 0
  currentTraceIndex.value = -1
  isRunning.value = false
}

function formatValue(value) {
  if (typeof value === 'string') return `"${value}"`
  if (typeof value === 'object' && value !== null) return JSON.stringify(value)
  return String(value)
}

function parseAndExecute(codeText) {
  output.length = 0
  executionTrace.length = 0
  Object.keys(variables).forEach(k => delete variables[k])
  currentTraceIndex.value = -1

  const lines = codeText.split('\n')
  const consoleLog = (...args) => {
    output.push({ text: args.map(a => formatValue(a)).join(' '), type: 'log' })
  }

  // 简单的JavaScript解释器模拟
  const vars = {}
  let lineNum = 0

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim()
    if (!line || line.startsWith('//')) continue
    lineNum++

    // 变量声明
    let match
    if (match = line.match(/let\s+(\w+)\s*=\s*(.+);?/)) {
      vars[match[1]] = evalExpression(match[2], vars)
      executionTrace.push({ line: lineNum, code: line, result: `${match[1]} = ${vars[match[1]]}` })
    } else if (match = line.match(/var\s+(\w+)\s*=\s*(.+);?/)) {
      vars[match[1]] = evalExpression(match[2], vars)
      executionTrace.push({ line: lineNum, code: line, result: `${match[1]} = ${vars[match[1]]}` })
    } else if (match = line.match(/(\w+)\s*\+=\s*(.+);?/)) {
      const varName = match[1]
      const addVal = evalExpression(match[2], vars)
      vars[varName] = (vars[varName] || 0) + addVal
      executionTrace.push({ line: lineNum, code: line, result: `${varName} = ${vars[varName]}` })
    } else if (match = line.match(/console\.log\s*\((.+)\);?/)) {
      const args = match[1].match(/"([^"]*)"|'([^']*)'|\w+|\d+/g) || []
      const values = args.map(a => {
        const strMatch = a.match(/^["'](.+)["']$/)
        if (strMatch) return strMatch[1]
        const varMatch = a.match(/^(\w+)$/)
        if (varMatch && vars[varMatch[1]] !== undefined) return vars[varMatch[1]]
        return a
      })
      const text = values.join(' ')
      output.push({ text, type: 'log' })
      executionTrace.push({ line: lineNum, code: line, result: `输出: ${text}` })
    } else if (match = line.match(/for\s*\((.+)\)\s*\{/)) {
      executionTrace.push({ line: lineNum, code: line, result: '循环开始' })
    } else if (line.includes('}')) {
      executionTrace.push({ line: lineNum, code: line, result: '循环结束' })
    } else {
      executionTrace.push({ line: lineNum, code: line, result: '执行' })
    }
  }

  // 更新变量显示
  Object.assign(variables, vars)
}

function evalExpression(expr, vars) {
  try {
    // 替换变量
    let evalExpr = expr
      .replace(/\w+/g, (match) => {
        if (vars[match] !== undefined) return vars[match]
        return match
      })
    // 安全计算
    evalExpr = evalExpr.replace(/[^0-9+\-*/().]/g, '')
    return Function('"use strict"; return (' + evalExpr + ')')()
  } catch {
    return expr.replace(/["']/g, '')
  }
}

async function runCode() {
  if (isRunning.value) return
  isRunning.value = true
  resetCode()
  currentTraceIndex.value = 0

  const lines = code.value.split('\n')
  const vars = {}

  for (let i = 0; i < lines.length; i++) {
    if (currentTraceIndex.value >= 0) {
      currentTraceIndex.value = i
    }
    await new Promise(r => setTimeout(r, 200))
  }

  parseAndExecute(code.value)
  currentTraceIndex.value = -1
  isRunning.value = false
}

async function stepRun() {
  resetCode()
  parseAndExecute(code.value)
}

// 练习题
const quizzes = reactive([
  {
    question: '以下哪个不是程序设计的基本控制结构？',
    options: ['顺序执行', '条件分支', '无限循环', '函数调用'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '变量声明 let x = 10; 中，x 是什么？',
    options: ['关键字', '变量名', '运算符', '数据类型'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: 'for循环的基本组成部分不包括？',
    options: ['初始化', '条件判断', '变量声明', '更新表达式'],
    answer: 2,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: '函数的主要作用是？',
    options: ['增加代码行数', '代码复用和组织', '让程序变慢', '避免使用变量'],
    answer: 1,
    selected: null,
    answered: false,
    correct: false
  },
  {
    question: 'console.log() 函数的作用是？',
    options: ['读取用户输入', '输出信息到控制台', '声明变量', '定义函数'],
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

updateLineNumbers()
</script>

<style scoped>
.programming-module { padding: 0; }

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

/* 概念 */
.key-concept {
  background: var(--surface);
  border-radius: var(--radius);
  padding: 16px;
  margin-bottom: 16px;
}

.key-concept h4 { color: var(--primary); margin-bottom: 12px; }

.key-concept ul { padding-left: 20px; color: var(--text-secondary); }
.key-concept li { margin-bottom: 8px; line-height: 1.6; }

/* 流程图 */
.flow-diagram {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 16px;
}

.flow-step {
  padding: 8px 24px;
  background: var(--primary-light);
  border: 2px solid var(--primary);
  border-radius: 20px;
  font-weight: 600;
  font-size: 13px;
}

.flow-arrow { color: var(--primary); font-size: 18px; }

/* 代码编辑器 */
.code-editor-section {
  background: var(--bg);
  border-radius: var(--radius);
  overflow: hidden;
  margin-bottom: 16px;
}

.editor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 12px;
  background: var(--surface);
  border-bottom: 1px solid var(--border);
  font-weight: 600;
  font-size: 13px;
}

.lang-select {
  padding: 4px 8px;
  border: 1px solid var(--border);
  border-radius: 4px;
  font-size: 12px;
}

.code-editor {
  display: flex;
  min-height: 200px;
  max-height: 300px;
}

.line-numbers {
  padding: 12px 8px;
  background: var(--surface);
  border-right: 1px solid var(--border);
  text-align: right;
  user-select: none;
}

.line-num {
  font-size: 12px;
  color: var(--text-muted);
  line-height: 1.6;
  font-family: monospace;
}

.code-textarea {
  flex: 1;
  padding: 12px;
  border: none;
  resize: none;
  font-family: 'Consolas', 'Monaco', monospace;
  font-size: 13px;
  line-height: 1.6;
  background: #1e1e1e;
  color: #d4d4d4;
  outline: none;
}

/* 控制栏 */
.control-bar {
  display: flex;
  justify-content: space-between;
  margin-bottom: 16px;
}

.control-left, .control-right { display: flex; gap: 8px; }

.ctrl-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.ctrl-btn.run { background: var(--primary); color: white; }
.ctrl-btn.step { background: #dbeafe; color: #1d4ed8; }
.ctrl-btn.reset { background: var(--bg); color: var(--text); border: 1px solid var(--border); }
.ctrl-btn.example { background: #f3e8ff; color: #7c3aed; }
.ctrl-btn:disabled { opacity: 0.5; cursor: not-allowed; }
.ctrl-btn:hover:not(:disabled) { transform: translateY(-1px); }

/* 执行区域 */
.execution-area {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.variables-panel, .output-panel, .stack-panel {
  background: var(--bg);
  border-radius: var(--radius);
  overflow: hidden;
}

.panel-header {
  padding: 10px 12px;
  background: var(--surface);
  border-bottom: 1px solid var(--border);
  font-weight: 600;
  font-size: 13px;
}

.variables-list, .output-content, .stack-content {
  padding: 12px;
  min-height: 120px;
  max-height: 200px;
  overflow-y: auto;
}

.var-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px 8px;
  background: var(--surface);
  border-radius: 6px;
  margin-bottom: 6px;
  font-size: 13px;
}

.var-name { font-weight: 600; color: var(--primary); min-width: 60px; }
.var-type { font-size: 10px; padding: 2px 6px; background: var(--bg); border-radius: 4px; color: var(--text-muted); }
.var-value { flex: 1; text-align: right; font-family: monospace; }

.output-line {
  font-family: monospace;
  font-size: 12px;
  padding: 4px 0;
  border-bottom: 1px solid var(--border);
}

.output-line:last-child { border-bottom: none; }
.output-line.error { color: #dc2626; }

.empty-msg { color: var(--text-muted); font-size: 13px; text-align: center; padding: 20px; }

/* 堆栈跟踪 */
.stack-panel { grid-column: span 2; }

.trace-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px;
  background: var(--surface);
  border-radius: 6px;
  margin-bottom: 6px;
  font-size: 12px;
  opacity: 0.6;
}

.trace-item.current { opacity: 1; background: var(--primary-light); border-left: 3px solid var(--primary); }

.trace-line { font-weight: 600; color: var(--primary); min-width: 50px; }
.trace-code { flex: 1; font-family: monospace; color: var(--text); }
.trace-result { color: var(--text-secondary); }

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
  .execution-area { grid-template-columns: 1fr; }
  .stack-panel { grid-column: span 1; }
  .quiz-options { grid-template-columns: 1fr; }
}
</style>
