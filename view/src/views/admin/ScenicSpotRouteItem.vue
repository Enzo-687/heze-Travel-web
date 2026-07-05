<template>
    <div class="scenic-route-detail-container">
        <!--页头 -->
        <div style="margin-top: 30px;">
            <el-page-header @back="$router.go(-1)" icon="ArrowLeft"
                :content="`${scenicSpotDetail.title}【景点路线】`"></el-page-header>
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
                    <div class="add" @click="saveScenicSpotRouteItemClick">添加新路线</div>
                </div>
            </div>
        </div>
        <!-- 景点路线项列表 -->
        <div>
            <RouteItems @routes="handleSelectRoutesChildren" @delete="deleteScenicSpotRouteItem"
                @update="updateScenicSpotRouteItem" :scenicSpotRouteItemList="scenicSpotRouteItemList as any" />
        </div>

        <!-- 景点路线信息操作弹窗 -->
        <el-dialog :title="isCreateModel ? '添加新的景点路线' : '修改景点路线信息'" v-model="dialogVisible" width="600px"
            :close-on-click-modal="false">

            <el-form :model="scenicSpotRouteItem" label-width="120px" ref="formRef">

                <el-form-item label="路线定位" prop="positionDesc">
                    <el-input style="width: 90%;" type="textarea" :autosize="{ minRows: 2, maxRows: 4 }"
                        placeholder="请输入路线定位描述" v-model="scenicSpotRouteItem.positionDesc"></el-input>
                </el-form-item>

                <el-form-item label="路线大约时长" prop="times">
                    <el-input style="width: 90%;" v-model="scenicSpotRouteItem.times" placeholder="请输入路线大约时长备注" />
                </el-form-item>

                <el-form-item label="路线强度" prop="intensity">
                    <el-slider style="width: 90%;" :max="5" v-model="scenicSpotRouteItem.intensity" :step="1" show-stops
                        :format-tooltip="formatTooltip"></el-slider>
                </el-form-item>

                <el-form-item label="核心看点" prop="focusDesc">
                    <el-input style="width: 90%;" v-model="scenicSpotRouteItem.focusDesc" placeholder="请输入路线核心看点" />
                </el-form-item>
            </el-form>

            <template #footer>
                <div class="footer-container">
                    <div>
                        <div class="cannel" @click="handleCancel">取消</div>
                        <div class="fun-btn" @click="handleConfirm">{{ isCreateModel ? '确定新增' : '确定修改' }}</div>
                    </div>
                </div>
                <!-- <el-button @click="handleCancel">取消</el-button>
                <el-button type="primary" @click="handleConfirm" :loading="confirmLoading">
                    {{ isCreateModel ? '新增' : '修改' }}
                </el-button> -->
            </template>
        </el-dialog>

    </div>
</template>

<script setup lang="ts">
import { ElMessage, type FormInstance, ElMessageBox, ElNotification } from "element-plus"
import RouteItems from "@/components/RouteItems.vue"
import { ref, reactive, onMounted } from "vue"
import { useRouter } from "vue-router"
import { getDetailApi } from "@/api/scenic-spot-api"
import type { ScenicSpotVO } from "@/types/scenic-spot.ts"
import type { ScenicSpotRouteItem, ScenicSpotRouteItemQueryDTO } from "@/types/scenic-spot-route-item"
import {
    addScenicSpotRouteItemApi,
    updateScenicSpotRouteItemApi,
    deleteScenicSpotRouteItemApi,
    queryScenicSpotRouteItemApi
} from "@/api/scenic-spot-route-item-api"

const router = useRouter()

// 响应式数据
const scenicSpotId = ref<number | null>(null)
const scenicSpotDetail = reactive<Partial<ScenicSpotVO>>({})
const isLoading = ref(false)
const formRef = ref<FormInstance>()
const isCreateModel = ref(true)
const dialogVisible = ref(false)

const scenicSpotRouteItem = reactive<ScenicSpotRouteItem>({
    scenicSpotId: null,
    positionDesc: '',
    times: '',
    intensity: null,
    focusDesc: ''
})


const scenicSpotRouteItemQueryDTO = reactive<ScenicSpotRouteItemQueryDTO>({
    scenicSpotId: null
})

const scenicSpotRouteItemList = ref<ScenicSpotRouteItem[]>([])

const handleCancel = () => {
    resetForm()
}

const formatTooltip = (value: number) => {
    if (value === 1) {
        return "路线简单"
    } else if (value === 2) {
        return "路线较易"
    } else if (value === 3) {
        return "路线中等"
    } else if (value === 4) {
        return "路线较难"
    } else if (value === 5) {
        return "路线困难"
    } else {
        return "请选择路线难度"
    }
}

const resetForm = () => {
    dialogVisible.value = false // 关闭操作弹窗
    isCreateModel.value = true // 模式恢复至新增模式
    Object.assign(scenicSpotRouteItem, {
        id: null,
        scenicSpotId: null,
        positionDesc: '',
        times: '',
        intensity: null,
        focusDesc: ''
    })
}

const updateScenicSpotRouteItem = (route: any) => {
    dialogVisible.value = true // 打开弹窗
    isCreateModel.value = false // 设置成修改模式
    Object.assign(scenicSpotRouteItem, { ...route })
}

const handleSelectRoutesChildren = (route: any) => {
    // 跳转路线节点页
    router.push(`/admin/scenic-spot-route-nodes-admin?scenicSpotRouteItemId=${route.id}`);
}

const deleteScenicSpotRouteItem = async (route: any) => {
    try {
        console.log(route);

        const response = await ElMessageBox.confirm(
            `确定要删除景点路线"【${route.positionDesc}】"吗？`,
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
                // 删除景点路线数据
                await deleteScenicSpotRouteItemApi(route.id)
                // 加载景点路线项列表
                await queryScenicSpotRouteItem()
                ElNotification.success({
                    title: '景点删除',
                    message: `景点路线【${route.positionDesc}】删除成功`,
                    duration: 1500
                })
            } catch (error: any) {
                ElMessage.error(error)
                console.error("景点路线删除异常：", error);
            }

        }
    } catch (error) {
        // 用户取消删除
        console.log('取消删除')
    }
}

const saveScenicSpotRouteItemClick = () => {
    dialogVisible.value = true
    scenicSpotRouteItem.intensity = 1 // 新增时，路线难度初始设置为1 - 简单
}

// 获取景点ID
const getScenicSpotIdWithPath = () => {

    const queryId = router.currentRoute.value.query.scenicSpotId
    if (queryId) {
        scenicSpotId.value = Number(queryId)
    }
}


// 查询景点路线
const queryScenicSpotRouteItem = async () => {
    try {
        scenicSpotRouteItemQueryDTO.scenicSpotId = scenicSpotId.value
        const { data } = await queryScenicSpotRouteItemApi(scenicSpotRouteItemQueryDTO)
        scenicSpotRouteItemList.value = data
    } catch (error: any) {
        console.error("景点路线查询异常：", error)
        ElMessage.error(`景点路线查询异常：${error}`)
    }
}

// 景点路线新增
const handleConfirm = async () => {
    try {
        if (!scenicSpotRouteItem.positionDesc) {
            ElMessage.warning('景点路线定位不为空')
            return
        }
        if (!scenicSpotRouteItem.times) {
            ElMessage.warning('景点大致时长不为空')
            return
        }
        if (!scenicSpotRouteItem.focusDesc) {
            ElMessage.warning('景点核心看点不为空')
            return
        }
        if (!scenicSpotRouteItem.intensity) {
            ElMessage.warning('请选择景点强度')
            return
        }
        // 设置关联的景点ID
        scenicSpotRouteItem.scenicSpotId = scenicSpotId.value
        if (isCreateModel.value) { // 新增模式
            await addScenicSpotRouteItemApi(scenicSpotRouteItem)
        } else { // 修改模式
            await updateScenicSpotRouteItemApi(scenicSpotRouteItem)
        }
        // 提示操作成功
        ElNotification.success({
            title: isCreateModel.value ? '景点路线新增' : '景点路线修改',
            message: isCreateModel.value ? '新增成功' : '修改成功',
            duration: 1500
        })
        //ElMessage.success(isCreateModel.value ? '景点路线新增成功' : '景点路线修改成功')
        // 重置响应式数据
        resetForm()
        // 加载景点路线项列表
        await queryScenicSpotRouteItem()
    } catch (error: any) {
        console.error(isCreateModel.value ? '景点路线新增成功' : '景点路线修改成功', error)
        ElMessage.error(`${isCreateModel.value ? '景点路线新增成功' : '景点路线修改成功'}：${error}`)
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
        await queryScenicSpotRouteItem()
    }
})
</script>

<style lang="scss" scoped>
.footer-container {
    display: flex;
    justify-content: center;
    align-items: center;

    div {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;

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