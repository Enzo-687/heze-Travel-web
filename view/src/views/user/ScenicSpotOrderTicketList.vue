<template>
    <div class="user-orders">
        <div class="orders-header">
            <div class="tab-bar">
                <Tab :buttons="[
                    { label: '全部', value: 'null' },
                    { label: '待付款', value: '1' },
                    { label: '已核销', value: '2' },
                    { label: '待使用', value: '3' },
                    { label: '已取消', value: '4' },
                    { label: '退款中', value: '5' },
                    { label: '已退款', value: '6' },
                    { label: '拒绝退款', value: '7' },
                ]" :initialActive="'null'" @change="handleChange" />
            </div>
            <el-date-picker @change="handleDateChange" style="max-width: 280px;" v-model="dateRanges" type="daterange"
                range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" size="default" />
        </div>

        <div v-if="!scenicSpotTicketOrdersList.length" class="empty-state">
            <div class="empty-icon">🎫</div>
            <div class="empty-text">暂无订单信息</div>
        </div>

        <div v-for="ticketOrder in scenicSpotTicketOrdersList" :key="`ticketOrder-${ticketOrder.id}`"
            class="order-card" :class="'status-' + ticketOrder.status">
            <div class="card-top-bar" :class="'bar-' + ticketOrder.status"></div>

            <div class="card-header">
                <div class="header-left">
                    <span class="status-dot" :class="'dot-' + ticketOrder.status"></span>
                    <span class="status-text" :class="'text-' + ticketOrder.status">
                        {{ getStatusText(ticketOrder.status as any) }}
                    </span>
                </div>
                <div class="header-right">
                    <span class="order-id">订单号：{{ ticketOrder.id }}</span>
                    <div class="countdown" v-if="Number(ticketOrder.status) === 1">
                        <el-countdown :value="getDeadlineTime(ticketOrder.createTime as any)" format="mm分ss秒" />
                    </div>
                </div>
            </div>

            <div class="card-body">
                <div class="price-section">
                    <div class="price-main">
                        <span class="price-symbol">¥</span>
                        <span class="price-value">{{ ticketOrder.price?.toFixed(2) || '0.00' }}</span>
                    </div>
                    <span class="price-quantity" v-if="ticketOrder.buyNumber">门票 × {{ ticketOrder.buyNumber }} 张</span>
                </div>

                <div class="info-section">
                    <div class="info-row" v-if="ticketOrder.startDate">
                        <span class="info-icon">📅</span>
                        <span class="info-label">有效期</span>
                        <span class="info-value">{{ ticketOrder.startDate }} 至 {{ ticketOrder.endDate }}</span>
                    </div>
                    <div class="info-row" v-if="ticketOrder.concatUsername">
                        <span class="info-icon">👤</span>
                        <span class="info-label">联系人</span>
                        <span class="info-value">{{ ticketOrder.concatUsername }}</span>
                    </div>
                    <div class="info-row" v-if="ticketOrder.concatPhone">
                        <span class="info-icon">📞</span>
                        <span class="info-label">联系电话</span>
                        <span class="info-value">{{ ticketOrder.concatPhone }}</span>
                    </div>
                    <div class="info-row" v-if="ticketOrder.idcard">
                        <span class="info-icon">🪪</span>
                        <span class="info-label">身份证号</span>
                        <span class="info-value">{{ ticketOrder.idcard }}</span>
                    </div>
                </div>

                <div class="timeline-section">
                    <div class="timeline-item" v-if="ticketOrder.createTime">
                        <span class="tl-label">创建</span>
                        <span class="tl-value">{{ ticketOrder.createTime }}</span>
                    </div>
                    <div class="timeline-item" v-if="ticketOrder.payTime">
                        <span class="tl-label">支付</span>
                        <span class="tl-value">{{ ticketOrder.payTime }}</span>
                    </div>
                    <div class="timeline-item" v-if="ticketOrder.useTime">
                        <span class="tl-label">核销</span>
                        <span class="tl-value">{{ ticketOrder.useTime }}</span>
                    </div>
                    <div class="timeline-item" v-if="ticketOrder.cancelTime">
                        <span class="tl-label">取消</span>
                        <span class="tl-value">{{ ticketOrder.cancelTime }}</span>
                    </div>
                </div>
            </div>

            <div class="card-actions">
                <el-button v-if="ticketOrder.status === 1" type="info" round size="small"
                    @click="cancelOrders(ticketOrder)">取消订单</el-button>
                <el-button v-if="ticketOrder.status === 1" type="success" round size="small"
                    @click="payOrders(ticketOrder)">立即支付</el-button>
                <el-button v-if="refundShowCondition(ticketOrder)" type="warning" round size="small"
                    @click="refundReply(ticketOrder)">申请退款</el-button>
                <el-button v-if="ticketOrder.status === 1 || ticketOrder.status === 4" type="danger" round size="small"
                    @click="removeOrders(ticketOrder)">删除订单</el-button>
            </div>

            <div v-if="ticketOrder.orderRefundInfoList.length" class="refund-section">
                <div class="refund-title">退款记录</div>
                <el-steps direction="vertical" :active="ticketOrder.orderRefundInfoList.length">
                    <el-step v-for="(refundReply, index) in ticketOrder.orderRefundInfoList"
                        :key="`refund-reply-${index}`"
                        :title="refundReply.status === 1 ? '退款中' : refundReply.status === 2 ? '已退款' : '拒绝退款'"
                        :description="getStepDescription(refundReply)" :icon="getStatusIcon(refundReply.status as any)"
                        :status="getStepStatus(refundReply.status as any)">
                        <template #description>
                            <div class="step-description">
                                <div class="create-time">申请时间：{{ refundReply.createTime }}</div>
                                <div v-if="refundReply.status === 3" class="reject-details">
                                    <div class="reject-reason">拒绝缘由：{{ refundReply.rejectReason || '未提供拒绝原因' }}</div>
                                    <div class="reject-time">审核时间：{{ refundReply.rejectRefundTime || '未记录' }}</div>
                                </div>
                                <div v-if="refundReply.status === 2" class="success-details">
                                    <div class="refund-time">
                                        <el-icon><Clock /></el-icon>
                                        <span>到账时间：{{ refundReply.refundTime || refundReply.createTime }}</span>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </el-step>
                </el-steps>
            </div>

            <div class="detail-section" v-if="ticketOrder.detail">
                <details>
                    <summary class="detail-summary">
                        <span>门票详情</span>
                        <i class="arrow">▼</i>
                    </summary>
                    <div class="detail-content">
                        <pre>{{ ticketOrder.detail }}</pre>
                    </div>
                </details>
            </div>
        </div>

        <div v-if="scenicSpotTicketOrdersList.length" class="pagination">
            <el-pagination v-model:current-page="scenicSpotTicketOrderQueryDTO.current"
                v-model:page-size="scenicSpotTicketOrderQueryDTO.size" :page-sizes="[5, 10]" :total="totalPageCount"
                layout="total, sizes, prev, pager, next, jumper" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" />
        </div>
    </div>
</template>

<script setup lang="ts">
import { ElMessageBox, ElMessage } from "element-plus"
import { ref, reactive, onMounted } from "vue"
import { handleDateRange } from "@/utils/date"
import {
    Connection,
    CircleCheckFilled,
    CircleCloseFilled,
    Warning,
    Clock,
    Money
} from '@element-plus/icons-vue'
import Tab from "@/components/Tab.vue"
import type {
    ScenicSpotTicketOrder,
    ScenicSpotTicketOrderVO,
    ScenicSpotTicketOrderQueryDTO,
    OrderRefundInfo
} from "@/types/scenic-spot-ticket-order"
import {
    updateOrderStatusApi,
    queryUserScenicSpotTicketOrdersApi
} from "@/api/scenic-spot-ticket-orders-api"

const scenicSpotTicketOrderQueryDTO = reactive<ScenicSpotTicketOrderQueryDTO>({
    size: 5,
    current: 1
})
const scenicSpotTicketOrdersList = ref<ScenicSpotTicketOrderVO[]>([])
const totalPageCount = ref<number | undefined>(0)
const dateRanges = ref<Date[]>([])

const getStatusText = (status: number) => {
    if (status === 1) return "待付款"
    if (status === 2) return "已核销"
    if (status === 3) return "待使用"
    if (status === 4) return "已取消"
    return "未知状态"
}

const getDeadlineTime = (createTime: string): number => {
    const createTimestamp = new Date(createTime).getTime()
    return createTimestamp + 15 * 60 * 1000
}

const handleChange = async (obj: { value: string }) => {
    scenicSpotTicketOrderQueryDTO.status = obj.value === 'null' ? null : Number(obj.value)
    scenicSpotTicketOrderQueryDTO.current = 1
    await fetchScenicSpotTicketOrder()
}

const handleSizeChange = async (size: number) => {
    scenicSpotTicketOrderQueryDTO.size = size
    scenicSpotTicketOrderQueryDTO.current = 1
    await fetchScenicSpotTicketOrder()
}

const handleCurrentChange = async (current: number) => {
    scenicSpotTicketOrderQueryDTO.current = current
    await fetchScenicSpotTicketOrder()
}

const payOrders = async (ticketOrder: ScenicSpotTicketOrder) => {
    try {
        const response = await ElMessageBox.confirm(
            `确定要支付"【${ticketOrder.price}元】"完成该订单的支付？`, '确认',
            { confirmButtonText: '我确定支付', cancelButtonText: '取消', type: 'warning', center: true }
        )
        if (response === 'confirm') {
            try {
                await updateOrderStatusApi(ticketOrder.id as any, "pay")
                ElMessage.success('订单支付成功')
            } catch (error: any) {
                ElMessage.warning(`下单异常：${error.message}`)
            } finally {
                await fetchScenicSpotTicketOrder()
            }
        }
    } catch (error) { }
}

const removeOrders = async (ticketOrder: ScenicSpotTicketOrder) => {
    try {
        const response = await ElMessageBox.confirm(
            `确定要删除该订单？`, '确认',
            { confirmButtonText: '我确定删除', cancelButtonText: '取消', type: 'warning', center: true }
        )
        if (response === 'confirm') {
            try {
                await updateOrderStatusApi(ticketOrder.id as any, "remove")
                ElMessage.success('订单删除成功')
            } catch (error: any) {
                ElMessage.warning(`删除异常：${error.message}`)
            } finally {
                await fetchScenicSpotTicketOrder()
            }
        }
    } catch (error) { }
}

const refundReply = async (ticketOrder: ScenicSpotTicketOrder) => {
    try {
        const response = await ElMessageBox.confirm(
            `确定要申请退款？`, '确认',
            { confirmButtonText: '我确定提交退款申请', cancelButtonText: '取消', type: 'warning', center: true }
        )
        if (response === 'confirm') {
            try {
                await updateOrderStatusApi(ticketOrder.id as any, "refund")
                ElMessage.success('订单申请退款成功')
            } catch (error: any) {
                ElMessage.warning(`申请退款异常：${error.message}`)
            } finally {
                await fetchScenicSpotTicketOrder()
            }
        }
    } catch (error) { }
}

const cancelOrders = async (ticketOrder: ScenicSpotTicketOrder) => {
    try {
        const response = await ElMessageBox.confirm(
            `确定取消该订单吗？`, '确认',
            { confirmButtonText: '我确定取消', cancelButtonText: '取消', type: 'warning', center: true }
        )
        if (response === 'confirm') {
            try {
                await updateOrderStatusApi(ticketOrder.id as any, "cancel")
                ElMessage.success('订单取消成功')
            } catch (error: any) {
                ElMessage.warning(`订单取消异常：${error.message}`)
            } finally {
                await fetchScenicSpotTicketOrder()
            }
        }
    } catch (error) { }
}

const refundShowCondition = (ticketOrder: ScenicSpotTicketOrder) => {
    const refunded = ticketOrder.orderRefundInfoList.some((order: OrderRefundInfo) => order.status === 2)
    if (refunded) return
    const statusFlag = ticketOrder.status === 3
    const result = ticketOrder.orderRefundInfoList.some((order: OrderRefundInfo) => order.status === 1)
    return statusFlag && !result
}

const handleDateChange = async () => {
    const dates = handleDateRange(dateRanges.value)
    if (dates) {
        scenicSpotTicketOrderQueryDTO.startTime = dates.start
        scenicSpotTicketOrderQueryDTO.endTime = dates.end
    } else {
        scenicSpotTicketOrderQueryDTO.startTime = null
        scenicSpotTicketOrderQueryDTO.endTime = null
    }
    await fetchScenicSpotTicketOrder()
}

const fetchScenicSpotTicketOrder = async () => {
    try {
        const { data, total } = await queryUserScenicSpotTicketOrdersApi(scenicSpotTicketOrderQueryDTO)
        scenicSpotTicketOrdersList.value = data
        totalPageCount.value = total
    } catch (error: any) {
        console.error("查询用户对于景点的收藏状态异常:", error)
    }
}

const getStatusIcon = (status: number) => {
    switch (status) {
        case 1: return Connection
        case 2: return CircleCheckFilled
        case 3: return CircleCloseFilled
        default: return Connection
    }
}

const getStepStatus = (status: number) => {
    switch (status) {
        case 1: return 'process'
        case 2: return 'finish'
        case 3: return 'error'
        default: return 'wait'
    }
}

const getStepDescription = (refundReply: any) => {
    return `申请时间：${refundReply.createTime}`
}

onMounted(async () => {
    await fetchScenicSpotTicketOrder()
})
</script>

<style lang="scss" scoped>
.user-orders {
    max-width: 900px;
    margin: 0 auto;
    padding: 28px 24px;
    background: #EDEEF2;
    border-radius: 20px;
}

.orders-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 28px;
    flex-wrap: wrap;
}

.empty-state {
    text-align: center;
    padding: 80px 20px;

    .empty-icon { font-size: 48px; margin-bottom: 16px; }
    .empty-text { font-size: 16px; color: #555; }
}

.order-card {
    background: #FFFFFF;
    border: 1px solid #E2E4E8;
    border-radius: 16px;
    margin-bottom: 20px;
    overflow: hidden;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
    transition: all 0.25s ease;

    &:hover {
        box-shadow: 0 6px 24px rgba(0, 0, 0, 0.1);
        border-color: #D0D3D8;
    }
}

.card-top-bar {
    height: 4px;
    width: 100%;

    &.bar-1 { background: linear-gradient(90deg, #E6A23C, #F5C96A); }
    &.bar-2 { background: linear-gradient(90deg, #67C23A, #95D475); }
    &.bar-3 { background: linear-gradient(90deg, #A61B2E, #D4455A); }
    &.bar-4 { background: linear-gradient(90deg, #909399, #B1B3B8); }
}

.card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px 24px 0;
}

.header-left {
    display: flex;
    align-items: center;
    gap: 8px;
}

.status-dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    flex-shrink: 0;

    &.dot-1 { background: #E6A23C; box-shadow: 0 0 0 3px rgba(230, 162, 60, 0.2); }
    &.dot-2 { background: #67C23A; box-shadow: 0 0 0 3px rgba(103, 194, 58, 0.2); }
    &.dot-3 { background: #A61B2E; box-shadow: 0 0 0 3px rgba(166, 27, 46, 0.2); }
    &.dot-4 { background: #909399; box-shadow: 0 0 0 3px rgba(144, 147, 153, 0.2); }
}

.status-text {
    font-size: 15px;
    font-weight: 700;
    letter-spacing: 1px;

    &.text-1 { color: #C88520; }
    &.text-2 { color: #4DAF2C; }
    &.text-3 { color: #A61B2E; }
    &.text-4 { color: #6B6E74; }
}

.header-right {
    display: flex;
    align-items: center;
    gap: 16px;
}

.order-id {
    font-size: 13px;
    color: #555;
    font-weight: 500;
}

.countdown {
    font-size: 14px;
    color: #E6A23C;
    font-weight: 700;
}

.card-body {
    padding: 20px 24px;
}

.price-section {
    display: flex;
    align-items: baseline;
    gap: 14px;
    margin-bottom: 20px;
    padding-bottom: 20px;
    border-bottom: 1px solid #ECEEF0;
}

.price-main {
    display: flex;
    align-items: baseline;

    .price-symbol {
        font-size: 20px;
        font-weight: 700;
        color: #1A1A1A;
        margin-right: 2px;
    }

    .price-value {
        font-size: 36px;
        font-weight: 800;
        color: #1A1A1A;
        font-family: var(--font-serif);
        letter-spacing: 0.5px;
        line-height: 1;
    }
}

.price-quantity {
    font-size: 15px;
    color: #444;
    font-weight: 500;
    background: #F0F1F3;
    padding: 4px 12px;
    border-radius: 100px;
}

.info-section {
    display: flex;
    flex-direction: column;
    gap: 14px;
    margin-bottom: 20px;
    padding: 18px 20px;
    background: #F5F6F8;
    border-radius: 12px;
    border: 1px solid #EAEBED;
}

.info-row {
    display: flex;
    align-items: center;
    gap: 10px;

    .info-icon {
        font-size: 16px;
        flex-shrink: 0;
        width: 22px;
        text-align: center;
    }

    .info-label {
        font-size: 14px;
        color: #555;
        font-weight: 600;
        min-width: 64px;
        flex-shrink: 0;
    }

    .info-value {
        font-size: 15px;
        color: #1A1A1A;
        font-weight: 500;
    }
}

.timeline-section {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;

    .timeline-item {
        display: flex;
        align-items: center;
        gap: 6px;

        .tl-label {
            font-size: 13px;
            color: #777;
            font-weight: 600;
            background: #ECEEF0;
            padding: 2px 8px;
            border-radius: 4px;
        }

        .tl-value {
            font-size: 13px;
            color: #333;
            font-weight: 500;
        }
    }
}

.card-actions {
    display: flex;
    gap: 10px;
    padding: 0 24px 20px;
}

.refund-section {
    padding: 0 24px 20px;
    border-top: 1px solid #ECEEF0;
    margin: 0 24px;

    .refund-title {
        font-size: 15px;
        font-weight: 700;
        color: #1A1A1A;
        margin: 16px 0 12px;
        letter-spacing: 1px;
    }
}

.step-description {
    padding: 8px 0;

    .create-time {
        color: #333;
        font-size: 14px;
        font-weight: 500;
        margin-bottom: 8px;
    }

    .reject-details {
        background: #FEF0F0;
        border: 1px solid #FDE2E2;
        border-radius: 8px;
        padding: 12px 14px;
        margin-top: 8px;

        .reject-reason {
            color: #D04040;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .reject-time {
            color: #666;
            font-size: 13px;
        }
    }

    .success-details {
        background: #F0F9EB;
        border: 1px solid #E1F3D8;
        border-radius: 8px;
        padding: 12px 14px;
        margin-top: 8px;

        .refund-time {
            color: #4DAF2C;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }
    }
}

:deep(.el-step__head) {
    &.is-process .el-step__icon { border-color: #409EFF; color: #409EFF; }
    &.is-finish .el-step__icon { border-color: #67C23A; color: #67C23A; }
    &.is-error .el-step__icon { border-color: #F56C6C; color: #F56C6C; }
}

:deep(.el-step__line) { background-color: #D0D3D8; }
:deep(.el-step__description) { font-size: 14px; }

.detail-section {
    border-top: 1px solid #ECEEF0;
    margin: 0 24px;
}

.detail-summary {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 0;
    cursor: pointer;
    list-style: none;
    font-size: 15px;
    color: #333;
    font-weight: 600;
    transition: color 0.3s;

    &:hover { color: #1A1A1A; }
    &::-webkit-details-marker { display: none; }
}

.arrow {
    transition: transform 0.3s;
    font-size: 10px;
    color: #888;
}

details[open] .arrow { transform: rotate(180deg); }

.detail-content {
    padding: 0 0 20px;
    border-top: 1px solid #ECEEF0;
}

.detail-content pre {
    margin: 14px 0 0;
    white-space: pre-wrap;
    font-size: 14px;
    line-height: 1.8;
    color: #333;
    font-family: inherit;
    background: #F5F6F8;
    padding: 16px;
    border-radius: 10px;
    border: 1px solid #EAEBED;
}

.pagination {
    display: flex;
    justify-content: center;
    padding: 36px 0;
}

@media (max-width: 768px) {
    .user-orders { max-width: 100%; }

    .info-section { padding: 14px 16px; }

    .info-row {
        flex-wrap: wrap;

        .info-value { width: 100%; margin-left: 32px; }
    }

    .orders-header { flex-direction: column; align-items: flex-start; }

    .card-header { flex-direction: column; align-items: flex-start; gap: 8px; }

    .header-right { flex-direction: column; align-items: flex-start; gap: 4px; }

    .timeline-section { flex-direction: column; gap: 10px; }
}
</style>
