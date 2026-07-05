<template>
    <div class="scenic-route-detail-container">
        <!-- 景点路线项列表 -->
        <div>
            <UserRouteItems @routes="handleSelectRoutesChildren"
                :scenicSpotRouteItemList="scenicSpotRouteItemList" />
        </div>
    </div>
</template>

<script setup lang="ts">
import { ElMessage } from "element-plus"
import UserRouteItems from "@/components/UserRouteItems.vue"
import { ref, reactive, onMounted } from "vue"
import { getDetailApi } from "@/api/scenic-spot-api"
import type { ScenicSpotVO } from "@/types/scenic-spot.ts"
import type { ScenicSpotRouteItem, ScenicSpotRouteItemQueryDTO } from "@/types/scenic-spot-route-item"
import {
    queryScenicSpotRouteItemApi
} from "@/api/scenic-spot-route-item-api"


// 响应式数据
const scenicSpotDetail = reactive<Partial<ScenicSpotVO>>({})
const isLoading = ref(false)

// 定义 props
const props = defineProps({
    scenicSpotId: {
        type: Number,
        default: '',
        required: true
    },
})

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

const handleSelectRoutesChildren = (route: any) => {
    // 跳转路线节点页
    window.open(`/scenic-spot-route-nodes-user?scenicSpotRouteItemId=${route.id}`);
}


// 查询景点路线
const queryScenicSpotRouteItem = async () => {
    try {
        scenicSpotRouteItemQueryDTO.scenicSpotId = props.scenicSpotId
        const { data } = await queryScenicSpotRouteItemApi(scenicSpotRouteItemQueryDTO)
        scenicSpotRouteItemList.value = data
    } catch (error: any) {
        console.error("景点路线查询异常：", error)
        ElMessage.error(`景点路线查询异常：${error}`)
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
    await getScenicSpotDetail(props.scenicSpotId)
    if (props.scenicSpotId) {
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