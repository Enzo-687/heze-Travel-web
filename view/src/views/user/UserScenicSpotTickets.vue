<template>
    <div class="ticket-page">
        <div v-if="!scenicSpotTicketList.length" class="empty-state">
            <div class="empty-icon">🎫</div>
            <div class="empty-text">暂无门票信息</div>
        </div>

        <div v-else class="ticket-list">
            <div v-for="ticket in scenicSpotTicketList" :key="ticket.id" class="ticket-card">
                <div class="ticket-left">
                    <div class="ticket-price">
                        <span class="price-label" v-if="ticket.price === 0">免费</span>
                        <template v-else>
                            <span class="price-symbol">¥</span>
                            <span class="price-value">{{ ticket.price }}</span>
                            <span class="price-unit">/人</span>
                        </template>
                    </div>
                    <div class="ticket-title">{{ ticket.title || '景区门票' }}</div>
                </div>
                <div class="ticket-right">
                    <div class="ticket-info">
                        <div class="info-row" v-if="ticket.discountDesc">
                            <span class="info-label">优惠政策</span>
                            <span class="info-value">{{ ticket.discountDesc }}</span>
                        </div>
                        <div class="info-row" v-if="ticket.purchaseDesc">
                            <span class="info-label">购买方式</span>
                            <span class="info-value">{{ ticket.purchaseDesc }}</span>
                        </div>
                        <div class="info-row" v-if="ticket.startDate && ticket.endDate">
                            <span class="info-label">有效期</span>
                            <span class="info-value">{{ ticket.startDate }} 至 {{ ticket.endDate }}</span>
                        </div>
                    </div>
                    <div class="ticket-action">
                        <div class="buy-btn" @click="handleBuyTicket(ticket)">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/>
                            </svg>
                            {{ ticket.price === 0 ? '免费预约' : '立即购票' }}
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <el-dialog title="确认购票" v-model="dialogVisible" width="520px" :close-on-click-modal="false">
            <div class="dialog-ticket-info">
                <div class="dialog-title">{{ scenicSpotTicket.title || '景区门票' }}</div>
                <div class="dialog-price" v-if="scenicSpotTicket.price > 0">
                    ¥{{ scenicSpotTicket.price }}<span>/人</span>
                </div>
                <div class="dialog-price free" v-else>免费</div>
                <div class="dialog-desc" v-if="scenicSpotTicket.discountDesc">{{ scenicSpotTicket.discountDesc }}</div>
            </div>
            <el-form :model="scenicSpotTicketOrder" label-width="100px" ref="formRef" class="dialog-form">
                <el-form-item label="联系人" prop="concatUsername">
                    <el-input v-model="scenicSpotTicketOrder.concatUsername" placeholder="请输入联系人姓名" />
                </el-form-item>
                <el-form-item label="联系电话" prop="concatPhone">
                    <el-input v-model="scenicSpotTicketOrder.concatPhone" placeholder="请输入联系电话" />
                </el-form-item>
                <el-form-item label="身份证号" prop="idcard">
                    <el-input v-model="scenicSpotTicketOrder.idcard" placeholder="请输入身份证号" />
                </el-form-item>
                <el-form-item label="购买数量" prop="buyNumber">
                    <el-input-number v-model="scenicSpotTicketOrder.buyNumber" :min="1" :max="20" />
                </el-form-item>
            </el-form>
            <div class="dialog-total" v-if="scenicSpotTicket.price > 0">
                合计：<span class="total-price">¥{{ totalBuyPrice }}</span>
            </div>
            <template #footer>
                <div class="dialog-footer">
                    <div class="cancel-btn" @click="handleCancel">取消</div>
                    <div class="confirm-btn" @click="handleConfirm">确认订单</div>
                </div>
            </template>
        </el-dialog>
    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from "vue"
import { ElMessage, type FormInstance, ElNotification } from "element-plus"
import { getDetailApi } from "@/api/scenic-spot-api"
import type { ScenicSpotVO } from "@/types/scenic-spot.ts"
import type { ScenicSpotTicket, ScenicSpotTicketQueryDTO } from "@/types/scenic-spot-ticket"
import { queryScenicSpotTicketApi } from "@/api/scenic-spot-ticket-api"
import { useRouter } from "vue-router"
import type { ScenicSpotTicketOrder } from "@/types/scenic-spot-ticket-order"
import { addScenicSpotTicketOrdersApi } from "@/api/scenic-spot-ticket-orders-api"

const scenicSpotDetail = reactive<Partial<ScenicSpotVO>>({})
const isLoading = ref(false)
const formRef = ref<FormInstance>()
const isCreateModel = ref(true)
const dialogVisible = ref(false)

const router = useRouter()

const totalBuyPrice = computed(() => {
    const price = scenicSpotTicket?.price ?? 0
    const quantity = scenicSpotTicketOrder?.buyNumber ?? 1
    const result = price * quantity
    return parseFloat(result.toFixed(2))
})

const props = defineProps({
    scenicSpotId: {
        type: Number,
        default: '',
        required: true
    },
})

const scenicSpotTicketOrder = reactive<Partial<ScenicSpotTicketOrder>>({
    buyNumber: 1
})

const scenicSpotTicket = reactive<ScenicSpotTicket>({
    id: null,
    scenicId: null,
    title: '',
    totalNumber: null,
    price: null,
    discountDesc: '',
    purchaseDesc: '',
    detail: '',
    startDate: null,
    endDate: null,
    status: null
})

const scenicSpotRouteItemQueryDTO = reactive<ScenicSpotTicketQueryDTO>({})

const scenicSpotTicketList = ref<ScenicSpotTicket[]>([])

const handleCancel = () => {
    resetForm()
}

const resetForm = () => {
    dialogVisible.value = false
    Object.assign(scenicSpotTicket, {
        id: null,
        scenicId: null,
        title: '',
        totalNumber: null,
        price: null,
        discountDesc: '',
        purchaseDesc: '',
        detail: '',
        startDate: null,
        endDate: null,
        status: null,
        createTime: null
    })
    Object.assign(scenicSpotTicketOrder, {
        id: null,
        concatUsername: '',
        concatPhone: '',
        Idcard: '',
        buyNumber: 1
    })
}

const handleBuyTicket = (ticket: ScenicSpotTicket) => {
    dialogVisible.value = true
    isCreateModel.value = false
    Object.assign(scenicSpotTicket, { ...ticket })
}

const queryScenicSpotTickets = async () => {
    try {
        scenicSpotRouteItemQueryDTO.scenicSpotId = props.scenicSpotId
        const { data } = await queryScenicSpotTicketApi(scenicSpotRouteItemQueryDTO)
        scenicSpotTicketList.value = data.map((ticket: ScenicSpotTicket) => {
            return {
                switchStatus: ticket.status === 2,
                ...ticket,
            }
        })
    } catch (error: any) {
        console.error("景点门票查询异常：", error)
        ElMessage.error(`景点门票查询异常：${error}`)
    }
}

const handleConfirm = async () => {
    try {
        if (!scenicSpotTicketOrder.concatUsername) {
            ElMessage.warning('联系人必填')
            return
        }
        if (!scenicSpotTicketOrder.concatPhone) {
            ElMessage.warning('联系电话必填')
            return
        }
        if (!scenicSpotTicketOrder.idcard) {
            ElMessage.warning('请填写身份证')
            return
        }
        if (!scenicSpotTicketOrder.buyNumber) {
            ElMessage.warning('请设置有效购票数')
            return
        }
        scenicSpotTicketOrder.scenicSpotTicketId = scenicSpotTicket.id
        await addScenicSpotTicketOrdersApi(scenicSpotTicketOrder as any)
        ElNotification.success({
            title: '订单创建成功',
            message: '创建成功',
            duration: 1500,
            position: 'bottom-right'
        })
        resetForm()
        router.push('/user/scenic-spot-order-ticket-list');
    } catch (error: any) {
        console.error('景点门票订单创建异常', error)
        ElMessage.warning(`${error.message}`)
    }
}

const getScenicSpotDetail = async (id: number | null) => {
    if (!id) return
    isLoading.value = true
    try {
        const { data } = await getDetailApi(id)
        Object.keys(scenicSpotDetail).forEach(key => {
            delete scenicSpotDetail[key as keyof ScenicSpotVO]
        })
        Object.assign(scenicSpotDetail, data)
    } catch (error: any) {
        console.error("查询景点详情异常：", error)
    } finally {
        isLoading.value = false
    }
}

onMounted(async () => {
    if (props.scenicSpotId) {
        await getScenicSpotDetail(props.scenicSpotId)
        await queryScenicSpotTickets()
    }
})
</script>

<style lang="scss" scoped>
.ticket-page {
    max-width: 800px;
}

.empty-state {
    text-align: center;
    padding: 60px 20px;
    .empty-icon { font-size: 40px; margin-bottom: 12px; }
    .empty-text { font-size: 15px; color: var(--text-light); }
}

.ticket-list {
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.ticket-card {
    display: flex;
    border: 1px solid rgba(0, 0, 0, 0.06);
    border-radius: 14px;
    overflow: hidden;
    background: white;
    transition: all 0.3s;

    &:hover {
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
        border-color: rgba(166, 27, 46, 0.12);
    }
}

.ticket-left {
    min-width: 140px;
    padding: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #A61B2E 0%, #7A1220 100%);
    color: white;

    .ticket-price {
        margin-bottom: 6px;

        .price-label {
            font-size: 22px;
            font-weight: 700;
            letter-spacing: 2px;
        }

        .price-symbol { font-size: 16px; font-weight: 500; }
        .price-value { font-size: 32px; font-weight: 700; line-height: 1; }
        .price-unit { font-size: 12px; opacity: 0.7; }
    }

    .ticket-title {
        font-size: 12px;
        opacity: 0.8;
        text-align: center;
        letter-spacing: 1px;
    }
}

.ticket-right {
    flex: 1;
    padding: 18px 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.ticket-info {
    .info-row {
        display: flex;
        gap: 10px;
        margin-bottom: 8px;
        font-size: 13px;
        line-height: 1.6;

        .info-label {
            flex-shrink: 0;
            color: var(--text-secondary);
            font-weight: 500;
            min-width: 56px;
        }

        .info-value {
            color: var(--text-main);
        }
    }
}

.ticket-action {
    display: flex;
    justify-content: flex-end;
    margin-top: 10px;

    .buy-btn {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 8px 20px;
        background: var(--primary-color);
        color: white;
        border-radius: 100px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        letter-spacing: 1px;

        &:hover { background: var(--primary-light); transform: translateY(-1px); }
    }
}

.dialog-ticket-info {
    padding: 16px 20px;
    background: #F8F8F8;
    border-radius: 10px;
    margin-bottom: 20px;

    .dialog-title { font-size: 16px; font-weight: 600; color: var(--text-main); margin-bottom: 8px; }
    .dialog-price { font-size: 28px; font-weight: 700; color: var(--primary-color); margin-bottom: 6px;
        span { font-size: 14px; font-weight: 400; color: var(--text-light); }
        &.free { color: #2E7D32; }
    }
    .dialog-desc { font-size: 13px; color: var(--text-secondary); line-height: 1.6; }
}

.dialog-form {
    :deep(.el-input) { width: 90%; }
}

.dialog-total {
    text-align: right;
    padding: 12px 0;
    font-size: 15px;
    color: var(--text-main);

    .total-price { font-size: 24px; font-weight: 700; color: var(--primary-color); }
}

.dialog-footer {
    display: flex;
    justify-content: center;
    gap: 12px;

    .cancel-btn {
        padding: 8px 28px;
        border: 1px solid #ddd;
        border-radius: 100px;
        cursor: pointer;
        font-size: 14px;
        transition: all 0.3s;
        &:hover { border-color: #bbb; }
    }

    .confirm-btn {
        padding: 8px 28px;
        background: var(--primary-color);
        color: white;
        border-radius: 100px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s;
        &:hover { background: var(--primary-light); }
    }
}
</style>
