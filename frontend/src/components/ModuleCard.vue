<template>
  <div
    class="module-card"
    :style="{ '--card-color': module.color }"
    @click="$emit('click')"
  >
    <div class="module-card-icon" :style="{ background: module.color + '15', color: module.color }">
      <component :is="moduleIcon" />
    </div>
    <div class="module-card-name">{{ module.name }}</div>
    <div class="module-card-desc">{{ module.desc }}</div>
  </div>
</template>

<script setup>
import { computed, h } from 'vue'

const props = defineProps({
  module: {
    type: Object,
    required: true
  }
})

defineEmits(['click'])

const icons = {
  turing: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('rect', { x: 6, y: 14, width: 36, height: 20, rx: 4, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('rect', { x: 10, y: 10, width: 4, height: 4, rx: 1, fill: 'currentColor', opacity: 0.6 }),
    h('circle', { cx: 14, cy: 24, r: 5, stroke: 'currentColor', 'stroke-width': 2, fill: 'none' }),
    h('line', { x1: 19, y1: 24, x2: 35, y2: 24, stroke: 'currentColor', 'stroke-width': 1.5, 'stroke-dasharray': '3 2', opacity: 0.4 })
  ]),
  complexity: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('rect', { x: 6, y: 36, width: 6, height: 4, rx: 1, fill: 'currentColor' }),
    h('rect', { x: 14, y: 28, width: 6, height: 12, rx: 1, fill: 'currentColor' }),
    h('rect', { x: 22, y: 20, width: 6, height: 20, rx: 1, fill: 'currentColor' }),
    h('rect', { x: 30, y: 12, width: 6, height: 28, rx: 1, fill: 'currentColor' }),
    h('rect', { x: 38, y: 8, width: 6, height: 32, rx: 1, fill: 'currentColor' }),
    h('path', { d: 'M6 12L38 4', stroke: 'currentColor', 'stroke-width': 1.5, 'stroke-dasharray': '4 3', opacity: 0.4 })
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
    h('circle', { cx: 12, cy: 12, r: 3, fill: 'currentColor', opacity: 0.5 }),
    h('circle', { cx: 36, cy: 12, r: 3, fill: 'currentColor', opacity: 0.5 }),
    h('circle', { cx: 24, cy: 24, r: 3, fill: 'currentColor', opacity: 0.7 }),
    h('path', { d: 'M15 12h6M30 12h6M12 15v3M36 15v3M24 21v6', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round' })
  ]),
  datastruct: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('circle', { cx: 24, cy: 8, r: 5, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('line', { x1: 24, y1: 13, x2: 24, y2: 19, stroke: 'currentColor', 'stroke-width': 2 }),
    h('circle', { cx: 24, cy: 24, r: 5, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('line', { x1: 19, y1: 24, x2: 12, y2: 16, stroke: 'currentColor', 'stroke-width': 2 }),
    h('line', { x1: 29, y1: 24, x2: 36, y2: 16, stroke: 'currentColor', 'stroke-width': 2 }),
    h('circle', { cx: 10, cy: 40, r: 5, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('line', { x1: 15, y1: 40, x2: 19, y2: 29, stroke: 'currentColor', 'stroke-width': 2 }),
    h('circle', { cx: 38, cy: 40, r: 5, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('line', { x1: 33, y1: 40, x2: 29, y2: 29, stroke: 'currentColor', 'stroke-width': 2 })
  ]),
  algorithm: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('path', { d: 'M6 40L12 32L18 36L24 24L30 28L36 16L42 20', stroke: 'currentColor', 'stroke-width': 2.5, 'stroke-linejoin': 'round' }),
    h('circle', { cx: 6, cy: 40, r: 3, fill: 'currentColor' }),
    h('circle', { cx: 12, cy: 32, r: 3, fill: 'currentColor' }),
    h('circle', { cx: 18, cy: 36, r: 3, fill: 'currentColor' }),
    h('circle', { cx: 24, cy: 24, r: 3, fill: 'currentColor' }),
    h('circle', { cx: 30, cy: 28, r: 3, fill: 'currentColor' }),
    h('circle', { cx: 36, cy: 16, r: 3, fill: 'currentColor' }),
    h('circle', { cx: 42, cy: 20, r: 3, fill: 'currentColor' })
  ]),
  programming: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('rect', { x: 4, y: 8, width: 40, height: 32, rx: 4, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('rect', { x: 8, y: 4, width: 32, height: 4, rx: 2, fill: 'currentColor', opacity: 0.3 }),
    h('path', { d: 'M16 20l-4 4 4 4M26 28l8-16M32 20l4 4-4 4', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' })
  ]),
  ai: () => h('svg', { viewBox: '0 0 48 48', fill: 'none' }, [
    h('circle', { cx: 24, cy: 16, r: 10, stroke: 'currentColor', 'stroke-width': 2.5 }),
    h('line', { x1: 24, y1: 26, x2: 24, y2: 32, stroke: 'currentColor', 'stroke-width': 2.5, 'stroke-linecap': 'round' }),
    h('line', { x1: 18, y1: 32, x2: 30, y2: 32, stroke: 'currentColor', 'stroke-width': 2.5, 'stroke-linecap': 'round' }),
    h('line', { x1: 21, y1: 36, x2: 27, y2: 36, stroke: 'currentColor', 'stroke-width': 2.5, 'stroke-linecap': 'round' }),
    h('circle', { cx: 20, cy: 12, r: 2, fill: 'currentColor', opacity: 0.6 }),
    h('circle', { cx: 28, cy: 14, r: 1.5, fill: 'currentColor', opacity: 0.4 })
  ])
}

const moduleIcon = computed(() => icons[props.module.icon] || icons.turing)
</script>

<style scoped>
.module-card {
  background: var(--surface);
  border-radius: var(--radius-lg);
  padding: 28px 24px;
  cursor: pointer;
  transition: all .25s cubic-bezier(.4,0,.2,1);
  box-shadow: var(--shadow);
  border: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
  position: relative;
  overflow: hidden;
}

.module-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: var(--card-color, var(--primary));
  transform: scaleX(0);
  transition: transform .3s;
}

.module-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-xl);
  border-color: transparent;
}

.module-card:hover::before {
  transform: scaleX(1);
}

.module-card:active {
  transform: translateY(-1px);
}

.module-card-icon {
  width: 72px;
  height: 72px;
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform .3s;
}

.module-card-icon svg {
  width: 40px;
  height: 40px;
}

.module-card:hover .module-card-icon {
  transform: scale(1.08);
}

.module-card-name {
  font-size: 17px;
  font-weight: 600;
  color: var(--text);
  letter-spacing: 0.3px;
}

.module-card-desc {
  font-size: 14px;
  color: var(--text-secondary);
  text-align: center;
  line-height: 1.5;
}
</style>
