<template>
    <div class="detail-page">
        <section class="detail-hero" v-if="scenicSpotDetail.coverUrl">
            <div class="hero-image">
                <img :src="scenicSpotDetail.coverUrl" :alt="scenicSpotDetail.title" />
            </div>
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <div class="hero-breadcrumb">
                    <span @click="$router.push('/user/user-main')">首页</span>
                    <span class="sep">/</span>
                    <span>景点详情</span>
                </div>
                <h1 class="hero-title">{{ scenicSpotDetail.title }}</h1>
                <div class="hero-meta">
                    <span class="meta-item" v-for="category in categoryList" :key="category.id">
                        <span class="meta-tag">{{ category.name }}</span>
                    </span>
                    <span class="meta-item" v-if="scenicSpotDetail.countyName">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/>
                        </svg>
                        {{ [scenicSpotDetail.countyName, scenicSpotDetail.townName, scenicSpotDetail.villageName].filter(Boolean).join('·') }}
                    </span>
                </div>
                <div class="hero-stats">
                    <div class="stat-item">
                        <span class="stat-value">{{ scenicSpotDetail.viewCount || 0 }}</span>
                        <span class="stat-label">阅读</span>
                    </div>
                    <div class="stat-divider"></div>
                    <div class="stat-item">
                        <span class="stat-value">{{ scenicSpotDetail.upvoteCount || 0 }}</span>
                        <span class="stat-label">点赞</span>
                    </div>
                    <div class="stat-divider"></div>
                    <div class="stat-item">
                        <span class="stat-value">{{ scenicSpotDetail.collectionCount || 0 }}</span>
                        <span class="stat-label">收藏</span>
                    </div>
                </div>
                <div class="hero-actions">
                    <div class="action-btn" :class="{ active: collectionStatus }" @click="collectionOperation">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                        </svg>
                        {{ collectionStatus ? '已收藏' : '收藏' }}
                    </div>
                    <div class="action-btn" :class="{ active: upvoteStatus }" @click="upvoteOperation">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3zM7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3"/>
                        </svg>
                        {{ upvoteStatus ? '已点赞' : '点赞' }}
                    </div>
                </div>
            </div>
        </section>

        <section class="detail-summary" v-if="scenicSpotDetail.summary">
            <div class="summary-inner">
                <div class="summary-badge">OVERVIEW</div>
                <p class="summary-text">{{ scenicSpotDetail.summary }}</p>
            </div>
        </section>

        <section class="detail-gallery" v-if="scenicSpotDetail.brochureList && scenicSpotDetail.brochureList.length">
            <div class="gallery-inner">
                <div class="section-header">
                    <h2 class="section-title">景点图册</h2>
                    <span class="section-count">{{ scenicSpotDetail.brochureList.length }} 张</span>
                </div>
                <div class="gallery-grid">
                    <div v-for="(brochure, index) in scenicSpotDetail.brochureList" :key="brochure.id"
                        class="gallery-item" :class="{ 'gallery-item-large': index === 0 }"
                        @click="previewImage(brochure.coverUrl, index)">
                        <img :src="brochure.coverUrl" :alt="`图册 ${index + 1}`" loading="lazy" />
                        <div class="gallery-overlay">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                                <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                                <path d="M11 8v6M8 11h6"/>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="detail-tabs">
            <div class="tabs-inner">
                <div v-for="tab in tabs" :key="tab.value" class="tab-item"
                    :class="{ active: tabIndex === tab.value }" @click="handleTabChange(tab)">
                    <span class="tab-icon">{{ tab.icon }}</span>
                    {{ tab.name }}
                </div>
            </div>
        </section>

        <section class="detail-content">
            <div class="content-inner">
                <div v-if="tabIndex === 1" class="intro-section">
                    <div class="content-wrapper" v-html="scenicSpotDetail.content"></div>
                </div>

                <div v-if="tabIndex === 2">
                    <Comment v-if="userInfo" :currentUserId="Number(userInfo.id)" :userAvatar="String(userInfo.avatar)"
                        :username="String(userInfo.username)" :contentId="Number(scenicSpotDetail.id)"
                        :contentType="contentModule" />
                </div>

                <div v-if="tabIndex === 3" class="route-section">
                    <UserScenicSpotRouteItem :scenic-spot-id="scenicSpotDetail.id" />
                </div>

                <div v-if="tabIndex === 4" class="strategy-section">
                    <div v-if="!scenicSpotStrategyListVO.length" class="empty-state">
                        <div class="empty-icon">📝</div>
                        <div class="empty-text">暂无关联攻略</div>
                    </div>
                    <div v-else>
                        <ScenicSpotWithStrategyItem key="hot-scenic-spot-strategy" @view="viewStrategy"
                            @search="goScenicSpotStrategySearch" title="与之相关的景点攻略" subTitle="真知灼见，看你想看"
                            :scenic-spot-strategy-list="scenicSpotStrategyListVO" />
                    </div>
                </div>

                <div v-if="tabIndex === 5" class="ticket-section">
                    <UserScenicSpotTickets :scenic-spot-id="scenicSpotDetail.id" />
                </div>
            </div>
        </section>

        <div v-if="showPreview" class="preview-modal" @click="closePreview">
            <div class="modal-content" @click.stop>
                <button class="modal-close" @click="closePreview">×</button>
                <img :src="currentPreviewImage" alt="预览图片" class="preview-img" />
                <div class="modal-controls">
                    <button class="nav-btn" @click="prevImage" :disabled="currentPreviewIndex === 0">←</button>
                    <span class="image-counter">{{ currentPreviewIndex + 1 }} / {{ previewImages.length }}</span>
                    <button class="nav-btn" @click="nextImage" :disabled="currentPreviewIndex === previewImages.length - 1">→</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ElNotification, ElMessage } from "element-plus"
import { ref, reactive, onMounted, onUnmounted, computed } from "vue"
import ScenicSpotWithStrategyItem from "@/components/ScenicSpotWithStrategyItem.vue"
import UserScenicSpotRouteItem from "./UserScenicSpotRouteItem.vue"
import UserScenicSpotTickets from "./UserScenicSpotTickets.vue"
import { getUserInfo } from "@/utils/storage"
import Comment from "@/components/Comment.vue"
import { useRouter } from "vue-router"
import { onBeforeRouteLeave } from 'vue-router'
import { getDetailApi } from "@/api/scenic-spot-api"
import type { ScenicSpotVO } from "@/types/scenic-spot"
import type { ScenicSpotStrategyListVO } from "@/types/scenic-spot-strategy"
import type { User } from "@/types/user"
import type { UserActionOperation, UserActionOperationQueryDTO } from "@/types/user-action-operation"
import { collectionApi, upvoteApi, saveOperationApi, queryApi } from "@/api/user-action-operation-api"
import { queryStrategyByScenicSpotIdApi } from "@/api/scenic-spot-strategy-api"
import type { Category } from "@/types/category"
import { queryCategoryListByScenicSpotIdApi } from "@/api/category-api"

const router = useRouter()
const tabs = [
    { value: 1, name: '景点介绍', icon: '📖' },
    { value: 2, name: '评论', icon: '💬' },
    { value: 3, name: '交通路线', icon: '🗺️' },
    { value: 4, name: '攻略', icon: '📝' },
    { value: 5, name: '门票信息', icon: '🎫' }
]

const scenicSpotId = ref<number | null>(null)
const scenicSpotDetail = reactive<Partial<ScenicSpotVO>>({})
const isLoading = ref(false)
const showPreview = ref(false)
const currentPreviewImage = ref('')
const currentPreviewIndex = ref(0)
const actionOperationType = ref({ collectionType: 1, upvoteType: 2, viewType: 3, stayType: 4 })
const collectionStatus = ref(false)
const upvoteStatus = ref(false)
const stayStartTime = ref(0)
const contentModule = ref("SCENIC_SPOT")
const tabIndex = ref(1)
const scenicSpotStrategyListVO = ref<ScenicSpotStrategyListVO[]>([])
const userInfo = ref<Partial<User>>({})
const categoryList = ref<Category[]>([])

const loadUserInfo = async () => {
    const user = getUserInfo()
    if (!user) { ElMessage.error('用户信息认证异常'); return }
    userInfo.value = user
}

const goScenicSpotStrategySearch = () => { window.open(`/home-scenic-spot-strategy-list`) }
const viewStrategy = (id: number) => { window.open(`/scenic-spot-strategy-detail?scenicSpotStrategyId=${id}`) }

const previewImages = computed(() => {
    if (!scenicSpotDetail.brochureList) return []
    return scenicSpotDetail.brochureList.sort((a, b) => a.orderNumber - b.orderNumber).map(b => b.coverUrl)
})

const handleTabChange = (tab: any) => { tabIndex.value = tab.value }

const getScenicSpotIdWithPath = () => {
    const queryId = router.currentRoute.value.query.scenicSpotId
    if (queryId) scenicSpotId.value = Number(queryId)
}

const upvoteOperation = async () => {
    try {
        if (!scenicSpotId.value) return
        const op: UserActionOperation = { contentModule: contentModule.value, contentId: scenicSpotId.value }
        await upvoteApi(op)
        ElMessage.success(upvoteStatus.value ? '取消点赞成功' : '点赞成功')
        upvoteStatus.value = !upvoteStatus.value
        await getScenicSpotDetail(scenicSpotId.value)
    } catch (error: any) {
        ElNotification.warning({ title: '用户操作', message: error, duration: 1500, position: 'top-right' })
    }
}

const handleVisibilityChange = () => { if (document.hidden) recordStayOperation() }

const recordStayOperation = async () => {
    try {
        if (!scenicSpotId.value || stayStartTime.value === 0) return
        const stayDuration = Date.now() - stayStartTime.value
        const op: UserActionOperation = { contentModule: contentModule.value, contentId: scenicSpotId.value, type: actionOperationType.value.stayType, stayTime: stayDuration }
        await saveOperationApi(op)
    } catch (error: any) { console.error("记录用户停留行为操作异常:", error) }
}

const recordViewOperation = async () => {
    try {
        if (!scenicSpotId.value) return
        const op: UserActionOperation = { contentModule: contentModule.value, contentId: scenicSpotId.value, type: actionOperationType.value.viewType }
        await saveOperationApi(op)
    } catch (error: any) { console.error("记录用户浏览行为操作异常:", error) }
}

const collectionOperation = async () => {
    try {
        if (!scenicSpotId.value) return
        const op: UserActionOperation = { contentModule: contentModule.value, contentId: scenicSpotId.value }
        await collectionApi(op)
        ElNotification.success({ title: '用户操作', message: collectionStatus.value ? '取消收藏成功' : '收藏成功', duration: 1500, position: 'top-right' })
        collectionStatus.value = !collectionStatus.value
        await getScenicSpotDetail(scenicSpotId.value)
    } catch (error: any) {
        ElNotification.warning({ title: '用户操作', message: error, duration: 1500, position: 'top-right' })
    }
}

const fetchCollectionStatus = async () => {
    try {
        if (!scenicSpotId.value) return
        const dto: UserActionOperationQueryDTO = { contentModule: contentModule.value, contentId: scenicSpotId.value, type: actionOperationType.value.collectionType }
        const { data } = await queryApi(dto)
        collectionStatus.value = data.length > 0
    } catch (error: any) { console.error("查询收藏状态异常:", error) }
}

const fetchUpvoteStatus = async () => {
    try {
        if (!scenicSpotId.value) return
        const dto: UserActionOperationQueryDTO = { contentModule: contentModule.value, contentId: scenicSpotId.value, type: actionOperationType.value.upvoteType }
        const { data } = await queryApi(dto)
        upvoteStatus.value = data.length > 0
    } catch (error: any) { console.error("查询点赞状态异常:", error) }
}

const getScenicSpotDetail = async (id: number | null) => {
    if (!id) return
    isLoading.value = true
    try {
        const { data } = await getDetailApi(id)
        Object.keys(scenicSpotDetail).forEach(key => { delete scenicSpotDetail[key as keyof ScenicSpotVO] })
        Object.assign(scenicSpotDetail, data)
    } catch (error: any) { console.error("查询景点详情异常：", error) }
    finally { isLoading.value = false }
}

const getScenicSpotStrategyList = async (id: number | null) => {
    if (!id) return
    try {
        const { data } = await queryStrategyByScenicSpotIdApi(id)
        scenicSpotStrategyListVO.value = data
    } catch (error: any) { console.error("查询景点攻略异常：", error) }
}

const getCateoryList = async (id: number | null) => {
    if (!id) return
    try {
        const { data } = await queryCategoryListByScenicSpotIdApi(id)
        categoryList.value = data
    } catch (error: any) { console.error("查询类别异常：", error) }
}

const previewImage = (imageUrl: string, index: number) => {
    if (!scenicSpotDetail.brochureList) return
    const sorted = scenicSpotDetail.brochureList.sort((a, b) => a.orderNumber - b.orderNumber)
    currentPreviewIndex.value = sorted.findIndex(b => b.coverUrl === imageUrl)
    if (currentPreviewIndex.value === -1) currentPreviewIndex.value = index
    currentPreviewImage.value = imageUrl
    showPreview.value = true
}

const closePreview = () => { showPreview.value = false; currentPreviewImage.value = ''; currentPreviewIndex.value = 0 }
const nextImage = () => { if (currentPreviewIndex.value < previewImages.value.length - 1) { currentPreviewIndex.value++; currentPreviewImage.value = previewImages.value[currentPreviewIndex.value] || '' } }
const prevImage = () => { if (currentPreviewIndex.value > 0) { currentPreviewIndex.value--; currentPreviewImage.value = previewImages.value[currentPreviewIndex.value] || '' } }

onBeforeRouteLeave(async (to, from, next) => { await recordStayOperation(); next() })
onUnmounted(() => { document.removeEventListener('visibilitychange', handleVisibilityChange); recordStayOperation().catch(e => console.error(e)) })

onMounted(async () => {
    stayStartTime.value = Date.now()
    document.addEventListener('visibilitychange', handleVisibilityChange)
    getScenicSpotIdWithPath()
    if (scenicSpotId.value) {
        await getScenicSpotDetail(scenicSpotId.value)
        await fetchCollectionStatus()
        await fetchUpvoteStatus()
        await recordViewOperation()
        await getScenicSpotStrategyList(scenicSpotId.value)
        await loadUserInfo()
        await getCateoryList(scenicSpotId.value)
    }
})
</script>

<style lang="scss" scoped>
.detail-page { min-height: 100vh; background: var(--bg-color); }

.detail-hero {
    position: relative; height: 70vh; min-height: 500px; overflow: hidden;

    .hero-image { position: absolute; inset: 0; img { width: 100%; height: 100%; object-fit: cover; } }
    .hero-overlay { position: absolute; inset: 0; background: linear-gradient(to top, rgba(10,10,10,0.95) 0%, rgba(10,10,10,0.6) 40%, rgba(10,10,10,0.2) 70%, transparent 100%); }
    .hero-content { position: absolute; bottom: 0; left: 0; right: 0; padding: 60px; max-width: 1200px; margin: 0 auto; }

    .hero-breadcrumb { font-size: 14px; color: rgba(255,255,255,0.5); margin-bottom: 20px; letter-spacing: 1px;
        span { cursor: pointer; transition: color 0.2s; &:hover { color: rgba(255,255,255,0.8); } }
        .sep { margin: 0 8px; cursor: default; }
    }

    .hero-title { font-family: var(--font-serif); font-size: clamp(32px,5vw,56px); font-weight: 700; color: white; letter-spacing: 4px; margin-bottom: 20px; line-height: 1.2; }

    .hero-meta { display: flex; align-items: center; gap: 12px; margin-bottom: 28px; flex-wrap: wrap;
        .meta-item { display: flex; align-items: center; gap: 6px; font-size: 14px; color: rgba(255,255,255,0.6); }
        .meta-tag { padding: 4px 12px; background: rgba(166,27,46,0.3); border: 1px solid rgba(166,27,46,0.5); border-radius: 100px; color: #E38995; font-size: 12px; font-weight: 600; letter-spacing: 1px; }
    }

    .hero-stats { display: flex; align-items: center; gap: 24px; margin-bottom: 24px;
        .stat-item { display: flex; flex-direction: column; align-items: center;
            .stat-value { font-size: 24px; font-weight: 700; color: white; font-family: var(--font-serif); }
            .stat-label { font-size: 12px; color: rgba(255,255,255,0.4); letter-spacing: 2px; margin-top: 4px; }
        }
        .stat-divider { width: 1px; height: 32px; background: rgba(255,255,255,0.15); }
    }

    .hero-actions { display: flex; gap: 12px;
        .action-btn { display: flex; align-items: center; gap: 6px; padding: 10px 24px; border-radius: 100px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.3s; background: rgba(255,255,255,0.1); color: rgba(255,255,255,0.8); border: 1px solid rgba(255,255,255,0.2);
            &:hover { background: rgba(255,255,255,0.2); }
            &.active { background: var(--primary-color); border-color: var(--primary-color); color: white; }
        }
    }
}

.detail-summary { background: white; padding: 48px 0;
    .summary-inner { max-width: 900px; margin: 0 auto; padding: 0 60px; }
    .summary-badge { display: inline-block; padding: 4px 14px; background: rgba(166,27,46,0.08); color: var(--primary-color); font-size: 11px; font-weight: 700; letter-spacing: 3px; border-radius: 100px; margin-bottom: 16px; }
    .summary-text { font-size: 17px; line-height: 1.9; color: var(--text-secondary); letter-spacing: 0.5px; }
}

.detail-gallery { background: var(--bg-color); padding: 60px 0;
    .gallery-inner { max-width: 1200px; margin: 0 auto; padding: 0 60px; }
    .section-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 32px; }
    .section-title { font-family: var(--font-serif); font-size: 28px; font-weight: 700; color: var(--text-main); letter-spacing: 2px; }
    .section-count { font-size: 14px; background: rgba(166,27,46,0.08); padding: 4px 16px; border-radius: 100px; color: var(--primary-color); font-weight: 500; }
    .gallery-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
    .gallery-item { position: relative; border-radius: 12px; overflow: hidden; cursor: pointer; aspect-ratio: 4/3;
        &.gallery-item-large { grid-column: span 2; grid-row: span 2; aspect-ratio: auto; }
        img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s cubic-bezier(0.16,1,0.3,1); }
        .gallery-overlay { position: absolute; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; opacity: 0; transition: opacity 0.3s; }
        &:hover { img { transform: scale(1.08); } .gallery-overlay { opacity: 1; } }
    }
}

.detail-tabs { position: sticky; top: 0; z-index: 100; background: white; border-bottom: 1px solid rgba(0,0,0,0.06);
    .tabs-inner { max-width: 1200px; margin: 0 auto; padding: 0 60px; display: flex; gap: 4px; }
    .tab-item { display: flex; align-items: center; gap: 6px; padding: 16px 24px; cursor: pointer; font-size: 15px; font-weight: 500; color: var(--text-light); letter-spacing: 1px; position: relative; transition: color 0.2s; white-space: nowrap;
        &::after { content: ''; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 0; height: 2px; background: var(--primary-color); transition: width 0.3s; border-radius: 1px; }
        &:hover { color: var(--text-main); }
        &.active { color: var(--primary-color); font-weight: 600; &::after { width: 24px; } }
        .tab-icon { font-size: 14px; }
    }
}

.detail-content { padding: 48px 0 80px; background: white;
    .content-inner { max-width: 900px; margin: 0 auto; padding: 0 60px; }
    .content-wrapper { color: var(--text-secondary); line-height: 1.9; font-size: 16px;
        :deep(p) { margin: 1.5rem 0; }
        :deep(img) { max-width: 100%; height: auto; border-radius: 12px; margin: 2rem 0; }
        :deep(h1), :deep(h2), :deep(h3) { color: var(--text-main); font-family: var(--font-serif); margin: 2rem 0 1rem; }
    }
}

.empty-state { text-align: center; padding: 60px 20px;
    .empty-icon { font-size: 48px; margin-bottom: 16px; }
    .empty-text { font-size: 16px; color: var(--text-light); }
}

.preview-modal { position: fixed; inset: 0; background: rgba(0,0,0,0.92); z-index: 1000; display: flex; align-items: center; justify-content: center; animation: fadeIn 0.2s ease; backdrop-filter: blur(10px); }
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
.modal-content { position: relative; max-width: 90vw; max-height: 90vh; }
.modal-close { position: absolute; top: -50px; right: 0; background: none; border: none; color: white; font-size: 2.5rem; cursor: pointer; opacity: 0.7; transition: opacity 0.2s; &:hover { opacity: 1; } }
.preview-img { max-width: 100%; max-height: 70vh; object-fit: contain; border-radius: 12px; box-shadow: 0 20px 60px rgba(0,0,0,0.5); }
.modal-controls { position: absolute; bottom: -60px; left: 0; right: 0; display: flex; align-items: center; justify-content: center; gap: 2rem; color: white; }
.nav-btn { background: rgba(255,255,255,0.15); border: none; color: white; width: 44px; height: 44px; border-radius: 50%; font-size: 1.5rem; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.2s;
    &:hover:not(:disabled) { background: rgba(255,255,255,0.3); transform: scale(1.1); }
    &:disabled { opacity: 0.3; cursor: not-allowed; }
}
.image-counter { font-size: 1rem; opacity: 0.8; min-width: 80px; text-align: center; }

@media (max-width: 768px) {
    .detail-hero { height: 50vh; min-height: 360px; .hero-content { padding: 32px 24px; } .hero-title { font-size: 28px !important; } .hero-stats .stat-item .stat-value { font-size: 18px; } }
    .detail-summary .summary-inner { padding: 0 24px; }
    .detail-gallery { .gallery-inner { padding: 0 24px; } .gallery-grid { grid-template-columns: repeat(2, 1fr); } .gallery-item.gallery-item-large { grid-column: span 2; grid-row: span 1; } }
    .detail-tabs .tabs-inner { padding: 0 24px; overflow-x: auto; }
    .detail-content .content-inner { padding: 0 24px; }
}
</style>
