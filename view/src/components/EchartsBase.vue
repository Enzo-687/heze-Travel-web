<template>
  <div ref="chartRef" class="echarts-container" :style="{ width: '100%', height }"></div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, onUnmounted, nextTick } from 'vue'
import * as echarts from 'echarts'

const props = defineProps({
  height: {
    type: String,
    default: '400px'
  },
  option: {
    type: Object,
    required: true
  },
  autoResize: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['chartInit'])

const chartRef = ref<HTMLDivElement | null>(null)
let chartInstance: echarts.ECharts | null = null
let resizeObserver: ResizeObserver | null = null // 新增ResizeObserver监听容器变化

// 初始化图表
const initChart = async () => {
  await nextTick() // 确保DOM已渲染
  if (!chartRef.value) return
  
  // 销毁旧实例
  if (chartInstance) {
    chartInstance.dispose()
  }
  
  // 初始化ECharts实例
  chartInstance = echarts.init(chartRef.value)
  chartInstance.setOption(props.option, true)
  emit('chartInit', chartInstance)
}

// 更新图表
const updateChart = (newOption: echarts.EChartsOption) => {
  if (chartInstance) {
    chartInstance.setOption(newOption, true)
  }
}

// 调整图表大小
const resizeChart = () => {
  if (chartInstance) {
    chartInstance.resize({
      animation: { duration: 300, easing: 'cubicOut' }
    })
  }
}

// 监听option变化
watch(
  () => props.option,
  (newOption) => {
    updateChart(newOption)
  },
  { deep: true }
)

// 监听容器大小变化（修复resize核心）
onMounted(() => {
  initChart()
  
  // 方案1：监听window.resize（兼容旧浏览器）
  if (props.autoResize) {
    window.addEventListener('resize', resizeChart)
  }
  
  // 方案2：使用ResizeObserver监听容器本身变化（更精准）
  if (props.autoResize && typeof ResizeObserver !== 'undefined') {
    resizeObserver = new ResizeObserver(() => {
      resizeChart()
    })
    if (chartRef.value) {
      resizeObserver.observe(chartRef.value)
    }
  }
})

onUnmounted(() => {
  // 清理监听
  if (props.autoResize) {
    window.removeEventListener('resize', resizeChart)
  }
  
  if (resizeObserver) {
    resizeObserver.disconnect()
    resizeObserver = null
  }
  
  // 销毁实例
  if (chartInstance) {
    chartInstance.dispose()
    chartInstance = null
  }
})

// 暴露方法
defineExpose({
  updateChart,
  resizeChart,
  chartInstance
})
</script>

<style scoped>
.echarts-container {
  width: 100%;
  transition: all 0.3s ease;
  will-change: width, height;
}
</style>