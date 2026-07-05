<template>
    <div class="scenic-route-detail-container">
        <!--页头 -->
        <div style="margin-top: 30px;">
            <el-page-header @back="$router.go(-1)" icon="ArrowLeft"
                :content="`${scenicSpotRouteItem.positionDesc}【景点路线节点】`"></el-page-header>
        </div>
        <!-- 当前景点项基本信息 -->
        <div class="nodes-info">
            <div class="content">
                <div class="title">{{ scenicSpotRouteItem.positionDesc }}</div>

                <div class="times">
                    <el-tag type="success" style="margin-right: 10px;">路线大约总时长{{ scenicSpotRouteItem.times }}</el-tag>
                    <el-tag type="success">难度:{{ intensityText(scenicSpotRouteItem.intensity as any) }}</el-tag>
                </div>

                <div class="focus">核心看点：
                    <span style="font-weight: 600;">{{ scenicSpotRouteItem.focusDesc }}</span>
                </div>
                <div style="margin-block: 20px;">
                    <el-button @click="saveScenicSpotRouteNodesClick" type="primary" round>添加路线新节点</el-button>
                </div>
            </div>
        </div>
        <div v-if="!scenicSpotRouteNodesList.length">
            <el-empty description="该路线下暂无节点信息"></el-empty>
        </div>
        <!-- 景点路线节点项列表 -->
        <div class="nodes-container">

            <div class="nodes-item" :key="`nodes-${nodes.id}`" v-for="(nodes, index) in scenicSpotRouteNodesList">

                <div class="block">
                    <div class="top">
                        <div class="type">
                            <el-tooltip class="item" effect="dark" :content="nodes.type" placement="bottom">
                                {{ nodes.type }}
                            </el-tooltip>
                        </div>
                        <div class="times">{{ nodes.times }}</div>
                    </div>
                    <div class="focus">
                        {{ nodes.focusDesc }}
                    </div>
                    <div style="display: flex;justify-content: space-between;">
                        <!-- 修改按钮 -->
                        <el-badge :value="`节点${index + 1}`" class="item">
                            <div class="fun-btn" @click.stop="handleUpdateNotes(nodes)">修改路线</div>
                        </el-badge>

                        <!-- 删除按钮 -->
                        <div class="cannel" @click.stop="handleDelete(nodes)">删除</div>
                    </div>
                </div>

            </div>

        </div>

        <!-- 景点路线节点信息操作弹窗 -->
        <el-dialog :title="isCreateModel ? '添加新的景点路线节点' : '修改景点路线节点信息'" v-model="dialogVisible" width="600px"
            :close-on-click-modal="false">

            <el-form :model="scenicSpotRouteNodes" label-width="120px" ref="formRef">

                <el-form-item label="节点类型" prop="positionDesc">
                    <el-input style="width: 90%;" type="textarea" :autosize="{ minRows: 2, maxRows: 4 }"
                        placeholder="请输入路线节点类型描述" v-model="scenicSpotRouteNodes.type"></el-input>
                </el-form-item>

                <el-form-item label="节点大约时长" prop="times">
                    <el-input style="width: 90%;" v-model="scenicSpotRouteNodes.times" placeholder="请输入路线大约时长备注" />
                </el-form-item>

                <el-form-item label="序号" prop="intensity">
                    <el-slider style="width: 90%;" :max="20" v-model="scenicSpotRouteNodes.orderNumber" :step="1"
                        show-stops :format-tooltip="formatTooltip"></el-slider>
                </el-form-item>

                <el-form-item label="核心看点" prop="focusDesc">
                    <el-input style="width: 90%;" v-model="scenicSpotRouteNodes.focusDesc" placeholder="请输入路线核心看点" />
                </el-form-item>
            </el-form>

            <template #footer>
                <div class="footer-container">
                    <div>
                        <div class="cannel" @click="handleCancel">取消</div>
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
import { ElMessage, ElMessageBox, ElNotification } from "element-plus"
import type { ScenicSpotVO } from "@/types/scenic-spot.ts"
import type { ScenicSpotRouteNodes } from "@/types/scenic-spot-route-nodes"
import type { ScenicSpotRouteItem } from "@/types/scenic-spot-route-item"
import {
    addScenicSpotRouteNotesApi,
    delScenicSpotRouteNodesApi,
    updateScenicSpotRouteNodesApi,
    queryScenicSpotRouteNodesApi
} from "@/api/scenic-spot-route-nodes-api"
import {
    getScenicSpotRouteItemDetailApi
} from "@/api/scenic-spot-route-item-api"
const router = useRouter()

// 响应式数据
const scenicSpotRouteItemId = ref<number | null>(null)

const scenicSpotDetail = reactive<Partial<ScenicSpotVO>>({})
const isLoading = ref(false)
const isCreateModel = ref(true)
const dialogVisible = ref(false)

// 路线
const scenicSpotRouteItem = reactive<Partial<ScenicSpotRouteItem>>({})

// 路线节点
const scenicSpotRouteNodes = reactive<ScenicSpotRouteNodes>({
    id: null,
    scenicSpotRouteId: null,
    type: '',
    times: '',
    focusDesc: '',
    orderNumber: 1 // 默认序号是1
})


const scenicSpotRouteNodesList = ref<ScenicSpotRouteNodes[]>([])


const handleCancel = () => {
    resetForm()
}

const intensityText = (value: number) => {
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
        return "未知难度"
    }
}

const formatTooltip = (value: number) => {
    return `节点优先级别【${value}】`
}

const resetForm = () => {
    dialogVisible.value = false // 关闭操作弹窗
    isCreateModel.value = true // 模式恢复至新增模式
    Object.assign(scenicSpotRouteNodes, {
        id: null,
        scenicSpotRouteId: null,
        type: '',
        times: '',
        orderNumber: null,
        focusDesc: ''
    })
}


const handleDelete = async (nodes: any) => {
    try {
        const response = await ElMessageBox.confirm(
            `确定要删除景点路线节点"【${nodes.type}】"吗？`,
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
                // 删除景点路线节点数据
                await delScenicSpotRouteNodesApi(nodes.id)
                // 加载景点路线项节点列表
                queryScenicSpotRouteNodes()
                ElNotification.success({
                    title: '景点删除',
                    message: `景点路线节点【${nodes.type}】删除成功`,
                    duration: 1500
                })
            } catch (error: any) {
                ElMessage.error(error)
                console.error("景点路线节点删除异常：", error);
            }

        }
    } catch (error) {
        // 用户取消删除
        console.log('取消删除')
    }
}


const updateScenicSpotRouteItem = (route: any) => {
    dialogVisible.value = true // 打开弹窗
    isCreateModel.value = false // 设置成修改模式
    Object.assign(scenicSpotRouteItem, { ...route })
}

const handleSelectRoutesChildren = (route: any) => {
    // 跳转路线节点页

}

const deleteScenicSpotRouteItem = async (route: any) => {
    try {
        console.log(route);

        const response = await ElMessageBox.confirm(
            `确定要删除景点路线节点"【${route.positionDesc}】"吗？`,
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
                // // 删除景点路线节点数据
                // await deleteScenicSpotRouteItemApi(route.id)
                // // 加载景点路线节点项列表
                // await queryScenicSpotRouteNodes()
                // ElNotification.success({
                //     title: '景点删除',
                //     message: `景点路线节点【${route.positionDesc}】删除成功`,
                //     duration: 1500
                // })
            } catch (error: any) {
                ElMessage.error(error)
                console.error("景点路线节点删除异常：", error);
            }

        }
    } catch (error) {
        // 用户取消删除
        console.log('取消删除')
    }
}

const saveScenicSpotRouteNodesClick = () => {
    dialogVisible.value = true
}

// 获取景点ID
const getScenicSpotRouteIdWithPath = () => {

    const queryId = router.currentRoute.value.query.scenicSpotRouteItemId
    if (queryId) {
        scenicSpotRouteItemId.value = Number(queryId)
    }
}


// 查询景点路线节点
const queryScenicSpotRouteNodes = async () => {
    try {
        if (!scenicSpotRouteItemId.value) {
            console.log("路线ID为空...");
            return
        }
        const { data } = await queryScenicSpotRouteNodesApi(scenicSpotRouteItemId.value)
        // 进行排序处理
        scenicSpotRouteNodesList.value = data.sort((a: ScenicSpotRouteNodes, b: ScenicSpotRouteNodes) => b.orderNumber - a.orderNumber || ((b?.id ?? 1) - (a?.id ?? 0)))
    } catch (error: any) {
        console.error("景点路线节点查询异常：", error)
        ElMessage.error(`景点路线节点查询异常：${error}`)
    }
}


// 景点路线项节点修改
const handleUpdateNotes = (nodes: ScenicSpotRouteNodes) => {
    dialogVisible.value = true // 开启弹窗
    isCreateModel.value = false // 标识成修改模式
    Object.assign(scenicSpotRouteNodes, { ...nodes })
}

// 景点路线节点新增
const handleConfirm = async () => {
    try {
        if (!scenicSpotRouteNodes.type) {
            ElMessage.warning('景点路线节点类型不为空')
            return
        }
        if (!scenicSpotRouteNodes.times) {
            ElMessage.warning('景点大致时长不为空')
            return
        }
        if (!scenicSpotRouteNodes.focusDesc) {
            ElMessage.warning('景点核心看点不为空')
            return
        }
        if (!scenicSpotRouteNodes.orderNumber) {
            ElMessage.warning('请选择景点强度')
            return
        }
        if (isCreateModel.value) { // 新增模式
            // 设置关联的景点路线ID
            scenicSpotRouteNodes.scenicSpotRouteId = scenicSpotRouteItemId.value
            await addScenicSpotRouteNotesApi(scenicSpotRouteNodes)
        } else { // 修改模式
            await updateScenicSpotRouteNodesApi(scenicSpotRouteNodes)
        }
        // 提示操作成功
        ElNotification.success({
            title: isCreateModel.value ? '景点路线节点新增' : '景点路线节点修改',
            message: isCreateModel.value ? '新增成功' : '修改成功',
            duration: 1500
        })
        //ElMessage.success(isCreateModel.value ? '景点路线节点新增成功' : '景点路线节点修改成功')
        // 重置响应式数据
        resetForm()
        // 加载景点路线节点项列表
        await queryScenicSpotRouteNodes()
    } catch (error: any) {
        console.error(isCreateModel.value ? '景点路线节点新增成功' : '景点路线节点修改成功', error)
        ElMessage.error(`${isCreateModel.value ? '景点路线节点新增成功' : '景点路线节点修改成功'}：${error}`)
    }
}

/**
 * 通过ID查询景点路线节点项详情
 * @param id 主键ID
 */
const getScenicSpotRouteItemDetail = async (id: number | null) => {
    if (!id) {
        console.error("景点路线节点项ID为空")
        return
    }
    isLoading.value = true
    try {
        const { data } = await getScenicSpotRouteItemDetailApi(id)
        // 赋值新数据
        Object.assign(scenicSpotRouteItem, data)
        console.log(scenicSpotRouteItem);

    } catch (error: any) {
        console.error("查询景点路线节点详情异常：", error)
        // 可以添加错误提示
    } finally {
        isLoading.value = false
    }
}


onMounted(async () => {
    getScenicSpotRouteIdWithPath()
    console.log("ID:", scenicSpotRouteItemId.value);

    if (scenicSpotRouteItemId.value) {
        await getScenicSpotRouteItemDetail(scenicSpotRouteItemId.value)
        await queryScenicSpotRouteNodes() // 查询景点路线节点下的全部节点
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


.cannel,
.fun-btn {
    padding: 2px 10px;
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


.nodes-info {
    padding: 20px;
    box-sizing: border-box;
    background-color: rgb(250, 250, 250);
    margin-block: 20px;
    border-radius: 20px;
    border: 1px solid rgb(240, 240, 240);

    .title {
        font-size: 26px;
        font-weight: 600;
        margin-bottom: 10px;
    }

    .times {
        margin-bottom: 20px;
    }
}

.nodes-container {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 10px;

    .nodes-item {
        display: flex;
        justify-content: left;
        align-items: first baseline;
        min-height: 100px;
        padding: 10px;
        box-sizing: border-box;
        border-radius: 10px;
        background-color: rgb(250, 250, 250);
        border: 1px solid rgb(240, 240, 240);

        .block {
            text-align: center;

            // display: flex;
            // justify-content: center;
            // align-items: center;
            .top {
                display: flex;
                justify-content: space-between;
                align-items: center;

                .type {
                    width: 150px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                    text-align: left;
                    font-size: 20px;
                    font-weight: 600;
                }

                .times {
                    font-size: 12px;
                    color: rgb(140, 141, 141);
                }
            }

            .focus {
                min-height: 60px;
                text-align: left;
                color: rgb(140, 141, 141);
            }
        }
    }
}
</style>