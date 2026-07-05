<template>
  <EchartsBase :height="height" :option="pieOption" :autoResize="autoResize" />
</template>

<script setup lang="ts">
import EchartsBase from './EchartsBase.vue'
import { computed } from 'vue'

const props = defineProps({
  height: {
    type: String,
    default: '400px'
  },
  autoResize: {
    type: Boolean,
    default: true
  },
  // 饼图数据（格式：[{ name: '分类1', value: 100 }, ...]）
  data: {
    type: Array,
    required: true
  },
  // 饼图标题
  title: {
    type: String,
    default: '饼图数据统计'
  },
  // 饼图颜色（可选，默认使用 ECharts 内置配色）
  colorList: {
    type: Array,
    default: () => []
  }
})

// 计算饼图配置项
const pieOption = computed(() => ({
  title: {
    text: props.title,
    left: 'center',
    textStyle: { fontSize: 16 }
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b}: {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left',
    top: 'center'
  },
  series: [
    {
      name: props.title,
      type: 'pie',
      radius: ['40%', '70%'], // 内环、外环半径
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 8,
        borderColor: '#fff',
        borderWidth: 2
      },
      label: {
        show: false,
        position: 'center'
      },
      emphasis: {
        label: {
          show: true,
          fontSize: 16,
          fontWeight: 'bold'
        }
      },
      labelLine: {
        show: false
      },
      data: props.data,
      color: props.colorList.length > 0 ? props.colorList : undefined
    }
  ]
}))
</script>