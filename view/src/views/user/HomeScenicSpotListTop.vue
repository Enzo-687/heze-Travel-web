<template>
    <div class="scenic-spot-top-container">
        <!-- 最近票务行程 -->
        <div class="itinerary-section">
            <div class="section-head">
                <div class="head-left">
                    <span class="section-badge">ITINERARY</span>
                    <h3 class="section-title">票务行程</h3>
                    <p class="section-sub">基于您的门票，智能生成行程安排</p>
                </div>
                <div class="head-right" @click="goTicketOrders">
                    <span>全部订单</span>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M5 12h14M12 5l7 7-7 7"/>
                    </svg>
                </div>
            </div>

            <div v-if="itineraryList.length > 0" class="itinerary-scroll">
                <div class="itinerary-track">
                    <div
                        v-for="item in itineraryList"
                        :key="item.order.id"
                        class="itinerary-card"
                        :class="'status-' + item.order.status"
                    >
                        <div class="card-top">
                            <div class="card-status" :class="'status-' + item.order.status">
                                <span class="status-dot"></span>
                                {{ statusLabel(item.order.status) }}
                            </div>
                            <div class="card-date">{{ formatDate(item.order.useTime || item.order.createTime) }}</div>
                        </div>
                        <h4 class="card-title">{{ item.scenicName || '景点门票' }}</h4>
                        <div class="card-meta">
                            <span>{{ formatDateRange(item.order) }}</span>
                            <span>{{ item.order.buyNumber }}人</span>
                            <span v-if="item.order.price">¥{{ item.order.price }}</span>
                        </div>
                        <div class="card-reminder" v-if="getReminder(item)">⏰ {{ getReminder(item) }}</div>
                        <div class="card-action" v-if="item.order.status === 3" @click="goScenicDetail(item.order.scenicSpotTicketId)">查看景点</div>
                        <div class="card-action unpaid" v-if="item.order.status === 1" @click="goTicketOrders">去支付</div>
                    </div>
                </div>
            </div>

            <div v-else class="itinerary-empty">
                <div class="empty-icon">🎫</div>
                <div class="empty-text">暂无票务行程</div>
                <div class="empty-hint">购买门票后，系统将自动为您生成行程安排</div>
                <div class="empty-action" @click="goScenicSpotSearch">去逛逛景点</div>
            </div>
        </div>

        <!-- 景点推荐 -->
        <div>
            <ScenicSpotItem key="recommend-scenic-spot" @search="goScenicSpotSearch" @view-detail="goDetail"
                badge="RECOMMEND" title="景点推荐" subTitle="大家爱看，有你爱看" :scenic-spot-list="recommendScenicSpotList" />
        </div>

        <!-- 特色美食 -->
        <div>
            <div class="food-section">
                <div class="section-head">
                    <div class="head-left">
                        <span class="section-badge">FOOD</span>
                        <h3 class="section-title">特色美食</h3>
                        <p class="section-sub">菏泽地道风味，舌尖上的千年古韵</p>
                    </div>
                    <div class="head-right" @click="goFoodList">
                        <span>查看全部</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M5 12h14M12 5l7 7-7 7"/>
                        </svg>
                    </div>
                </div>
                <div class="food-grid">
                    <div
                        v-for="(food, index) in foodList"
                        :key="food.id"
                        class="food-card"
                        @click="goFoodDetail(food.id)"
                    >
                        <div class="card-cover">
                            <img :src="food.coverUrl" :alt="food.name" />
                            <div class="cover-overlay">
                                <span class="cover-index">{{ String(index + 1).padStart(2, '0') }}</span>
                            </div>
                        </div>
                        <div class="card-body">
                            <h4 class="card-title">{{ food.name }}</h4>
                            <div class="card-tag">{{ food.tag }}</div>
                            <p class="card-desc">{{ food.description }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ElMessage } from "element-plus"
import { ref, reactive, computed, onMounted, onUnmounted } from "vue"
import ScenicSpotItem from "@/components/ScenicSpotItem.vue"
import { useRouter } from "vue-router"
import type { ScenicSpotListVO, ScenicSpotQueryDTO } from "@/types/scenic-spot"
import type { ScenicSpotTicketOrderVO, ScenicSpotTicketOrderQueryDTO } from "@/types/scenic-spot-ticket-order"
import type { Food, FoodQueryDTO } from "@/types/food"
import {
    queryScenicSpotApi,
    queryRecommendApi
} from "@/api/scenic-spot-api"
import { queryUserScenicSpotTicketOrdersApi } from "@/api/scenic-spot-ticket-orders-api"
import { queryFoodApi } from "@/api/food-api"

const recommendScenicSpotList = ref<ScenicSpotListVO[]>([])
const foodList = ref<Food[]>([])
const recommendScenicSpotCount = ref(5)
const ticketOrders = ref<ScenicSpotTicketOrderVO[]>([])

interface ItineraryItem {
    order: ScenicSpotTicketOrderVO
    scenicName: string
}

const itineraryList = computed<ItineraryItem[]>(() => {
    const validStatuses = [1, 2, 3]
    const filtered = ticketOrders.value.filter(o => o.status && validStatuses.includes(o.status))
    filtered.sort((a, b) => {
        const dateA = a.useTime || a.createTime || ''
        const dateB = b.useTime || b.createTime || ''
        return new Date(dateB).getTime() - new Date(dateA).getTime()
    })
    return filtered.slice(0, 5).map(order => ({
        order,
        scenicName: order.detail || '景点门票'
    }))
})

const router = useRouter()

const statusLabel = (status: number | null) => {
    switch (status) {
        case 1: return '待付款'
        case 2: return '已核销'
        case 3: return '待使用'
        case 4: return '已取消'
        default: return '未知'
    }
}

const formatDay = (date: Date | string | null) => {
    if (!date) return '--'
    const d = new Date(date)
    return d.getDate()
}

const formatMonth = (date: Date | string | null) => {
    if (!date) return ''
    const d = new Date(date)
    const months = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
    return months[d.getMonth()]
}

const formatDate = (date: Date | string | null) => {
    if (!date) return ''
    const d = new Date(date)
    return `${d.getMonth() + 1}月${d.getDate()}日`
}

const formatDateRange = (order: ScenicSpotTicketOrderVO) => {
    const start = (order as any).startDate
    const end = (order as any).endDate
    if (start && end) {
        return `${formatShortDate(start)} - ${formatShortDate(end)}`
    }
    if (start) return `${formatShortDate(start)} 起`
    return '有效期详询景区'
}

const formatShortDate = (date: Date | string | null) => {
    if (!date) return ''
    const d = new Date(date)
    return `${d.getMonth() + 1}/${d.getDate()}`
}

const getSuggestion = (item: ItineraryItem) => {
    const suggestions = [
        '建议上午9:00前到达，避开人流高峰，游览体验更佳',
        '推荐游览时长2-3小时，建议穿着舒适的步行鞋',
        '景区内有多处打卡点，建议预留充足时间拍照留念',
        '建议携带防晒用品和饮用水，注意天气变化',
        '周边有特色美食街，游览后可品尝当地风味'
    ]
    const idx = (item.order.id || 0) % suggestions.length
    return suggestions[idx]
}

const getReminder = (item: ItineraryItem) => {
    if (item.order.status === 3) {
        const end = (item.order as any).endDate
        if (end) {
            const endDate = new Date(end)
            const now = new Date()
            const diffDays = Math.ceil((endDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24))
            if (diffDays <= 0) return '门票已过期，请尽快使用或联系客服'
            if (diffDays <= 3) return `门票即将过期，还剩${diffDays}天，请尽快安排出行`
            if (diffDays <= 7) return `门票有效期还剩${diffDays}天，建议提前规划行程`
        }
        return '门票待使用，请合理安排出行时间'
    }
    if (item.order.status === 1) return '订单待付款，请尽快完成支付'
    return ''
}

const goDetail = (id: number) => {
    window.open(`/scenic-spot-info?scenicSpotId=${id}`)
}

const goScenicSpotSearch = () => {
    window.open(`/home-scenic-spot-list`)
}

const goScenicDetail = (ticketId: number | null) => {
    if (ticketId) window.open(`/home-scenic-spot-list`)
}

const goTicketOrders = () => {
    window.open(`/scenic-spot-ticket-order`)
}

const goFoodDetail = (id: number) => {
    window.open(`/viewer-food-detail?id=${id}`)
}

const goFoodList = () => {
    window.open(`/viewer-food`)
}

const fetchTicketOrders = async () => {
    try {
        const { data } = await queryUserScenicSpotTicketOrdersApi({ current: 1, size: 10 } as ScenicSpotTicketOrderQueryDTO)
        ticketOrders.value = data
    } catch (error: any) {
        console.error('查询门票订单异常：', error)
    }
}

const fetchRecommendScenicSpotList = async () => {
    try {
        const { data } = await queryRecommendApi(recommendScenicSpotCount.value)
        recommendScenicSpotList.value = data
    } catch (error: any) {
        console.error('查询推荐的景点数据异常：', error)
    }
}

const fetchFoodList = async () => {
    try {
        const { data } = await queryFoodApi({ current: 1, size: 5 } as FoodQueryDTO)
        foodList.value = data
    } catch (error: any) {
        console.error('查询美食数据异常：', error)
    }
}

onMounted(async () => {
    await fetchTicketOrders()
    await fetchRecommendScenicSpotList()
    await fetchFoodList()
    startAutoRefresh()
})

let refreshTimer: ReturnType<typeof setInterval> | null = null

const startAutoRefresh = () => {
    refreshTimer = setInterval(async () => {
        await fetchTicketOrders()
    }, 30000)
}

onUnmounted(() => {
    if (refreshTimer) {
        clearInterval(refreshTimer)
        refreshTimer = null
    }
})
</script>

<style lang="scss" scoped>
.section-head {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    margin-bottom: 28px;
    gap: 16px;

    .head-left {
        .section-badge {
            display: inline-block;
            padding: 4px 12px;
            background: rgba(166, 27, 46, 0.08);
            color: var(--primary-color);
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 2px;
            border-radius: 100px;
            margin-bottom: 10px;
        }

        .section-title {
            font-family: var(--font-serif);
            font-size: 24px;
            font-weight: 700;
            color: var(--text-main);
            letter-spacing: 2px;
            margin-bottom: 4px;
        }

        .section-sub {
            font-size: 14px;
            color: var(--text-light);
            letter-spacing: 1px;
        }
    }

    .head-right {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        font-size: 14px;
        font-weight: 500;
        color: var(--primary-color);
        cursor: pointer;
        transition: all 0.3s;
        letter-spacing: 1px;
        flex-shrink: 0;
        padding: 8px 20px;
        border-radius: 100px;
        border: 1px solid rgba(166, 27, 46, 0.2);

        &:hover {
            background: rgba(166, 27, 46, 0.06);
            border-color: var(--primary-color);
        }
    }
}

.itinerary-section {
    margin-bottom: 56px;
}

.itinerary-scroll {
    overflow-x: auto;
    overflow-y: hidden;
    -webkit-overflow-scrolling: touch;
    scrollbar-width: none;
    padding-bottom: 4px;

    &::-webkit-scrollbar { display: none; }
}

.itinerary-track {
    display: flex;
    gap: 16px;
    width: max-content;
}

.itinerary-card {
    width: 260px;
    flex-shrink: 0;
    background: var(--bg-card);
    border: 1px solid var(--border-color);
    border-radius: 14px;
    padding: 18px;
    transition: all 0.3s;

    &:hover {
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
        border-color: rgba(166, 27, 46, 0.15);
    }

    .card-top {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 10px;
    }

    .card-status {
        display: flex;
        align-items: center;
        gap: 5px;
        font-size: 12px;
        font-weight: 600;
        letter-spacing: 1px;

        .status-dot {
            width: 5px;
            height: 5px;
            border-radius: 50%;
        }

        &.status-1 { color: #E6A23C; .status-dot { background: #E6A23C; } }
        &.status-2 { color: #67C23A; .status-dot { background: #67C23A; } }
        &.status-3 { color: var(--primary-color); .status-dot { background: var(--primary-color); } }
        &.status-4 { color: var(--text-light); .status-dot { background: var(--text-light); } }
    }

    .card-date {
        font-size: 12px;
        color: var(--text-light);
    }

    .card-title {
        font-size: 15px;
        font-weight: 600;
        color: var(--text-main);
        letter-spacing: 0.5px;
        margin-bottom: 8px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .card-meta {
        display: flex;
        gap: 12px;
        font-size: 12px;
        color: var(--text-light);
        margin-bottom: 10px;

        span {
            white-space: nowrap;
        }
    }

    .card-reminder {
        font-size: 12px;
        color: #E6A23C;
        background: rgba(230, 162, 60, 0.06);
        padding: 6px 10px;
        border-radius: 8px;
        margin-bottom: 10px;
        line-height: 1.5;
    }

    .card-action {
        display: inline-flex;
        padding: 6px 18px;
        background: var(--primary-color);
        color: white;
        border-radius: 100px;
        font-size: 12px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;

        &:hover {
            background: var(--primary-light);
        }

        &.unpaid {
            background: #E6A23C;
            &:hover { background: #c78a2e; }
        }
    }
}

.itinerary-empty {
    text-align: center;
    padding: 40px 20px;
    background: var(--bg-card);
    border: 1px dashed var(--border-color);
    border-radius: 14px;

    .empty-icon { font-size: 36px; margin-bottom: 12px; }
    .empty-text { font-size: 15px; font-weight: 600; color: var(--text-main); margin-bottom: 6px; }
    .empty-hint { font-size: 13px; color: var(--text-light); margin-bottom: 20px; }

    .empty-action {
        display: inline-flex;
        padding: 10px 28px;
        background: var(--primary-color);
        color: white;
        border-radius: 100px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;

        &:hover {
            background: var(--primary-light);
            transform: translateY(-1px);
        }
    }
}

.food-section { margin-bottom: 56px; }

.food-grid {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 20px;
}

.food-card {
    background: var(--bg-card);
    border: 1px solid var(--border-color);
    border-radius: 16px;
    overflow: hidden;
    cursor: pointer;
    transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);

    &:hover {
        transform: translateY(-6px);
        box-shadow: 0 16px 48px rgba(0, 0, 0, 0.08);
        border-color: rgba(166, 27, 46, 0.2);

        .card-cover img { transform: scale(1.06); }
        .cover-overlay { opacity: 1; }
    }

    .card-cover {
        position: relative;
        width: 100%;
        height: 160px;
        overflow: hidden;

        img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease; }

        .cover-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(0, 0, 0, 0.5) 0%, transparent 50%);
            opacity: 0;
            transition: opacity 0.3s;
            display: flex;
            align-items: flex-end;
            justify-content: flex-end;
            padding: 12px;

            .cover-index {
                font-size: 28px;
                font-weight: 800;
                font-family: var(--font-serif);
                color: rgba(255, 255, 255, 0.25);
                line-height: 1;
            }
        }
    }

    .card-body {
        padding: 16px;

        .card-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-main);
            margin-bottom: 6px;
            letter-spacing: 0.5px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .card-tag {
            display: inline-block;
            padding: 2px 10px;
            background: rgba(166, 27, 46, 0.06);
            color: var(--primary-color);
            font-size: 11px;
            font-weight: 500;
            border-radius: 100px;
            margin-bottom: 8px;
            letter-spacing: 1px;
        }

        .card-desc {
            font-size: 13px;
            color: var(--text-light);
            line-height: 1.6;
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    }
}

@media (max-width: 1200px) {
    .food-grid { grid-template-columns: repeat(4, 1fr); }
}

@media (max-width: 1024px) {
    .food-grid { grid-template-columns: repeat(3, 1fr); }
}

@media (max-width: 768px) {
    .food-grid { grid-template-columns: repeat(2, 1fr); gap: 14px; }
    .food-card .card-cover { height: 130px; }

    .itinerary-card .itinerary-content { padding: 16px; }
    .itinerary-meta { gap: 12px !important; }
}

@media (max-width: 480px) {
    .food-grid { grid-template-columns: 1fr; }
}
</style>
