<template>
    <div class="scenic-detail-container">

        <div
            style="padding-inline: 340px;padding-block: 10px;position: sticky;top: 0px;z-index: 100;background-color: rgb(255,255,255);">
            <div style="margin-block: 20px;display: flex;justify-content: left;align-items: center;gap: 10px;">
                <img style="width: 40px;height: 40px;" src="/logo.png" alt="">
                <div style="font-size: 32px;">菏你同游-在线旅游平台</div>
            </div>
            <div style="font-size: 32px;margin-block: 15px;font-weight: 600;">
                {{ scenicSpotStrategyDetail.title }}
            </div>
        </div>

        <!-- 主要内容 -->
        <div v-if="scenicSpotStrategyDetail.id" class="detail-content">


            <div class="base-info">
                <img :src="scenicSpotStrategyDetail.avatar" alt="" srcset="">
                <span style="font-size: 24px;">{{ scenicSpotStrategyDetail.username }}</span>
            </div>
            <div
                style="color: rgb(148,148,148);margin-bottom: 20px;padding-inline: 6px;font-size: 18px;display: flex;justify-content: space-between;">
                <span>发布于{{ scenicSpotStrategyDetail.createTime }}</span>
                <div style="display: flex;gap: 10px;">
                    <span>{{ scenicSpotStrategyDetail.viewCount }}人阅读</span>
                    <span>{{ scenicSpotStrategyDetail.upvoteCount }}人点赞</span>
                    <span>{{ scenicSpotStrategyDetail.collectionCount }}人收藏</span>
                </div>
            </div>

            <!-- 基本信息卡片 -->
            <div class="info-cards">

                <!-- 摘要卡片 -->
                <div class="summary-card info-card">
                    <p class="summary-text">
                        <span style="font-size: 16px;" class="text">{{ scenicSpotStrategyDetail.summary }}</span>
                    </p>
                </div>
            </div>

            <div
                style="margin-top: 40px;margin-bottom: 20px;display: flex;justify-content: left;align-items: center;gap: 10px;">
                <div :style="{
                    backgroundColor: tabIndex === tab.value ? 'rgb(244,245,246)' : '',
                    fontWeight: tabIndex === tab.value ? '600' : ''
                }" class="tab-item" v-for="tab in tabs" @click="handleTabChange(tab)">
                    {{ tab.name }}
                </div>
            </div>

            <!-- 跳转登录页 -->
            <div style="background-color: rgb(250,250,250);margin-bottom: 20px;padding: 50px 20px;">
                <div style="text-align: center;color: rgb(51,51,51);font-size: 16px;font-weight: 600;">登录后，体验完整功能</div>
                <div style="display: flex;justify-content: center;align-items: center;margin-top: 10px;">
                    <el-button @click="$router.push('/login')" type="primary" round>立即登录</el-button>
                </div>
            </div>

            <!-- 详细内容 -->
            <div class="content-section" v-if="tabIndex === 1">
                <div class="content-wrapper" v-html="scenicSpotStrategyDetail.content"></div>
            </div>
            <!-- 用户评论 -->
            <div class="content-section" v-if="tabIndex === 2">
                <ViewerComment :contentId="Number(scenicSpotStrategyDetail.id)" :contentType="contentModule" />
            </div>
        </div>

        <!-- 加载状态 -->
        <div v-else-if="isLoading" class="loading-container">
            <div class="loading-spinner"></div>
            <p class="loading-text">正在加载景点攻略详情...</p>
        </div>

        <!-- 错误状态 -->
        <div v-else class="error-container">
            <div class="error-icon">❌</div>
            <p class="error-text">景点攻略详情加载失败</p>
            <button class="retry-btn" @click="retryLoad">重试</button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue"
import ViewerComment from "@/components/ViewerComment.vue"
import { useRouter } from "vue-router"
import {
    queryScenciSpotStrategyDetailByViewerApi
} from "@/api/viewer-api"
import type { ScenicSpotStrategyDetailVO } from "@/types/scenic-spot-strategy.ts"

const tabs = [{ value: 1, name: '内容详情' }, { value: 2, name: '评论' }]
const tabIndex = ref(1) // 初始Tab为介绍
const router = useRouter()

// 响应式数据
const scenicSpotStrategyId = ref<number | null>(null)
const scenicSpotStrategyDetail = reactive<Partial<ScenicSpotStrategyDetailVO>>({})
const isLoading = ref(false)

const contentModule = ref("SCENIC_SPOT_STRATEGY")

const handleTabChange = (tab: any) => {
    tabIndex.value = tab.value
}

// 获取景点ID
const getscenicSpotStrategyIdWithPath = () => {

    const queryId = router.currentRoute.value.query.scenicSpotStrategyId
    if (queryId) {
        scenicSpotStrategyId.value = Number(queryId)
    }

}

// 获取景点详情
const getscenicSpotStrategyDetail = async (id: number | null) => {
    if (!id) {
        console.error("景点ID为空")
        return
    }

    isLoading.value = true
    try {
        const { data } = await queryScenciSpotStrategyDetailByViewerApi(id)
        // 赋值新数据
        Object.assign(scenicSpotStrategyDetail, data)
    } catch (error: any) {
        console.error("查询景点详情异常：", error)
        // 可以添加错误提示
    } finally {
        isLoading.value = false
    }
}

// 重试加载
const retryLoad = () => {
    if (scenicSpotStrategyId.value) {
        getscenicSpotStrategyDetail(scenicSpotStrategyId.value)
    }
}


onMounted(async () => {
    getscenicSpotStrategyIdWithPath()
    if (scenicSpotStrategyId.value) {
        await getscenicSpotStrategyDetail(scenicSpotStrategyId.value)
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
    --bg-color: #f1f1f1;
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

.tab-item {
    padding: 6px 30px;
    cursor: pointer;
    border-radius: 30px;
    font-size: 18px;
}

.title {
    font-weight: 600;
    font-size: 30px;
}

.location {
    display: flex;
    margin-block: 6px;
    justify-content: left;
    align-items: center;
    gap: 10px;
    font-size: 16px;
    color: #6b7280;
}


.header {
    display: flex;
    width: 100%;
    justify-content: space-between;
    align-items: center;
    padding: 32px 100px;
    position: sticky;
    top: 0;
    background-color: rgb(255, 255, 255);
    z-index: 100;

    .logo {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 10px;
        min-width: 200px;
        flex: 1;

        img {
            width: 30px;
            height: 30px;
        }

        .system-name {
            font-size: 26px;
            color: #333;
            font-weight: 500;
        }
    }
}

/* 容器样式 */
.scenic-detail-container {
    min-height: 100vh;
    background-color: var(--bg-color);
    padding-bottom: 2rem;
}

/* 返回按钮 */
.back-header {
    font-size: 20px;
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
    max-width: 800px;
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

.base-info {
    display: flex;
    justify-content: left;
    align-items: center;
    padding-bottom: 20px;
    gap: 6px;

    img {
        width: 30px;
        border-radius: 50%;
        height: 30px;
    }

    span {
        font-size: 20px;
        color: #6b7280;
    }
}

/* 信息卡片 */
.info-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
}

.info-card:first-child {
    background-color: rgb(250, 250, 250);
    max-height: 350px;
}

.info-card {
    background: var(--card-bg);
    border-radius: var(--radius-lg);
    padding: 1.5rem;
    /* background-color: rgb(248, 248, 248); */
    border-radius: 6px;
    cursor: pointer;
    box-shadow: var(--shadow-md);
    transition: transform 0.3s, box-shadow 0.3s;

    /* &:hover {
        background-color: rgb(246, 246, 246);
    } */
}

.info-card:hover {
    /* transform: translateY(-2px); */
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

    .text {
        font-size: 14px;
        color: rgb(148, 148, 148);
    }
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
    padding: 20px 6px;
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
    /* padding: 2rem; */
    margin-bottom: 2rem;
    box-shadow: var(--shadow-md);
}

.brochure-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.5rem;
    /* margin-top: 1.5rem; */
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
    /* transform: translateY(-2px); */
    box-shadow: var(--shadow-lg);
}

.brochure-image-wrapper {
    position: relative;
    border-radius: 10px;
    height: 200px;
    overflow: hidden;
}

.brochure-image {
    width: 100%;
    height: 100%;
    border-radius: 10px;
    object-fit: cover;
    transition: transform 0.4s;
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
    font-size: 12px;
    transition: opacity 0.3s;
}

.brochure-item:hover .image-overlay {
    opacity: 1;
}

.preview-text {
    color: white;
    font-weight: 500;
    font-size: 12px;
    padding: 2px 6px;
    background: rgb(35, 167, 242);
    border-radius: var(--radius-md);
}

.image-order {
    position: absolute;
    top: 0.5rem;
    left: 0.5rem;
    background: rgb(35, 167, 242);
    color: white;
    padding: 2px 6px;
    border-radius: 20px;
    font-size: 12px;
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