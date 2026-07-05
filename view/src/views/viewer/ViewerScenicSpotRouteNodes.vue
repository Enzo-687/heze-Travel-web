<template>
    <div class="scenic-route-detail-container">
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
                            
                        </el-badge>

                    </div>
                </div>

            </div>

        </div>

    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue"
import { useRouter } from "vue-router"
import { ElMessage } from "element-plus"
import type { ScenicSpotRouteNodes } from "@/types/scenic-spot-route-nodes"
import type { ScenicSpotRouteItem } from "@/types/scenic-spot-route-item"
import {
    queryScenicSpotRouteNodesByViewerApi
} from "@/api/viewer-api"
import {
    getScenicSpotRouteItemDetailByViewerApi
} from "@/api/viewer-api"
const router = useRouter()

// 响应式数据
const scenicSpotRouteItemId = ref<number | null>(null)
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
        const { data } = await queryScenicSpotRouteNodesByViewerApi(scenicSpotRouteItemId.value)
        // 进行排序处理
        scenicSpotRouteNodesList.value = data.sort((a: ScenicSpotRouteNodes, b: ScenicSpotRouteNodes) => b.orderNumber - a.orderNumber || ((b?.id ?? 1) - (a?.id ?? 0)))
    } catch (error: any) {
        console.error("景点路线节点查询异常：", error)
        ElMessage.error(`景点路线节点查询异常：${error}`)
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
        const { data } = await getScenicSpotRouteItemDetailByViewerApi(id)
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
    .scenic-route-detail-container{
        padding: 20px 50px;
        box-sizing: border-box;
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