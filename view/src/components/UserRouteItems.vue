<template>
    <div class="timeline-arc-container">

        <!-- 时间轴主体 -->
        <div class="timeline-main">
            <!-- 顶部半圆扇形卡片容器 -->
            <div class="top-fan-container">
                <!-- 扇形顶部中心点 -->
                <div class="fan-top-center"></div>

                <!-- 扇形卡片布局 -->
                <div v-for="(route, index) in scenicSpotRouteItemList" :key="`card-${route.id}`" class="fan-card"
                    :class="{
                        'active': currentRouteIndex === index,
                        'prev': index < currentRouteIndex,
                        'next': index > currentRouteIndex
                    }" :style="getTopFanCardStyle(index)" @click.stop="selectRoute(index)">
                    <!-- 卡片内容 -->
                    <div class="card-content">
                        <!-- 卡片头部 -->
                        <div class="card-header">
                            <div class="route-index">{{ route.positionDesc }}</div>
                            <div class="route-difficulty" :class="getDifficultyClass(route.intensity)">
                                {{ getDifficultyText(route.intensity) }}
                            </div>
                        </div>

                        <!-- 定位描述 -->
                        <div class="route-position">
                            <span class="detail-text">约耗时{{ route.times }}</span>
                        </div>

                        <!-- 核心看点 -->
                        <div class="route-focus">
                            <div class="focus-title">核心看点</div>
                            <div class="focus-tags">
                                <span v-for="(item, i) in splitFocusDesc(route.focusDesc)" :key="i" class="focus-tag">
                                    {{ item }}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 当前选中路线详情 -->
            <div v-if="currentRoute" class="selected-route-detail">
                <!-- 顶部标题区域 -->
                <div class="timeline-header">
                    <h2 class="route-title">景点路线收录</h2>
                    <div class="route-count">共 {{ scenicSpotRouteItemList.length }} 条路线</div>
                </div>
                <div class="detail-header">
                    <div style="display: flex;justify-content: left;align-items: center;gap: 10px;">
                        <div class="detail-subtitle">当前路线：{{ currentRoute.positionDesc }}</div>
                        <div class="fun-btn-route" @click="handleSelectRoutesChildren">
                            <el-icon>
                                <connection />
                            </el-icon>

                            查看当前路线项节点
                        </div>
                    </div>

                </div>

                <div class="detail-content">
                    <div class="sec">
                        <div class="detail-section">
                            <div style="text-align: center;margin-bottom: 20px;font-size: 18px;">路线强度分析</div>
                            <div class="intensity-meter">
                                <div class="meter-bar" :style="{ width: `${currentRoute.intensity * 20}%` }"></div>
                                <div class="meter-labels">
                                    <span v-for="i in 5" :key="i" :class="{ 'active': i <= currentRoute.intensity }">
                                        {{ i }}
                                    </span>
                                </div>
                            </div>
                            <div class="intensity-text">{{ getIntensityDescription(currentRoute.intensity) }}</div>
                        </div>

                        <div class="detail-section">
                            <div style="text-align: center;font-size: 18px;">核心看点分布</div>
                            <div class="focus-visual">
                                <div v-for="(item, index) in splitFocusDesc(currentRoute.focusDesc)" :key="index"
                                    class="visual-item">
                                    <div class="visual-dot" :style="getVisualStyle(index)"></div>
                                    <div class="visual-label">{{ item }}</div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

const props = defineProps<{
    scenicSpotRouteItemList: Array<{
        id: number;
        scenicSpotId: number;
        positionDesc: string;
        times: string;
        intensity: number;
        focusDesc: string;
    }>;
}>()

// 定义事件
const emit = defineEmits<{
    (e: 'routes', route: any): void
}>()

// 当前选中的路线索引
const currentRouteIndex = ref(0)
const containerWidth = ref(0)

onMounted(() => {
    // 获取容器宽度
    updateContainerWidth()
    window.addEventListener('resize', updateContainerWidth)
})

const updateContainerWidth = () => {
    const container = document.querySelector('.top-fan-container')
    if (container) {
        containerWidth.value = container.clientWidth
    }
}

// 计算当前选中的路线
const currentRoute = computed(() =>
    props.scenicSpotRouteItemList[currentRouteIndex.value]
)

// 选择路线
const selectRoute = (index: number) => {
    currentRouteIndex.value = index
}

// 修复卡片位置计算
const getTopFanCardStyle = (index: number) => {
    const total = props.scenicSpotRouteItemList.length
    if (total === 0) return {}

    // 扇形角度计算 - 上半圆180度
    const fanAngle = 180 // 上半圆扇形总角度
    const startAngle = -90 // 起始角度（从最左侧开始）
    const spacingAngle = total > 1 ? fanAngle / (total - 1) : 0

    // 计算当前卡片的角度
    const currentAngle = startAngle + (index * spacingAngle)

    // 将角度转换为弧度
    const angleInRadians = (currentAngle * Math.PI) / 180

    // 扇形半径 - 根据容器宽度动态计算
    const baseRadius = containerWidth.value * 0.3 // 稍微缩小半径
    const cardRadius = Math.min(baseRadius, 280)

    // 计算卡片在弧形上的位置（使用像素单位）
    const centerX = containerWidth.value / 2
    const centerY = 60 // 中心点下移，与fan-top-center保持一致

    // 计算卡片位置
    const cardX = centerX + (Math.sin(angleInRadians) * cardRadius)
    const cardY = centerY + (Math.cos(angleInRadians) * cardRadius)

    // 计算层级
    const zIndex = total - Math.abs(index - currentRouteIndex.value)

    // 计算缩放
    let scale = 1
    if (index === currentRouteIndex.value) {
        scale = 1.15 // 稍微减小放大倍数
    } else if (Math.abs(index - currentRouteIndex.value) === 1) {
        scale = 0.9
    } else {
        scale = 0.85
    }

    // 计算旋转角度（卡片朝向中心）
    const rotateAngle = currentAngle * 0.5 // 轻微旋转让卡片朝向中心

    // 计算放大后的偏移量，确保卡片不会超出顶部
    const translateYOffset = scale > 1 ? (scale - 1) * 80 : 0 // 放大时向上偏移

    return {
        left: `${cardX}px`,
        top: `${cardY}px`,
        transform: `translate(-50%, calc(-50% - ${translateYOffset}px)) rotate(${rotateAngle}deg) scale(${scale})`,
        transformOrigin: 'bottom center',
        zIndex: zIndex,
        opacity: Math.abs(index - currentRouteIndex.value) > 2 ? 0.6 : 1
    }
}

// 获取难度文本
const getDifficultyText = (intensity: number) => {
    const map = ['简单', '较易', '中等', '较难', '困难']
    return map[intensity - 1] || '未知'
}

// 获取难度CSS类
const getDifficultyClass = (intensity: number) => {
    const classes = ['easy', 'moderate-easy', 'moderate', 'moderate-hard', 'hard']
    return classes[intensity - 1] || 'unknown'
}

// 分割核心看点
const splitFocusDesc = (desc: string) => {
    return desc.split(/[、,，]/).map(item => item.trim()).filter(item => item)
}

// 获取强度描述
const getIntensityDescription = (intensity: number) => {
    const descriptions = [
        '适合新手，轻松愉快',
        '略有挑战，适合家庭',
        '中等强度，需要体力',
        '挑战较大，适合徒步爱好者',
        '极限挑战，需要专业装备'
    ]
    return descriptions[intensity - 1] || ''
}

// 获取视觉样式
const getVisualStyle = (index: number) => {
    const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#ffeaa7', '#dda0dd']
    return {
        backgroundColor: colors[index % colors.length],
        animationDelay: `${index * 0.2}s`
    }
}


// 查看路线下的全部节点
const handleSelectRoutesChildren = () => {
    emit('routes', currentRoute.value)
}


</script>

<style lang="scss" scoped>
.cannel,
.fun-btn {
    padding: 6px 20px;
    border-radius: 20px;
    cursor: pointer;
    transition: all 0.5s ease;
}

.cannel {
    border: 1px solid rgb(51, 51, 51);

    &:hover {
        border: 1px solid rgb(31, 31, 31);
    }
}

.fun-btn {
    background-color: rgb(51, 51, 51);
    color: rgb(255, 255, 255);

    &:hover {
        background-color: rgb(31, 31, 31);
    }
}

.fun-btn-route {
    padding: 10px 20px;
    border-radius: 20px;
    cursor: pointer;
    transition: all 0.5s ease;
}

.fun-btn-route {
    background-color: rgb(51, 51, 51);
    color: rgb(255, 255, 255);

    &:hover {
        background-color: rgb(31, 31, 31);
    }
}



.timeline-arc-container {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    padding: 20px;
    max-width: 100%;
    margin: 0 auto;
    overflow-x: hidden;
    overflow-y: auto;
}

/* 头部样式 */
.timeline-header {
    text-align: center;
    margin-bottom: 20px;
    /* 增加顶部间距 */
}

.route-title {
    font-size: 2.2rem;
    color: #2c3e50;
    margin-bottom: 10px;
    font-weight: 600;
}

.route-count {
    color: #7f8c8d;
    font-size: 1rem;
    background: #f8f9fa;
    display: inline-block;
    padding: 6px 16px;
    border-radius: 20px;
}

/* 主容器 */
.timeline-main {
    position: relative;
    min-height: 800px;
    padding-top: 150px;
    width: 100%;
    overflow: hidden;
}

/* 顶部半圆扇形容器 */
.top-fan-container {
    position: relative;
    width: 100%;
    height: 400px;
    overflow: visible;
    margin-bottom: 50px;
    /* 为底部圆弧留出空间 */
    padding-top: 60px;
}

/* 扇形顶部中心点 */
.fan-top-center {
    position: absolute;
    left: 50%;
    top: 10%;
    width: 16px;
    height: 16px;
    background: #667eea;
    border-radius: 50%;
    box-shadow: 0 0 0 10px rgba(102, 126, 234, 0.2);
    animation: pulse 2s ease-in-out infinite;
    z-index: 10;
    transform: translate(-50%, -50%);
}

@keyframes pulse {

    0%,
    100% {
        transform: translate(-50%, -50%) scale(1);
        box-shadow: 0 0 0 10px rgba(102, 126, 234, 0.2);
    }

    50% {
        transform: translate(-50%, -50%) scale(1.1);
        box-shadow: 0 0 0 15px rgba(102, 126, 234, 0.3);
    }
}

/* 扇形卡片 */
.fan-card {
    position: absolute;
    width: 240px;
    height: auto;
    transform-origin: bottom center;
    transition: all 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    cursor: pointer;
    border-radius: 20px;
}

.fan-card:hover {
    z-index: 50 !important;
    transform: translate(-50%, -50%) scale(1.1) !important;
    background-color: rgb(255,255,255);
    // box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2) !important;
}

.fan-card.active {
    z-index: 30 !important;
    transform: translate(-50%, -50%) scale(1.15) !important;
    /* 减小放大倍数 */
    box-shadow: 0 20px 50px rgba(102, 126, 234, 0.4) !important;
    margin-top: -10px;
    /* 放大时向上偏移 */
}

/* 卡片内容 */
.card-content {
    width: 100%;
    height: 100%;
    background: white;
    border-radius: 16px;
    padding: 18px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
    border: 2px solid transparent;
    transition: all 0.4s ease;
    overflow: hidden;
    position: relative;
}

.fan-card.active .card-content {
    border-color: #667eea;
    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
}

/* 卡片头部 */
.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
    padding-bottom: 8px;
    border-bottom: 1px solid #f0f2f5;
}

.route-index {
    font-size: 1rem;
    font-weight: 700;
    color: #2c3e50;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 60%;
}

.route-difficulty {
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 600;
    color: white;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    white-space: nowrap;
}

.route-difficulty.easy {
    background: linear-gradient(135deg, #42b983, #3da877);
}

.route-difficulty.moderate-easy {
    background: linear-gradient(135deg, #4ecdc4, #45bab2);
}

.route-difficulty.moderate {
    background: linear-gradient(135deg, #45b7d1, #3da5bd);
}

.route-difficulty.moderate-hard {
    background: linear-gradient(135deg, #ffa726, #ff9800);
}

.route-difficulty.hard {
    background: linear-gradient(135deg, #ff6b6b, #ff5252);
}

/* 定位描述 */
.route-position {
    display: flex;
    align-items: flex-start;
    gap: 6px;
    margin-bottom: 10px;
    /* height: 36px; */
    overflow: hidden;
}

.position-icon {
    font-size: 1rem;
    flex-shrink: 0;
    margin-top: 2px;
}

.position-text {
    font-size: 40px;
    color: #333;
    line-height: 1.4;
    font-weight: 500;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
    flex: 1;
}

/* 核心看点 */
.route-focus {
    margin-bottom: 30px;
    height: auto;
    /* overflow: hidden; */
}

.focus-title {
    font-size: 0.8rem;
    color: #7f8c8d;
    margin-bottom: 5px;
    font-weight: 600;
}

.focus-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 4px;
    max-height: 32px;
    padding-right: 2px;
}

.focus-tag {
    background: linear-gradient(135deg, rgb(248, 248, 248), rgb(232, 232, 232));
    color: #333;
    padding: 2px 6px;
    border-radius: 10px;
    font-size: 0.7rem;
    font-weight: 500;
    border: 1px solid #dee2e6;
    white-space: nowrap;
}

/* 详细信息 */
.route-details {
    display: flex;
    gap: 12px;
    margin-top: 6px;
    padding-top: 8px;
    border-top: 1px solid #f0f2f5;
    position: absolute;
    bottom: 18px;
    left: 18px;
    right: 18px;
}

.detail-item {
    display: flex;
    align-items: center;
    gap: 4px;
    flex: 1;
}

.detail-icon {
    font-size: 0.8rem;
    flex-shrink: 0;
    opacity: 0.8;
}

.detail-text {
    font-size: 18px;
    color: #333;
    font-weight: 600;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    flex: 1;
}

/* 底部圆弧容器 */
.bottom-arc-container {
    width: 100%;
    height: 150px;
    position: relative;
    margin-top: 10px;
}

.bottom-arc-svg {
    width: 100%;
    height: 100px;
    overflow: visible;
}

.bottom-arc-path {
    fill: none;
    stroke: #667eea;
    stroke-width: 3;
    stroke-linecap: round;
    filter: drop-shadow(0 4px 12px rgba(102, 126, 234, 0.2));
}

/* 圆弧点样式 */
.arc-point {
    fill: white;
    stroke: #667eea;
    stroke-width: 3;
    cursor: pointer;
    transition: all 0.3s ease;
    filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.1));
}

.arc-point:hover {
    fill: #667eea;
    transform: scale(1.3);
    filter: drop-shadow(0 4px 12px rgba(102, 126, 234, 0.4));
}

.arc-point.active {
    fill: #ff6b6b;
    stroke: #ff6b6b;
    transform: scale(1.4);
    filter: drop-shadow(0 6px 20px rgba(255, 107, 107, 0.4));
}

/* 时间标签 */
.time-label {
    fill: #2c3e50;
    font-size: 11px;
    font-weight: 600;
    pointer-events: none;
    transition: all 0.3s ease;
}

.arc-point:hover~.time-label,
.arc-point.active~.time-label {
    fill: #667eea;
    font-weight: 700;
}

/* 强度标签 */
.intensity-label {
    fill: #f39c12;
    font-size: 10px;
    font-weight: 500;
    pointer-events: none;
}

/* 选中路线详情 */
.selected-route-detail {
    border-radius: 20px;
    padding: 30px;
    margin-top: 10px;
    animation: fadeInUp 0.6s ease;
}


@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }

    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.detail-header {
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    margin-bottom: 25px;
}

.detail-header h3 {
    color: #2c3e50;
    margin-bottom: 10px;
    font-size: 1.4rem;
    font-weight: 600;
}

.detail-subtitle {
    color: #667eea;
    font-size: 1.4rem;
    font-weight: 500;
    background: rgba(102, 126, 234, 0.1);
    display: inline-block;
    padding: 6px 16px;
    border-radius: 20px;
}

.detail-content {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 25px;

    .sec {
        width: 1000px;
        display: flex;
        justify-content: space-evenly;
        align-items: center;
        background-color: rgb(250,250,250);
        padding-block: 20px;
        border-radius: 20px;
    }
}

.detail-section h4 {
    color: #34495e;
    margin-bottom: 15px;
    font-size: 1.1rem;
    font-weight: 600;
}

/* 强度计量器 */
.intensity-meter {
    background: #ecf0f1;
    width: 320px;
    height: 30px;
    border-radius: 15px;
    overflow: hidden;
    position: relative;
    margin-bottom: 10px;
    box-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.1);
}

.meter-bar {
    height: 100%;
    background: linear-gradient(90deg, #70e2e8, #479ecc);
    border-radius: 15px;
    transition: width 1s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.meter-labels {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 15px;
}

.meter-labels span {
    color: #95a5a6;
    font-weight: 600;
    font-size: 0.9rem;
    transition: all 0.3s ease;
}

.meter-labels span.active {
    color: white;
    background: rgba(102, 126, 234, 0.1);
    transform: scale(1.2);
}

.intensity-text {
    color: #7f8c8d;
    font-size: 0.9rem;
    text-align: center;
    font-weight: 500;
    padding: 8px;
    background: rgba(255, 255, 255, 0.5);
    border-radius: 8px;
}

/* 核心看点可视化 */
.focus-visual {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 20px;
    flex-wrap: wrap;
}

.visual-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    margin-bottom: 10px;
}

.visual-dot {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    animation: float 3s ease-in-out infinite;
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
}

@keyframes float {

    0%,
    100% {
        transform: translateY(0px);
    }

    50% {
        transform: translateY(-8px);
    }
}

.visual-label {
    font-size: 0.85rem;
    color: #2c3e50;
    text-align: center;
    max-width: 160px;
    /* font-weight: 500; */
    padding: 4px 6px;
    background: rgba(255, 255, 255, 0.8);
    border-radius: 6px;
}

/* 背景虚线连接扇形中心到底部圆弧 */
.top-fan-container::after {
    content: '';
    position: absolute;
    left: 50%;
    top: 10%;
    height: 200px;
    bottom: -200px;
    width: 1px;
    background-image: linear-gradient(to bottom, #667eea 50%, transparent 50%);
    background-size: 10px 10px;
    opacity: 0.3;
    z-index: 0;
}

/* 响应式调整 */
@media (max-width: 1200px) {
    .top-fan-container {
        height: 350px;
    }

    .fan-card {
        width: 240px;
        height: 150px;
    }
}

@media (max-width: 992px) {
    .top-fan-container {
        height: 320px;
    }

    .fan-card {
        width: 220px;
        height: 140px;
    }

    .card-content {
        padding: 15px;
    }
}

@media (max-width: 768px) {
    .timeline-header {
        margin-bottom: 60px;
    }

    .route-title {
        font-size: 1.8rem;
    }

    .top-fan-container {
        height: 300px;
        margin-bottom: 150px;
    }

    .fan-card {
        width: 200px;
        height: 130px;
    }

    .card-content {
        padding: 12px;
    }

    .route-index {
        font-size: 0.9rem;
    }

    .route-difficulty {
        font-size: 0.7rem;
        padding: 3px 8px;
    }
}

@media (max-width: 576px) {
    .timeline-arc-container {
        padding: 15px;
    }

    .top-fan-container {
        height: 280px;
    }

    .fan-card {
        width: 180px;
        height: 120px;
    }

    .detail-content {
        grid-template-columns: 1fr;
    }
}

/* 扇形投影效果 */
.top-fan-container::before {
    content: '';
    position: absolute;
    left: 50%;
    top: 30%;
    width: 600px;
    height: 300px;
    background: radial-gradient(ellipse at center,
            rgba(102, 126, 234, 0.1) 0%,
            rgba(102, 126, 234, 0.05) 30%,
            transparent 70%);
    transform: translate(-50%, 0);
    z-index: -1;
    pointer-events: none;
}
</style>