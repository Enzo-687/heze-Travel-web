<template>
    <div class="scenic-spot-container">
        <div class="search-condition-container">
            <el-collapse v-model="activeName" accordion>
                <el-collapse-item :title="`景点攻略${totalPageCount}篇（可展开此进行查询及操作）`" name="1">
                    <!-- 景点攻略名称 -->
                    <div>
                        <div class="form-label">攻略标题</div>
                        <el-input style="max-width: 300px;" v-model="scenicSpotStrategyQueryDTO.title"
                            placeholder="标题"></el-input>
                    </div>
                    <!-- 录入时间 -->
                    <div>
                        <div class="form-label">发布开始时间-发布结束时间</div>
                        <el-date-picker style="max-width: 300px;" v-model="dateRanges" type="daterange"
                            range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期">
                        </el-date-picker>
                    </div>
                    <!-- 搜索按钮区域 -->
                    <div class="search-operation-container">
                        <el-button @click="searchScenicSpotStraegyList" type="primary" round>搜索</el-button>
                        <el-button plain round @click="resetCondition">重置</el-button>
                    </div>
                </el-collapse-item>
            </el-collapse>
        </div>
        <div v-if="!scenicSpotStrategyListVO.length">
            <el-empty description="暂无景点攻略数据"></el-empty>
        </div>
        <!-- 景点攻略列表信息 -->
        <div class="scenic-list-container">

            <div class="scenic-spot-item" :key="`scenic-spot-item-${scenicSpotStategy.id}`"
                v-for="scenicSpotStategy in scenicSpotStrategyListVO">
                <img class="cover" :src="scenicSpotStategy.cover" alt="" srcset="">

                <div class="title">{{ scenicSpotStategy.title }}</div>
                <div class="btn-group">
                    <div class="block" @click="goDetail(scenicSpotStategy.id as any)">
                        <el-icon>
                            <View />
                        </el-icon>
                        <span>
                            查看详情
                        </span>
                    </div>
                    <div class="block" @click="delScenicSpotStrategy(scenicSpotStategy)">
                        <el-icon>
                            <Delete />
                        </el-icon>
                        <span>
                            删除
                        </span>
                    </div>
                </div>
                <div style="display: flex;justify-content: center;align-items: center;">
                    <el-switch @change="handleAuditStatus(scenicSpotStategy)" v-model="scenicSpotStategy.auditStatus"
                        active-text="已审核" inactive-text="未审核"></el-switch>
                </div>
                <div class="region">
                    <div class="base-info">
                        <img :src="scenicSpotStategy.avatar" alt="" srcset="">
                        <span>{{ scenicSpotStategy.username }}</span>
                    </div>
                    <div class="status">
                        <el-icon v-if="scenicSpotStategy.auditStatus">
                            <CircleCheckFilled />
                        </el-icon>
                        <el-icon v-else>
                            <CircleCloseFilled />
                        </el-icon>
                        <span>{{ scenicSpotStategy.auditStatus ? '已审核' : '未审核' }}</span>
                    </div>

                </div>
                <div class="summary">
                    {{ scenicSpotStategy.summary }}
                </div>
            </div>
        </div>
        <!-- 分页区域 -->
        <div v-if="scenicSpotStrategyListVO.length">
            <div class="pagination">
                <el-pagination v-model:current-page="scenicSpotStrategyQueryDTO.current"
                    v-model:page-size="scenicSpotStrategyQueryDTO.size" :page-sizes="[15, 30, 60]"
                    :total="totalPageCount" layout="total, sizes, prev, pager, next, jumper"
                    @size-change="handleSizeChange" @current-change="handleCurrentChange" />
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
import { handleDateRange } from "@/utils/date"

import type {
    ScenicSpotStrategy,
    ScenicSpotStrategyQueryDTO,
    ScenicSpotStrategyListVO
} from "@/types/scenic-spot-strategy"
import {
    queryAllScenciSpotStrategyApi,
    delScenciSpotStrategyApi,
    changeAuditStatusApi
} from "@/api/scenic-spot-strategy-api"

// 响应式数据
const scenicSpotStrategyQueryDTO = reactive<ScenicSpotStrategyQueryDTO>({
    current: 1,
    size: 15,
    title: '',
    scenicSpotId: null
})

const activeName = ref('1')
const dateRanges = ref<Date[]>([])

const scenicSpotStrategyListVO = ref<ScenicSpotStrategyListVO[]>([]) // 景点攻略列表数据
const totalPageCount = ref<number | undefined>(0) // 总数据条数
const router = useRouter()

const resetCondition = async () => {
    scenicSpotStrategyQueryDTO.title = ''
    scenicSpotStrategyQueryDTO.startTime = null
    scenicSpotStrategyQueryDTO.endTime = null
    dateRanges.value = []
    await fetchScenicSpotStrategy()
}

// 审核状态切换
const handleAuditStatus = async (scenicSpotStrategy: ScenicSpotStrategy) => {
    try {
        const response = await ElMessageBox.confirm(
            scenicSpotStrategy.auditStatus ? `确定要通过"【${scenicSpotStrategy.title}】"的审核吗？` : `确定关闭"【${scenicSpotStrategy.title}】"的审核吗？此举将不再公开此篇景点攻略`,
            '操作确定',
            {
                confirmButtonText: scenicSpotStrategy.auditStatus ? '我确定通过审核' : '我确定不再公开',
                cancelButtonText: '取消',
                type: 'warning',
                center: true
            }
        )

        if (response === 'confirm') {
            try {
                // 删除景点攻略数据
                await changeAuditStatusApi(scenicSpotStrategy.id as any,
                    scenicSpotStrategy.auditStatus as any)
                ElNotification.success({
                    title: '操作结果',
                    message: scenicSpotStrategy.auditStatus ? '景点攻略已通过审核，正常展出' : '该篇景点攻略已不再公开',
                    duration: 1500
                })
            } catch (error: any) {
                scenicSpotStrategy.auditStatus = !scenicSpotStrategy.auditStatus
                ElMessage.error(error)
                console.error("景点攻略审核操作异常：", error);
            }

        }
    } catch (error) {
        // 用户取消删除
        console.log('取消删除')
    }
}


// 跳转详情页
const goDetail = (id: number) => {
    router.push(`/admin/scenic-spot-strategy-detail-admin?scenicSpotStrategyId=${id}`);
}

// 搜索事件
const searchScenicSpotStraegyList = async () => {
    const dates = handleDateRange(dateRanges.value)
    // 如果用户选中了时间，则进行时间的格式处理
    if (dates) {
        scenicSpotStrategyQueryDTO.startTime = dates.start
        scenicSpotStrategyQueryDTO.endTime = dates.end
    }
    await fetchScenicSpotStrategy()
}


const delScenicSpotStrategy = async (scenicSpotStategy: ScenicSpotStrategy) => {
    try {
        const response = await ElMessageBox.confirm(
            `确定要删除"【${scenicSpotStategy.title}】"吗？`,
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
                // 删除景点攻略数据
                await delScenciSpotStrategyApi(scenicSpotStategy.id as any)
                // 加载景点攻略列表
                await fetchScenicSpotStrategy()
                ElNotification.success({
                    title: '景点攻略删除',
                    message: `景点攻略【${scenicSpotStategy.title}】删除成功`,
                    duration: 1500
                })
            } catch (error: any) {
                ElMessage.error(error)
                console.error("景点攻略删除异常：", error);
            }

        }
    } catch (error) {
        // 用户取消删除
        console.log('取消删除')
    }
}

const handleSizeChange = async (size: number) => {
    scenicSpotStrategyQueryDTO.size = size
    scenicSpotStrategyQueryDTO.current = 1
    await fetchScenicSpotStrategy()
}

const handleCurrentChange = async (current: number) => {
    scenicSpotStrategyQueryDTO.current = current
    await fetchScenicSpotStrategy()
}

const fetchScenicSpotStrategy = async () => {
    try {
        const { data, total } = await queryAllScenciSpotStrategyApi(scenicSpotStrategyQueryDTO)
        scenicSpotStrategyListVO.value = data
        totalPageCount.value = total
    } catch (error: any) {
        ElMessage.error('景点攻略攻略查询异常：', error)
    }
}

const handleAddScenicSpotStraegy = () => {
    window.open('/scenic-spot-strategy-save')
}

onMounted(async () => {
    // await queryRegionList();
    await fetchScenicSpotStrategy();
})

</script>
<style lang="scss" scoped>
$primary-color: #409eff;
$border-color: #e4e7ed;
$transition-base: all 0.3s ease;


.scenic-spot-container {
    padding: 20px;
    box-sizing: border-box;
}

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

.status {
    display: flex;
    justify-content: left;
    align-items: center;
    gap: 6px;
}

.base-info {
    display: flex;
    justify-content: left;
    align-items: center;

    // padding-bottom: 20px;
    gap: 6px;

    img {
        width: 20px;
        border-radius: 50%;
        height: 20px;
    }

    span {
        width: 50px;
        font-size: 12px;
        color: #33aa15;
              overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
    }
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
    grid-gap: 10px;
    box-sizing: border-box;

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
            top: 50px;
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
            width: calc(100% - 32px);
            top: 16px;
            background-color: rgba(0, 0, 0, 0.6);
            color: rgb(255, 255, 255);
            font-size: 12px;
            padding: 8px 12px;
            border-radius: 20px;
            display: flex;
            justify-content: space-between;
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