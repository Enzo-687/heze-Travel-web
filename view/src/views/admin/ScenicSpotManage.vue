<template>
    <div class="scenic-spot-container">
        <div class="search-condition-container">
            <el-collapse v-model="activeName" accordion>
                <el-collapse-item :title="`收录景点${totalPageCount}处（可展开此进行查询）`" name="1">
                    <!-- 地区信息 -->
                    <div class="region-group">
                        <div class="region-level">
                            <div class="form-label">父地区</div>
                            <el-radio-group v-model="regionProvinceId" @change="handleChangeProvince"
                                class="radio-group">
                                <el-radio v-for="region in regionList" :key="region.id" :value="region.id"
                                    class="radio-item">
                                    {{ region.name }}
                                </el-radio>
                            </el-radio-group>
                        </div>

                        <div class="region-level" v-if="childrenRegionList.length">
                            <div class="form-label">子地区</div>
                            <el-radio-group v-model="childrenRegionId" class="radio-group">
                                <el-radio v-for="region in childrenRegionList" :key="region.id" :value="region.id"
                                    class="radio-item">
                                    {{ region.name }}
                                </el-radio>
                            </el-radio-group>
                        </div>
                    </div>
                    <!-- 景点名称 -->
                    <div>
                        <div class="form-label">景点名称</div>
                        <el-input style="max-width: 300px;" v-model="scenicSpotQueryDTO.title"
                            placeholder="景点名称"></el-input>
                    </div>

                    <!-- 景点类别 -->
                    <div>
                        <div class="form-label" style="font-size: 22px;margin-bottom: 10px;">类别</div>
                        <el-input style="max-width: 300px;" v-model="scenicSpotQueryDTO.categoryKey"
                            placeholder="类别关键词"></el-input>
                    </div>
                    <!-- 录入时间 -->
                    <div>
                        <div class="form-label">录入开始-录入结束</div>
                        <el-date-picker style="max-width: 300px;" v-model="dateRanges" type="daterange"
                            range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期">
                        </el-date-picker>
                    </div>
                    <!-- 搜索按钮区域 -->
                    <div class="search-operation-container">
                        <el-button round type="primary" @click="handleAddScenicSpot">
                            <el-icon>
                                <Plus />
                            </el-icon>
                            新增景点
                        </el-button>
                        <el-button @click="searchScenicSpotList" type="primary" round>搜索</el-button>
                        <el-button plain round @click="resetCondition">重置</el-button>
                    </div>
                </el-collapse-item>
            </el-collapse>
        </div>
        <div v-if="!scenicSpotListVOS.length">
            <el-empty description="暂无景点数据"></el-empty>
        </div>
        <!-- 景点列表信息 -->
        <div class="scenic-list-container">

            <div class="scenic-spot-item" :key="`scenic-spot-item-${ScenicSpotListVO.id}`"
                v-for="ScenicSpotListVO in scenicSpotListVOS">
                <img class="cover" :src="ScenicSpotListVO.cover" alt="" srcset="">

                <div class="title">{{ ScenicSpotListVO.title }}</div>
                <div class="btn-group">
                    <div class="block" @click="goDetail(ScenicSpotListVO.id)">
                        <el-icon>
                            <View />
                        </el-icon>
                        <span>
                            查看详情
                        </span>
                    </div>
                    <div class="block" @click="goEdit(ScenicSpotListVO.id)">
                        <el-icon>
                            <Edit />
                        </el-icon>
                        <span>
                            修改
                        </span>
                    </div>
                    <div class="block" @click="delScenicSpot(ScenicSpotListVO)">
                        <el-icon>
                            <Delete />
                        </el-icon>
                        <span>
                            删除
                        </span>
                    </div>
                </div>
                <div class="btn-group">
                    <div class="block" @click="scenicRouteItem(ScenicSpotListVO.id)">
                        <el-icon>
                            <Compass />
                        </el-icon>
                        <span>
                            景点路线
                        </span>
                    </div>
                    <div class="block" @click="scenicTickets(ScenicSpotListVO.id)">
                        <el-icon>
                            <ticket />
                        </el-icon>

                        <span>
                            景点门票
                        </span>
                    </div>
                </div>
                <div class="region">
                    <el-icon>
                        <location-filled />
                    </el-icon>

                    <span>{{ ScenicSpotListVO.countyName }}</span>
                    <span class="point"></span>
                    <span>{{ ScenicSpotListVO.townName }}</span>
                </div>
                <div class="summary">
                    {{ ScenicSpotListVO.summary }}
                </div>
            </div>
        </div>
        <!-- 分页区域 -->
        <div v-if="scenicSpotListVOS.length">
            <div class="pagination">
                <el-pagination v-model:current-page="scenicSpotQueryDTO.current"
                    v-model:page-size="scenicSpotQueryDTO.size" :page-sizes="[15, 30, 60]" :total="totalPageCount"
                    layout="total, sizes, prev, pager, next, jumper" @size-change="handleSizeChange"
                    @current-change="handleCurrentChange" />
            </div>
        </div>
    </div>
</template>
<script setup lang="ts">
import { ref, reactive, onMounted } from "vue"
import {
    ElMessage,
    ElMessageBox,
    ElNotification
} from "element-plus"
import { useRouter } from "vue-router"
import type { ScenicSpotListVO, ScenicSpotQueryDTO } from "@/types/scenic-spot"
import type { Region, RegionQueryDTO } from "@/types/region"
import {
    queryScenicSpotApi,
    delScenicSpotApi
} from "@/api/scenic-spot-api"
import { queryListApi } from "@/api/region-api"
import { handleDateRange } from "@/utils/date"

// 响应式数据
const scenicSpotQueryDTO = reactive<ScenicSpotQueryDTO>({
    current: 1,
    size: 15,
    title: '',
    regionIds: [],
    startTime: null,
    endTime: null
})

const activeName = ref('1')
const regionProvinceId = ref<null | number>(null) // 父地区ID
const childrenRegionId = ref<null | number>(null) // 子地区ID
const childrenRegionList = ref<Region[]>([])
const regionList = ref<Region[]>([])
const dateRanges = ref<Date[]>([])
const regionQueryDTO = reactive<RegionQueryDTO>({
    parentId: -1
})

const scenicSpotListVOS = ref<ScenicSpotListVO[]>([]) // 景点列表数据
const totalPageCount = ref<number | undefined>(0) // 总数据条数

const router = useRouter()

const resetCondition = async () => {
    scenicSpotQueryDTO.regionIds = []
    scenicSpotQueryDTO.title = ''
    regionProvinceId.value = -2
    childrenRegionId.value = -3
    scenicSpotQueryDTO.startTime = null
    scenicSpotQueryDTO.endTime = null
    dateRanges.value = []
    childrenRegionList.value = []
    scenicSpotQueryDTO.categoryKey = ''
    await fetchScenicSpot()
}

// 跳转景点路线页
const scenicRouteItem = (id: number) => {
    router.push(`/admin/scenic-spot-route-item-admin?scenicSpotId=${id}`);
}

// 跳转景点路线页
const scenicTickets = (id: number) => {
    router.push(`/admin/scenic-spot-tickets-admin?scenicSpotId=${id}`);
}

// 跳转详情页
const goDetail = (id: number) => {
    router.push(`/admin/scenic-spot-detail?scenicSpotId=${id}`);
}

// 跳转景点修改页
const goEdit = (id: number) => {
    router.push(`/admin/scenic-spot-edit?scenicSpotId=${id}`);
}

// 搜索事件
const searchScenicSpotList = async () => {
    if (regionProvinceId.value === -2) {
        scenicSpotQueryDTO.regionIds = []
        await fetchScenicSpot()
        return
    }
    // 处理地区信息
    if (regionProvinceId.value && regionProvinceId.value !== -2) {
        scenicSpotQueryDTO.regionIds = []
        if (childrenRegionId.value && childrenRegionId.value !== -3) {
            scenicSpotQueryDTO.regionIds?.push(
                regionProvinceId.value,
                childrenRegionId.value
            )
        } else { // 只查县
            const regionIds = childrenRegionList.value
                .filter(region => region.id !== -3)
                .map(entity => entity.id)
            scenicSpotQueryDTO.regionIds?.push(
                ...regionIds as any
            )
        }

    }
    const dates = handleDateRange(dateRanges.value)
    if (dates) {
        scenicSpotQueryDTO.startTime = dates.start
        scenicSpotQueryDTO.endTime = dates.end
    }
    await fetchScenicSpot()

}

const queryRegionList = async () => {
    try {
        const { data } = await queryListApi(regionQueryDTO)
        regionList.value = data
        // 加上不限制父地区的条件
        regionList.value.unshift(
            {
                id: -2,
                name: '不限制地区'
            }
        )
    } catch (error: any) {
        ElMessage.error('查询地区信息异常：', error)
    }
}

const delScenicSpot = async (scenicSpotListVO: ScenicSpotListVO) => {
    try {
        const response = await ElMessageBox.confirm(
            `确定要删除"【${scenicSpotListVO.title}】"吗？`,
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
                // 删除景点数据
                await delScenicSpotApi(scenicSpotListVO.id)
                // 加载景点列表
                await fetchScenicSpot()
                ElNotification.success({
                    title: '景点删除',
                    message: `景点【${scenicSpotListVO.title}】删除成功`,
                    duration: 1500
                })
            } catch (error: any) {
                ElMessage.error(error)
                console.error("景点删除异常：", error);
            }

        }
    } catch (error) {
        // 用户取消删除
        console.log('取消删除')
    }
}

const handleChangeProvince = async () => {
    try {

        console.log(regionProvinceId.value);


        if (regionProvinceId.value === -2) { // 证明选中的是不限制地区，子地区不必显示
            childrenRegionList.value = []
            return
        }

        const { data } = await queryListApi({
            parentId: regionProvinceId.value
        })
        childrenRegionList.value = data
        // 加上不限制子地区的条件
        childrenRegionList.value.unshift(
            {
                id: -3,
                name: '不限制子地区'
            }
        )
    } catch (error: any) {
        ElMessage.error('查询子地区信息异常：', error)
    }
}

const handleSizeChange = async (size: number) => {
    scenicSpotQueryDTO.size = size
    scenicSpotQueryDTO.current = 1
    await fetchScenicSpot()
}

const handleCurrentChange = async (current: number) => {
    scenicSpotQueryDTO.current = current
    await fetchScenicSpot()
}

const handleSearch = async (keyword: string) => {
    scenicSpotQueryDTO.title = keyword
    scenicSpotQueryDTO.current = 1
    await fetchScenicSpot()
}

const fetchScenicSpot = async () => {
    try {
        const { data, total } = await queryScenicSpotApi(scenicSpotQueryDTO)
        scenicSpotListVOS.value = data
        totalPageCount.value = total
    } catch (error: any) {
        ElMessage.error('景点查询异常：', error)
    }
}

const handleAddScenicSpot = () => {
    router.push('/admin/scenic-spot-save')
}

onMounted(async () => {
    await queryRegionList();
    await fetchScenicSpot();
})

</script>
<style lang="scss" scoped>
$primary-color: #409eff;
$border-color: #e4e7ed;
$transition-base: all 0.3s ease;

.search-condition-container {
    padding: 10px;
}

.search-operation-container {
    margin-block: 20px;
}

:deep(.el-collapse) {
    border-top: none;
    border-bottom: none;
}

:deep(.el-collapse-item__title) {
    font-size: 22px;
}

:deep(.el-collapse-item__header) {
    border-bottom: none;
}

.form-label {
    font-size: 16px;
    color: rgb(99, 99, 99);
    margin-block: 16px;
}

.region-group,
.category-group {

    .region-level,
    .category-level {
        margin-bottom: 24px;


        .radio-group {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;

            .radio-item {
                --el-radio-font-size: 14px;
                --el-radio-checked-color: $primary-color;
                padding: 4px 12px;
                border: 1px solid $border-color;
                border-radius: 8px;
                cursor: pointer;
                transition: $transition-base;

                &:hover {
                    border-color: $primary-color;
                    background-color: rgba(64, 158, 255, 0.05);
                }

                .el-radio__input:checked+.el-radio__label {
                    color: $primary-color;
                    font-weight: 500;
                }
            }
        }
    }
}

.btn-group {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-block: 10px;

    .block {
        display: flex;
        justify-content: left;
        align-items: center;
        cursor: pointer;
        color: rgb(31, 31, 31);
        gap: 2px;

        &:hover {
            text-decoration: underline;
        }
    }
}

.pagination {
    padding-block: 20px;
}

.scenic-list-container {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    grid-gap: 20px;

    .scenic-spot-item {
        // 父相子绝
        position: relative;

        padding: 10px;
        box-sizing: border-box;
        cursor: pointer;
        transition: all 0.5s ease;

        &:hover {
            box-shadow: 0 4px 6px rgb(240, 240, 240);
            border-radius: 10px;
        }

        .cover {
            width: 100%;
            object-fit: cover;
            aspect-ratio: 4/3;
            border-radius: 10px;
            cursor: pointer;
            transition: all .5s ease;

            &:hover {
                scale: 1.05;
            }
        }

        .title {
            max-width: 200px;
            font-size: 20px;
            color: rgb(31, 31, 31);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .summary {
            position: absolute;
            right: 0;
            top: 30px;
            width: 100%;
            text-align: start;
            color: rgb(255, 255, 255);
            padding: 20px;
            box-sizing: border-box;
            font-size: 12px;

            /* 核心：三行省略关键属性 */
            display: -webkit-box;
            /* 弹性盒模型 */
            -webkit-box-orient: vertical;
            /* 垂直排列 */
            -webkit-line-clamp: 2;
            /* 限制显示行数 */
            overflow: hidden;
            /* 超出部分隐藏 */
            text-overflow: ellipsis;
            /* 省略号效果（兼容兜底） */
            /* 可选：增加行高，提升可读性 */
            line-height: 1.7;
            /* 防止绝对定位元素被遮挡 */
            // z-index: 10;
        }

        .region {
            position: absolute;
            right: 16px;
            top: 16px;
            background-color: rgba(0, 0, 0, 0.7);
            color: rgb(255, 255, 255);
            font-size: 12px;
            padding: 4px 12px;
            border-radius: 20px;
            display: flex;
            justify-content: left;
            align-items: center;
            cursor: pointer;
            gap: 6px;

            .point {
                width: 4px;
                height: 4px;
                border-radius: 50%;
                background-color: rgb(255, 255, 255);
            }

            &:hover {
                background-color: rgba(0, 0, 0, 0.8);
            }
        }
    }
}

.top-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 0 26px 0;
    background: #fff;
    border-radius: 6px;

    .nav-left,
    .nav-right {
        display: flex;
        align-items: center;
        gap: 12px;
    }
}
</style>