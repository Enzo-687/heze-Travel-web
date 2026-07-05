<template>
    <EchartsBase :height="height" :option="lineOption" :autoResize="autoResize" />
</template>

<script setup lang="ts">
import { computed } from 'vue'
import EchartsBase from './EchartsBase.vue'

const props = defineProps({
    height: {
        type: String,
        default: '400px'
    },
    autoResize: {
        type: Boolean,
        default: true
    },
    // 单系列数据（格式：[12,24,34,54]）
    data: {
        type: Array,
        required: true
    },
    // x轴类目数据（格式：['11-2','11-3','11-4','11-5']）
    xAxisData: {
        type: Array,
        required: true
    },
    // 折线图标题
    title: {
        type: String,
        default: ''
    },
    // 系列名称（图例显示）
    seriesName: {
        type: String,
        default: '数据趋势'
    },
    // 是否显示标记点
    showMarkPoint: {
        type: Boolean,
        default: false
    },

    // 自定义tooltip格式化函数
    tooltipFormatter: {
        type: Function,
        default: null
    }
})

// 计算折线图配置项（面积渐变 + 自定义hover）
const lineOption = computed(() => ({
    title: props.title ? {
        text: props.title,
        left: 'center',
        textStyle: { fontSize: 16, fontWeight: 600 }
    } : undefined,
    // 自定义tooltip样式
    tooltip: {
        trigger: 'axis',
        axisPointer: {
            type: 'line',
            lineStyle: { color: '#409EFF', width: 1, type: 'dashed' }
        },
        backgroundColor: 'rgba(255,255,255,0.9)',
        borderColor: '#409EFF',
        borderWidth: 1,
        padding: 16,
        textStyle: { color: '#333' },
        formatter: props.tooltipFormatter || function (params: any) {
            // 默认的tooltip内容格式
            return `
        <div style="text-align: center;">
          <div style="font-size: 14px; font-weight: bold; color: #333;">${params[0].axisValue}</div>
          <div style="margin-top: 8px;">${props.seriesName}：<span style="color: #F56C6C;">${params[0].value}</span></div>
        </div>
      `
        }
    },
    grid: {
        left: '5%',
        right: '5%',
        bottom: '8%',
        top: props.title ? '15%' : '5%', // 根据是否有标题调整顶部间距
        containLabel: true
    },
    legend: {
        data: [props.seriesName],
        top: props.title ? 'top' : '0',
        left: 'center',
        textStyle: { fontSize: 14 },
        selectedMode: false,
    },
    xAxis: {
        type: 'category',
        data: props.xAxisData,
        axisTick: { alignWithLabel: false },
        axisLine: { lineStyle: { color: '#fafafa' } },
        axisLabel: {
            textStyle: { color: '#666' },
            interval: 1 // 强制显示所有x轴标签
        }
    },
    yAxis: {
        type: 'value',
        axisLine: { show: true,lineStyle: { color: '#fafafa' } }, // Y轴
        axisTick: { show: true,lineStyle: { color: '#fafafa' } }, // 刻度
        splitLine: { show: false },
        axisLabel: { textStyle: { color: '#666' } }
    },
    series: [
        {
            name: props.seriesName,
            type: 'line',
            smooth: true, // 平滑曲线
            data: props.data,
            lineStyle: {
                width: 3,
                color: '#409EFF' // 折线颜色
            },
            itemStyle: {
                color: '#409EFF', // 拐点颜色
                borderColor: '#fff',
                borderWidth: 1
            },
            symbol: 'circle', // 拐点形状
            symbolSize: 8, // 拐点大小
            // 面积渐变填充
            areaStyle: {
                color: {
                    type: 'linear',
                    x: 0,
                    y: 0,
                    x2: 0,
                    y2: 1,
                    colorStops: [
                        { offset: 0, color: 'rgba(0, 126, 255, 0.4)' }, // 渐变起始颜色
                        { offset: 1, color: 'rgba(35, 168, 242, 0.05)' } // 渐变结束颜色
                    ]
                }
            },
            markPoint: props.showMarkPoint
                ? {
                    data: [
                        { type: 'max', name: '最大值', symbolOffset: [0, -16],symbolSize:0, },
                        { type: 'min', name: '最小值', symbolOffset: [0, -16],symbolSize:0, }
                    ],
                    itemStyle: { color: '#F56C6C' }
                }
                : undefined,
            markLine: {
                data: [{ type: 'average', name: '平均值' }],
                lineStyle: { type: 'dashed', color: 'rgb(0, 119, 184)' }
            }
        }
    ]
}))
</script>