<template>
    <div class="scenic-detail-container">
        <!-- 返回按钮 -->
        <div class="back-header">
            <el-page-header @back="$router.back()" icon="ArrowLeft" :content="scenicSpotDetail.title">
            </el-page-header>
        </div>

        <!-- 主要内容 -->
        <div v-if="scenicSpotDetail.id" class="detail-content">
            <!-- 封面图 -->
            <div class="cover-section">
                <img :src="scenicSpotDetail.cover" :alt="scenicSpotDetail.title" class="cover-image">
                <div class="cover-overlay">
                    <h1 class="spot-title">{{ scenicSpotDetail.title }}</h1>
                    <div class="location-info">
                        <span class="location-icon">
                            <el-icon>
                                <location-filled />
                            </el-icon>
                        </span>
                        <span>{{ scenicSpotDetail.countyName }} - {{ scenicSpotDetail.townName }}</span>
                    </div>
                </div>
            </div>

            <!-- 基本信息卡片 -->
            <div class="info-cards">
                <!-- 摘要卡片 -->
                <div class="summary-card info-card">
                    <h2 class="card-title">
                        <span class="title-icon">📝</span>
                        <span>景点简介</span>
                    </h2>
                    <p class="summary-text">{{ scenicSpotDetail.summary }}</p>
                    <div class="create-time">
                        <span class="time-icon">⏰</span>
                        <span>创建时间：{{ scenicSpotDetail.createTime }}</span>
                    </div>
                </div>

                <!-- 地区信息卡片 -->
                <div class="region-card info-card">
                    <h2 class="card-title">
                        <span class="title-icon">📍</span>
                        <span>地区信息</span>
                    </h2>
                    <div class="region-info">
                        <div class="region-item">
                            <span class="region-label">县：</span>
                            <span class="region-value">{{ scenicSpotDetail.countyName || '--' }}</span>
                        </div>
                        <div class="region-item">
                            <span class="region-label">乡镇：</span>
                            <span class="region-value">{{ scenicSpotDetail.townName || '--' }}</span>
                        </div>

                    </div>
                </div>

                <!-- ID信息卡片 -->
                <div class="id-card info-card">
                    <h2 class="card-title">
                        <span class="title-icon">🆔</span>
                        <span>基本信息</span>
                    </h2>
                    <div class="id-info">
                        <div class="id-item">
                            <span class="id-label">图册数量：</span>
                            <span class="id-value">{{ scenicSpotDetail.brochureList?.length || 0 }} 张</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 详细内容 -->
            <div class="content-section">
                <h2 class="section-title">
                    <span class="title-icon">📖</span>
                    <span>详细介绍</span>
                </h2>
                <div class="content-wrapper" v-html="scenicSpotDetail.content"></div>
            </div>

            <!-- 景点图册 -->
            <div v-if="scenicSpotDetail.brochureList?.length" class="brochure-section">
                <h2 class="section-title">
                    <span class="title-icon">🖼️</span>
                    <span>景点图册 ({{ scenicSpotDetail.brochureList.length }})</span>
                </h2>
                <div class="brochure-grid">
                    <div v-for="(brochure, index) in scenicSpotDetail.brochureList" :key="brochure.id"
                        class="brochure-item" @click="previewImage(brochure.coverUrl, index)">
                        <div class="brochure-image-wrapper">
                            <img :src="brochure.coverUrl" :alt="`图册图片 ${index + 1}`" class="brochure-image"
                                loading="lazy">
                            <div class="image-overlay">
                                <span class="preview-text">点击预览</span>
                            </div>
                            <div class="image-order">
                                第 {{ brochure.orderNumber }} 张
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 空状态提示 -->
            <div v-else class="empty-brochure">
                <div class="empty-icon">🖼️</div>
                <p class="empty-text">暂无景点图册</p>
            </div>
        </div>

        <!-- 加载状态 -->
        <div v-else-if="isLoading" class="loading-container">
            <div class="loading-spinner"></div>
            <p class="loading-text">正在加载景点详情...</p>
        </div>

        <!-- 错误状态 -->
        <div v-else class="error-container">
            <div class="error-icon">❌</div>
            <p class="error-text">景点详情加载失败</p>
            <button class="retry-btn" @click="retryLoad">重试</button>
        </div>

        <!-- 图片预览模态框 -->
        <div v-if="showPreview" class="preview-modal" @click="closePreview">
            <div class="modal-content" @click.stop>
                <button class="modal-close" @click="closePreview">×</button>
                <img :src="currentPreviewImage" :alt="'预览图片'" class="preview-img" />
                <div class="modal-controls">
                    <button class="nav-btn prev-btn" @click="prevImage" :disabled="currentPreviewIndex === 0">
                        ←
                    </button>
                    <span class="image-counter">
                        {{ currentPreviewIndex + 1 }} / {{ previewImages.length }}
                    </span>
                    <button class="nav-btn next-btn" @click="nextImage"
                        :disabled="currentPreviewIndex === previewImages.length - 1">
                        →
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from "vue"
import { useRouter } from "vue-router"
import { getDetailApi } from "@/api/scenic-spot-api"
import type { ScenicSpotVO } from "@/types/scenic-spot.ts"

const router = useRouter()

// 响应式数据
const scenicSpotId = ref<number | null>(null)
const scenicSpotDetail = reactive<Partial<ScenicSpotVO>>({})
const isLoading = ref(false)
const showPreview = ref(false)
const currentPreviewImage = ref('')
const currentPreviewIndex = ref(0)

// 计算属性
const previewImages = computed(() => {
    if (!scenicSpotDetail.brochureList) return []
    return scenicSpotDetail.brochureList
        .sort((a, b) => a.orderNumber - b.orderNumber)
        .map(brochure => brochure.coverUrl)
})

// 获取景点ID
const getScenicSpotIdWithPath = () => {

    const queryId = router.currentRoute.value.query.scenicSpotId
    if (queryId) {
        scenicSpotId.value = Number(queryId)
    }
}

// 获取景点详情
const getScenicSpotDetail = async (id: number | null) => {
    if (!id) {
        console.error("景点ID为空")
        return
    }

    isLoading.value = true
    try {
        const { data } = await getDetailApi(id)
        // 清空原有数据
        Object.keys(scenicSpotDetail).forEach(key => {
            delete scenicSpotDetail[key as keyof ScenicSpotVO]
        })
        // 赋值新数据
        Object.assign(scenicSpotDetail, data)
    } catch (error: any) {
        console.error("查询景点详情异常：", error)
        // 可以添加错误提示
    } finally {
        isLoading.value = false
    }
}

// 图片预览功能
const previewImage = (imageUrl: string, index: number) => {
    if (!scenicSpotDetail.brochureList) return

    const sortedBrochures = scenicSpotDetail.brochureList
        .sort((a, b) => a.orderNumber - b.orderNumber)

    currentPreviewIndex.value = sortedBrochures.findIndex(b => b.coverUrl === imageUrl)
    if (currentPreviewIndex.value === -1) {
        currentPreviewIndex.value = index
    }

    currentPreviewImage.value = imageUrl
    showPreview.value = true
}

const closePreview = () => {
    showPreview.value = false
    currentPreviewImage.value = ''
    currentPreviewIndex.value = 0
}

const nextImage = () => {
    if (currentPreviewIndex.value < previewImages.value.length - 1) {
        currentPreviewIndex.value++
        currentPreviewImage.value = previewImages.value[currentPreviewIndex.value] || ''
    }
}

const prevImage = () => {
    if (currentPreviewIndex.value > 0) {
        currentPreviewIndex.value--
        currentPreviewImage.value = previewImages.value[currentPreviewIndex.value] || ''
    }
}

// 重试加载
const retryLoad = () => {
    if (scenicSpotId.value) {
        getScenicSpotDetail(scenicSpotId.value)
    }
}

onMounted(async () => {
    getScenicSpotIdWithPath()
    if (scenicSpotId.value) {
        await getScenicSpotDetail(scenicSpotId.value)
    }
})
</script>

<style scoped>
/* 基础变量 */
:root {
    --primary-color: #4f46e5;
    --primary-hover: #4338ca;
    --secondary-color: #6b7280;
    --success-color: #10b981;
    --danger-color: #ef4444;
    --warning-color: #f59e0b;
    --border-color: #e5e7eb;
    --bg-color: #f9fafb;
    --card-bg: #ffffff;
    --text-primary: #111827;
    --text-secondary: #6b7280;
    --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
    --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
    --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.2);
    --radius-sm: 0.375rem;
    --radius-md: 0.5rem;
    --radius-lg: 0.75rem;
}

/* 容器样式 */
.scenic-detail-container {
    min-height: 100vh;
    background-color: var(--bg-color);
    padding-bottom: 2rem;
}

/* 返回按钮 */
.back-header {
    background: var(--card-bg);
    padding: 20px;
    border-bottom: 1px solid var(--border-color);
    position: sticky;
    background-color: rgb(255, 255, 255);
    top: -10px;
    z-index: 10;
    box-shadow: var(--shadow-sm);
}

.back-btn {
    background: transparent;
    border: 1px solid var(--border-color);
    border-radius: var(--radius-md);
    padding: 0.5rem 1rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    cursor: pointer;
    color: var(--text-primary);
    font-size: 0.875rem;
    transition: all 0.2s;
}

.back-btn:hover {
    background: var(--bg-color);
    border-color: var(--primary-color);
    color: var(--primary-color);
}

.back-icon {
    font-size: 1.25rem;
}

/* 主要内容 */
.detail-content {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 1rem;
}

/* 封面区域 */
.cover-section {
    position: relative;
    height: 400px;
    border-radius: var(--radius-lg);
    overflow: hidden;
    border-radius: 10px;
    margin: 1rem 0 2rem;
    box-shadow: var(--shadow-lg);
}

.cover-image {
    width: 100%;
    height: 100%;
    border-radius: 20px;
    object-fit: cover;
    padding: 10px;
}

.cover-overlay {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    background: linear-gradient(transparent, rgba(0, 0, 0, 0.8));
    padding: 2rem;
    color: white;
}

.spot-title {
    font-size: 2rem;
    font-weight: 700;
    margin: 0 0 0.5rem 0;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
}

.location-info {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 1rem;
    opacity: 0.9;
}

.location-icon {
    font-size: 1.25rem;
}

/* 信息卡片 */
.info-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
}

.info-card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    padding: 1.5rem;
    background-color: rgb(248, 248, 248);
    border-radius: 6px;
    cursor: pointer;
    box-shadow: var(--shadow-md);
    transition: transform 0.3s, box-shadow 0.3s;

    &:hover{
        background-color: rgb(246,246,246);
    }
}

.info-card:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-lg);
}

.card-title {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 1.25rem;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0 0 1rem 0;
    padding-bottom: 0.75rem;
    border-bottom: 2px solid var(--border-color);
}

.title-icon {
    font-size: 1.5rem;
}

.summary-text {
    line-height: 1.6;
    color: var(--text-secondary);
    margin-bottom: 1rem;
    font-size: 0.95rem;
}

.create-time {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.875rem;
    color: var(--text-secondary);
    margin-top: 1rem;
    padding-top: 1rem;
    border-top: 1px solid var(--border-color);
}

.time-icon {
    font-size: 1rem;
}

.region-info,
.id-info {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}

.region-item,
.id-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.5rem 0;
    border-bottom: 1px solid var(--border-color);
}

.region-item:last-child,
.id-item:last-child {
    border-bottom: none;
}

.region-label,
.id-label {
    font-weight: 500;
    color: var(--text-primary);
}

.region-value,
.id-value {
    color: var(--text-secondary);
    font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
}

/* 内容区域 */
.content-section {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    padding: 2rem;
    margin-bottom: 2rem;
    box-shadow: var(--shadow-md);
}

.section-title {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 1.5rem;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0 0 1.5rem 0;
}

.content-wrapper {
    line-height: 1.8;
    color: var(--text-secondary);
}

.content-wrapper :deep(p) {
    margin: 1rem 0;
}

.content-wrapper :deep(img) {
    max-width: 100%;
    height: auto;
    border-radius: var(--radius-md);
    margin: 1rem 0;
}

/* 图册区域 */
.brochure-section {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    padding: 2rem;
    margin-bottom: 2rem;
    box-shadow: var(--shadow-md);
}

.brochure-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 1.5rem;
    margin-top: 1.5rem;
}

.brochure-item {
    border-radius: var(--radius-md);
    overflow: hidden;
    border: 1px solid var(--border-color);
    transition: all 0.3s;
    cursor: pointer;
}

.brochure-item:hover {
    border-color: var(--primary-color);
    transform: translateY(-2px);
    box-shadow: var(--shadow-lg);
}

.brochure-image-wrapper {
    position: relative;
    height: 200px;
    overflow: hidden;
}

.brochure-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.4s;
}

.brochure-item:hover .brochure-image {
    transform: scale(1.05);
}

.image-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: opacity 0.3s;
}

.brochure-item:hover .image-overlay {
    opacity: 1;
}

.preview-text {
    color: white;
    font-weight: 500;
    font-size: 0.875rem;
    padding: 0.5rem 1rem;
    background: rgba(0, 0, 0, 0.7);
    border-radius: var(--radius-md);
}

.image-order {
    position: absolute;
    top: 0.5rem;
    left: 0.5rem;
    background: rgba(0, 0, 0, 0.7);
    color: white;
    padding: 0.25rem 0.75rem;
    border-radius: var(--radius-sm);
    font-size: 0.75rem;
    font-weight: 500;
}

.brochure-info {
    padding: 1rem;
    background: var(--bg-color);
    border-top: 1px solid var(--border-color);
}

.info-text {
    font-size: 0.875rem;
    color: var(--text-secondary);
    font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
}

/* 空状态 */
.empty-brochure {
    text-align: center;
    padding: 4rem 1rem;
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    color: var(--text-secondary);
    box-shadow: var(--shadow-md);
}

.empty-icon {
    font-size: 4rem;
    margin-bottom: 1rem;
    opacity: 0.5;
}

.empty-text {
    font-size: 1.125rem;
}

/* 加载状态 */
.loading-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 6rem 1rem;
}

.loading-spinner {
    width: 50px;
    height: 50px;
    border: 3px solid var(--border-color);
    border-top-color: var(--primary-color);
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-bottom: 1rem;
}

@keyframes spin {
    to {
        transform: rotate(360deg);
    }
}

.loading-text {
    color: var(--text-secondary);
    font-size: 1.125rem;
}

/* 错误状态 */
.error-container {
    text-align: center;
    padding: 6rem 1rem;
}

.error-icon {
    font-size: 4rem;
    color: var(--danger-color);
    margin-bottom: 1rem;
}

.error-text {
    font-size: 1.25rem;
    color: var(--text-primary);
    margin-bottom: 2rem;
}

.retry-btn {
    background: var(--primary-color);
    color: white;
    border: none;
    border-radius: var(--radius-md);
    padding: 0.75rem 1.5rem;
    font-size: 1rem;
    cursor: pointer;
    transition: background 0.2s;
}

.retry-btn:hover {
    background: var(--primary-hover);
}

/* 预览模态框 */
.preview-modal {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.9);
    z-index: 1000;
    display: flex;
    align-items: center;
    justify-content: center;
    animation: fadeIn 0.2s ease;
}

@keyframes fadeIn {
    from {
        opacity: 0;
    }

    to {
        opacity: 1;
    }
}

.modal-content {
    position: relative;
    max-width: 90vw;
    max-height: 90vh;
}

.modal-close {
    position: absolute;
    top: -50px;
    right: 0;
    background: none;
    border: none;
    color: white;
    font-size: 2.5rem;
    cursor: pointer;
    padding: 0.5rem;
    opacity: 0.7;
    transition: opacity 0.2s;
}

.modal-close:hover {
    opacity: 1;
}

.preview-img {
    max-width: 100%;
    max-height: 70vh;
    object-fit: contain;
    border-radius: var(--radius-md);
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
}

.modal-controls {
    position: absolute;
    bottom: -60px;
    left: 0;
    right: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 2rem;
    color: white;
}

.nav-btn {
    background: rgba(255, 255, 255, 0.2);
    border: none;
    color: white;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    font-size: 1.5rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
}

.nav-btn:hover:not(:disabled) {
    background: rgba(255, 255, 255, 0.3);
    transform: scale(1.1);
}

.nav-btn:disabled {
    opacity: 0.3;
    cursor: not-allowed;
}

.image-counter {
    font-size: 1rem;
    opacity: 0.8;
    min-width: 80px;
    text-align: center;
}

/* 响应式设计 */
@media (max-width: 768px) {
    .cover-section {
        height: 300px;
    }

    .spot-title {
        font-size: 1.5rem;
    }

    .info-cards {
        grid-template-columns: 1fr;
    }

    .brochure-grid {
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 1rem;
    }

    .content-section,
    .brochure-section {
        padding: 1.5rem;
    }
}

@media (max-width: 480px) {
    .cover-section {
        height: 200px;
    }

    .spot-title {
        font-size: 1.25rem;
    }

    .brochure-grid {
        grid-template-columns: 1fr;
    }

    .modal-controls {
        bottom: -80px;
    }
}
</style>