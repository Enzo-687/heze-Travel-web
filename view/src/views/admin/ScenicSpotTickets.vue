<template>
    <div class="scenic-route-detail-container">
        <!--页头 -->
        <div style="margin-top: 30px;">
            <el-page-header @back="$router.go(-1)" icon="ArrowLeft"
                :content="`${scenicSpotDetail.title}【景点门票】`"></el-page-header>
        </div>
        <!-- 当前景点项基本信息 -->
        <div class="base-scenic-info">
            <div class="content">
                <img :src="scenicSpotDetail.cover" alt="" srcset="">
            </div>
            <div class="content">
                <div class="title">{{ scenicSpotDetail.title }}</div>
                <div class="summary">{{ scenicSpotDetail.summary }}</div>
                <div>
                    <div class="add" @click="saveScenicSpotTicketClick">添加门票</div>
                </div>
            </div>
        </div>
        <!-- 景点门票项列表 -->
        <div>
            <div v-if="!scenicSpotTicketList.length">
                <el-empty description="无景点门票数据"></el-empty>
            </div>
            <div class="ticket-container">
                <div class="ticket-item" :key="`ticket-${ticket.id}`" v-for="ticket in scenicSpotTicketList">
                    <div class="icon">
                        <div style="display: flex;justify-content: center;">
                            <el-tag type="primary">门票状态：{{ ticket.status === 1 ? '暂停预约' : '正常' }}</el-tag>
                        </div>
                        <div style="display: flex;justify-content: center;">
                            <el-icon style="font-size: 140px;color: rgb(21, 14, 8);">
                                <ticket />
                            </el-icon>
                        </div>

                        <div style="display: flex;justify-content: center;gap: 10px;align-items: center;">
                            <div class="cancel" @click="deleteScenicSpotTicket(ticket)">删除</div>
                            <div class="fun-btn" @click="handleEdit(ticket)">修改</div>
                        </div>
                    </div>
                    <div class="content">
                        <div class="detail">
                            {{ ticket.detail }}
                        </div>
                        <div style="margin-top: 10px;">
                            <el-switch @change="handleChangeStatus(ticket)" v-model="ticket.switchStatus"
                                active-text="正常" inactive-text="暂停预约"></el-switch>
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

        <!-- 景点门票信息操作弹窗 -->
        <el-dialog :title="isCreateModel ? '添加新的景点门票' : '修改景点门票信息'" v-model="dialogVisible" width="600px"
            :close-on-click-modal="false">

            <el-form :model="scenicSpotTicket" label-width="120px" ref="formRef">

                <el-form-item label="总门票数量" prop="totalNumber">
                    <el-input style="width: 90%;" type="textarea" :autosize="{ minRows: 2, maxRows: 4 }"
                        placeholder="总门票数量" v-model="scenicSpotTicket.totalNumber"></el-input>
                </el-form-item>

                <el-form-item label="门票价格" prop="price">
                    <el-input style="width: 90%;" type="textarea" :autosize="{ minRows: 2, maxRows: 4 }"
                        placeholder="门票价格" v-model="scenicSpotTicket.price"></el-input>
                </el-form-item>


                <el-form-item label="备注" prop="detail">
                    <el-input style="width: 90%;" type="textarea" :autosize="{ minRows: 4, maxRows: 6 }"
                        placeholder="门票备注（如使用规则、优惠说明等，1000字以内）" v-model="scenicSpotTicket.detail"></el-input>
                </el-form-item>

                <el-form-item label="有效期开始" prop="startDate">
                    <el-date-picker value-format="YYYY-MM-DD" style="width: 90%;" v-model="scenicSpotTicket.startDate"
                        type="date" placeholder="开始日期">
                    </el-date-picker>
                </el-form-item>

                <el-form-item label="有效期结束" prop="endDate">
                    <el-date-picker value-format="YYYY-MM-DD" style="width: 90%;" v-model="scenicSpotTicket.endDate"
                        type="date" placeholder="结束日期">
                    </el-date-picker>
                </el-form-item>

            </el-form>

            <template #footer>
                <div class="footer-container">
                    <div>
                        <div class="cancel" @click="handleCancel">取消</div>
                        <div class="fun-btn" @click="handleConfirm">{{ isCreateModel ? '确定新增' : '确定修改' }}</div>
                    </div>
                </div>
            </template>
        </el-dialog>

    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue"
import { useRouter } from "vue-router"
import { ElMessage, type FormInstance, ElMessageBox, ElNotification } from "element-plus"
import { getDetailApi } from "@/api/scenic-spot-api"
import type { ScenicSpotVO } from "@/types/scenic-spot.ts"
import type { ScenicSpotTicket, ScenicSpotTicketQueryDTO } from "@/types/scenic-spot-ticket"
import {
    addScenicSpotTicketApi,
    updateScenicSpotTicketApi,
    delScenicSpotTicketApi,
    queryScenicSpotTicketApi
} from "@/api/scenic-spot-ticket-api"

const router = useRouter()

// 响应式数据
const scenicSpotId = ref<number | null>(null)
const scenicSpotDetail = reactive<Partial<ScenicSpotVO>>({})
const isLoading = ref(false)
const formRef = ref<FormInstance>()
const isCreateModel = ref(true)
const dialogVisible = ref(false)

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

// 审核状态切换
const handleChangeStatus = async (ticket: ScenicSpotTicket) => {
    try {
        const response = await ElMessageBox.confirm(
            ticket.switchStatus ? `确定恢复该门票正常状态吗？` : `确定暂停该票据的预约吗`,
            '操作确定',
            {
                confirmButtonText: ticket.switchStatus ? '确定恢复正常' : '确定暂停预约',
                cancelButtonText: '取消',
                type: 'warning',
                center: true
            }
        )

        if (response === 'confirm') {
            try {
                await updateScenicSpotTicketApi(
                    {
                        id: ticket.id,
                        status: ticket.switchStatus ? 2 : 1
                    } as any
                )
                ElNotification.success({
                    title: '操作结果',
                    message: ticket.switchStatus ? '景点门票可正常预约' : '景点门票已暂停预约',
                    duration: 1500
                })

            } catch (error: any) {

                ticket.switchStatus = !ticket.switchStatus
                ElMessage.error(error)
                console.error("景点攻略审核操作异常：", error);
            } finally {
                if (ticket.status === 1) {
                    ticket.status = 2
                } else if (ticket.status === 2) {
                    ticket.status = 1
                }
            }

        }
    } catch (error) {
        // 用户取消删除
        console.log('取消删除')
    }
}

const resetForm = () => {
    dialogVisible.value = false // 关闭操作弹窗
    isCreateModel.value = true // 模式恢复至新增模式
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
}

const deleteScenicSpotTicket = async (ticket: ScenicSpotTicket) => {
    try {
        const response = await ElMessageBox.confirm(
            `确定要删除该景点门票吗？`,
            '删除确认',
            {
                confirmButtonText: '确定删除',
                cancelButtonText: '取消',
                type: 'warning',
                center: true
            }
        )
        if (response === 'confirm') {
            try {
                if (!ticket.id) {
                    return
                }
                // 删除景点门票数据
                await delScenicSpotTicketApi(ticket.id)
                // 加载景点门票项列表
                await queryScenicSpotTickets()
                ElNotification.success({
                    title: '景点删除',
                    message: `景点门票删除成功`,
                    duration: 1500
                })
            } catch (error: any) {
                ElMessage.error(error)
                console.error("景点门票删除异常：", error);
            }

        }
    } catch (error) {
        // 用户取消删除
        console.log('取消删除')
    }
}

const saveScenicSpotTicketClick = () => {
    dialogVisible.value = true
}

// 获取景点ID
const getScenicSpotIdWithPath = () => {

    const queryId = router.currentRoute.value.query.scenicSpotId
    if (queryId) {
        scenicSpotId.value = Number(queryId)
    }
}


const handleEdit = (ticket: ScenicSpotTicket) => {
    dialogVisible.value = true
    isCreateModel.value = false
    Object.assign(scenicSpotTicket, { ...ticket })
}


// 查询景点门票
const queryScenicSpotTickets = async () => {
    try {
        scenicSpotRouteItemQueryDTO.scenicSpotId = scenicSpotId.value
        const { data } = await queryScenicSpotTicketApi(scenicSpotRouteItemQueryDTO)
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

// 景点门票新增
const handleConfirm = async () => {
    try {
        if (!scenicSpotTicket.totalNumber) {
            ElMessage.warning('总门票数不为空')
            return
        }
        if (!scenicSpotTicket.price) {
            ElMessage.warning('票价请补充')
            return
        }
        if (!scenicSpotTicket.detail) {
            ElMessage.warning('景点门票备注请补充')
            return
        }
        if (!scenicSpotTicket.endDate) {
            ElMessage.warning('请选择有效期结束日期')
            return
        }
        if (!scenicSpotTicket.startDate) {
            ElMessage.warning('请选择有效期开始日期')
            return
        }
        // 设置关联的景点ID
        scenicSpotTicket.scenicId = scenicSpotId.value
        if (isCreateModel.value) { // 新增模式
            await addScenicSpotTicketApi(scenicSpotTicket)
        } else { // 修改模式
            await updateScenicSpotTicketApi(scenicSpotTicket)
        }
        // 提示操作成功
        ElNotification.success({
            title: isCreateModel.value ? '景点门票新增' : '景点门票修改',
            message: isCreateModel.value ? '新增成功' : '修改成功',
            duration: 1500
        })
        //ElMessage.success(isCreateModel.value ? '景点门票新增成功' : '景点门票修改成功')
        // 重置响应式数据
        resetForm()
        // 加载景点门票项列表
        await queryScenicSpotTickets()
    } catch (error: any) {
        console.error(isCreateModel.value ? '景点门票新增异常' : '景点门票修改异常', error)
        ElMessage.warning(`${isCreateModel.value ? '景点门票新增异常' : '景点门票修改异常'}：${error.message}`)
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


onMounted(async () => {
    getScenicSpotIdWithPath()
    if (scenicSpotId.value) {
        await getScenicSpotDetail(scenicSpotId.value)
        await queryScenicSpotTickets()
    }
})
</script>

<style lang="scss" scoped>
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

    &:hover {
        background-color: rgb(31, 31, 31);
    }
}

.ticket-container {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;


    .ticket-item {
        display: flex;
        align-items: center;
        gap: 20px;
        box-shadow: 0 4px 8px rgb(240, 240, 240);
        border-radius: 10px;
        padding: 10px;
        box-sizing: border-box;
        cursor: pointer;
        transition: all 0.5s ease;

        &:hover {
            .content {
                .detail {
                    color: rgb(80, 82, 109);
                }
            }
        }

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