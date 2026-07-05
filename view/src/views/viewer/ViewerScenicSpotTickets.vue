<template>
    <div class="scenic-route-detail-container">
        <!-- 景点门票项列表 -->
        <div>
            <div v-if="!scenicSpotTicketList.length">
                <el-empty description="无景点门票数据"></el-empty>
            </div>
            <div class="ticket-container">
                <div class="ticket-item" :key="`ticket-${ticket.id}`" v-for="ticket in scenicSpotTicketList">
                    <div class="icon">

                        <div style="display: flex;justify-content: center;">
                            <el-icon style="font-size: 50px;color: rgb(61, 190, 113);">
                                <ticket />
                            </el-icon>
                        </div>

                        <div style="margin-bottom: 10px;display: flex;align-items: center;justify-content: center;">
                            <el-tag type="warning">门票状态：{{ ticket.status === 1 ? '暂停预约' : '正常' }}</el-tag>
                        </div>

                    </div>
                    <div class="content">
                        <div class="detail" v-html="ticket.detail">
                        </div>
                        <div style="margin-top: 10px;">
                            总数量：
                            <span style="font-size: 20px;font-weight: 600;">{{ ticket.totalNumber }}</span>
                            张，单价：
                            <span style="font-size: 20px;font-weight: 600;">{{ ticket.price }}</span>
                            元/张
                        </div>
                        <div style="margin-block: 10px;">
                            <el-tag type="warning">有效期：{{ ticket.startDate }}至{{ ticket.endDate }}</el-tag>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue"
import { ElMessage } from "element-plus"
import type { ScenicSpotTicket, ScenicSpotTicketQueryDTO } from "@/types/scenic-spot-ticket"
import {
    queryScenicSpotTicketByViewerApi
} from "@/api/viewer-api"

import type { ScenicSpotTicketOrder } from "@/types/scenic-spot-ticket-order"



// 响应式数据
const isCreateModel = ref(true)
const dialogVisible = ref(false)

const props = defineProps({
    scenicSpotId: {
        type: Number,
        default: '',
        required: true
    },
})

// 定义景点门票订单数据
const scenicSpotTicketOrder = reactive<Partial<ScenicSpotTicketOrder>>({
    buyNumber: 1
})

// 定义景点门票数据
const scenicSpotTicket = reactive<ScenicSpotTicket>({
    id: null,
    scenicId: null,
    totalNumber: null,
    price: null,
    detail: '',
    startDate: null,
    endDate: null,
    status: null
})

// 定义景点门票查询参数数据
const scenicSpotRouteItemQueryDTO = reactive<ScenicSpotTicketQueryDTO>({})

const scenicSpotTicketList = ref<ScenicSpotTicket[]>([])

const handleCancel = () => {
    resetForm()
}

const resetForm = () => {
    dialogVisible.value = false // 关闭操作弹窗
    Object.assign(scenicSpotTicket, {
        id: null,
        scenicId: null,
        totalNumber: null,
        price: null,
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


// 查询景点门票
const queryScenicSpotTickets = async () => {
    try {
        scenicSpotRouteItemQueryDTO.scenicSpotId = props.scenicSpotId
        const { data } = await queryScenicSpotTicketByViewerApi(scenicSpotRouteItemQueryDTO)
        scenicSpotTicketList.value = data.map((ticket: ScenicSpotTicket) => {
            return {
                switchStatus: ticket.status === 2,
                ...ticket,
            }
        })
        console.log(JSON.stringify(scenicSpotTicketList.value));


    } catch (error: any) {
        console.error("景点门票查询异常：", error)
        ElMessage.error(`景点门票查询异常：${error}`)
    }
}


onMounted(async () => {
    if (props.scenicSpotId) {
        await queryScenicSpotTickets()
    }
})
</script>

<style lang="scss" scoped>
.scenic-route-detail-container {
    max-width: 800px;
}

.cancel,
.fun-btn {
    padding: 2px 10px;
    border-radius: 20px;
    cursor: pointer;
    transition: all 0.5s ease;
}

.cancel {
    border: 1px solid rgb(51, 51, 51);

    &:hover {
        border: 1px solid rgb(31, 31, 31);
    }
}

.fun-btn {
    background-color: rgb(51, 51, 51);
    color: rgb(255, 255, 255);
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 8px;

    &:hover {
        background-color: rgb(31, 31, 31);
    }
}

.ticket-container {
    // display: grid;
    // grid-template-columns: repeat(2, 1fr);
    // gap: 20px;


    .ticket-item {
        display: flex;
        align-items: center;
        // gap: 20px;
        // box-shadow: 0 4px 8px rgb(240, 240, 240);
        background-color: rgb(250, 251, 252);
        border: 1px solid rgb(240, 240, 240);
        margin-bottom: 10px;
        border-radius: 10px;
        padding: 10px;
        box-sizing: border-box;
        cursor: pointer;
        transition: all 0.5s ease;

        .icon {
            min-width: 150px;
        }

        .content {
            .detail {
                font-size: 14px;
                color: rgb(134, 134, 134);
            }
        }
    }
}

.footer-container {
    display: flex;
    justify-content: center;
    align-items: center;

    div {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;

        .cancel,
        .fun-btn {
            padding: 6px 20px;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.5s ease;
        }

        .cancel {
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
    }
}

.base-scenic-info {
    display: flex;
    padding: 30px 20px;
    box-sizing: border-box;
    align-items: center;
    gap: 20px;

    .content {

        .add {
            background-color: rgb(51, 51, 51);
            color: rgb(255, 255, 255);
            display: inline-block;
            padding: 6px 20px;
            border-radius: 20px;
            cursor: pointer;

            &:hover {
                background-color: rgb(31, 31, 31);
            }
        }

        img {
            width: 250px;
            aspect-ratio: 3/2;
            border-radius: 20px;
        }

        .title {
            font-size: 26px;
            margin-bottom: 10px;
        }

        .summary {
            color: rgb(120, 120, 120);
            margin-bottom: 10px;
        }
    }
}
</style>