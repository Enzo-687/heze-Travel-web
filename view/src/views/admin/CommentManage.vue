<template>
    <div class="container">
        <div class="top-header">
            <div class="nav-left">
            </div>
            <div class="nav-right">
                <div>
                    <Input placeholder="搜索评论" @listener="listener" />
                </div>
            </div>
        </div>
        <!-- 表格及分页信息 -->
        <div>
            <el-table :data="apiResult.data">
                <el-table-column width="200" prop="username" label="评论者">
                    <template #default="scope">
                        <div class="over-text">
                            {{ scope.row.username }}
                        </div>
                    </template>
                </el-table-column>
                <el-table-column prop="content" label="评论内容">
                    <template #default="scope">
                        <div class="over-text">
                            {{ scope.row.content }}
                        </div>
                    </template>
                </el-table-column>
                <el-table-column prop="contentType" sortable width="108" label="所属模块"></el-table-column>
                <el-table-column prop="upvoteCount" sortable width="128" label="点赞量"></el-table-column>
                <el-table-column prop="parentId" sortable width="108" label="层级">
                    <template #default="scope">
                        <div>{{ scope.row.parentId === null ? '父级' : '子级' }}</div>
                    </template>
                </el-table-column>
                <el-table-column prop="createTime" sortable width="168" label="评论时间"></el-table-column>
                <el-table-column label="操作" width="150" align="center">
                    <template #default="scope">
                        <el-button type="danger" link size="small" @click="handleDelete(scope.row)">
                            <el-icon>
                                <Delete />
                            </el-icon>
                            删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
            <!-- 分页组件区域 -->
            <div class="pager">
                <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                    v-model:current-page="evaluationQueryDto.current" :page-sizes="[10, 20]"
                    v-model:page-size="evaluationQueryDto.size" layout="total, sizes, prev, pager, next, jumper"
                    :total="apiResult.total"></el-pagination>
            </div>
        </div>

        <!-- 删除确认弹窗 -->
        <el-dialog title="删除评论" :show-close="false" v-model="dialogDeletedVisible" width="20%">
            <span>确定删除评论数据？</span>
            <template #footer>
                <span class="dialog-footer">
                    <el-button size="mini" @click="dialogDeletedVisible = false">取消</el-button>
                    <el-button size="mini" type="primary" @click="confirmDeleted">确定</el-button>
                </span>
            </template>
        </el-dialog>
    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Delete } from '@element-plus/icons-vue'
import { post, del } from "@/utils/request"
import Input from "@/components/Input.vue"; // 自己封装好的输入框组件

// 定义接口
interface Evaluation {
    id: number
    username: string
    content: string
    contentType: string
    upvoteCount: number
    parentId: number | null
    createTime: string
}

interface ApiResult {
    data: Evaluation[]
    total: number
}

interface EvaluationQueryDto {
    current: number
    size: number
    content?: string
}

// 响应式数据
const id = ref<number | null>(null)
const apiResult = reactive<ApiResult>({
    data: [],
    total: 0
})

const evaluationQueryDto = reactive<EvaluationQueryDto>({
    current: 1,
    size: 10
})

const dialogDeletedVisible = ref(false)

// 生命周期
onMounted(() => {
    fetchFreshData()
})

// 输入框组件输入回传
const listener = (text: string) => {
    evaluationQueryDto.content = text
    fetchFreshData()
}

// 查询评论数据
const fetchFreshData = async () => {
    try {
        const { data, total } = await post<any>('/comment/query', evaluationQueryDto)
        apiResult.data = data
        apiResult.total = total
    } catch (error) {
        console.error('查询评论信息异常:', error)
    }
}

// 分页 - 处理页面页数切换
const handleSizeChange = (size: number) => {
    evaluationQueryDto.size = size
    evaluationQueryDto.current = 1
    fetchFreshData()
}

// 分页 - 处理页面当前页切换
const handleCurrentChange = (current: number) => {
    evaluationQueryDto.current = current
    fetchFreshData()
}

// 表格点击删除评论
const handleDelete = (row: Evaluation) => {
    dialogDeletedVisible.value = true
    id.value = row.id
}

// 评论删除
const confirmDeleted = async () => {
    try {
        const { code } = await del(`/comment/${id.value}`)
        if (code === 200) {
            ElMessage.success({
                message: '删除成功',
                type: 'success',
                duration: 1000
            })
            dialogDeletedVisible.value = false
            id.value = null
            fetchFreshData()
        }
    } catch (error) {
        console.log("删除评论数据异常：", error)
    }
}
</script>

<style scoped lang="scss">
.pager {
    margin-block: 20px;
    display: flex;
    justify-content: flex-end;
}

/* 默认隐藏操作按钮 */
.operate-buttons {
    transition: opacity 0.3s;
    cursor: pointer;

    .el-icon {
        padding: 8px;
        border-radius: 6px;
        transition: all .5s ease;

        &:hover {
            background-color: rgb(236, 237, 238);
        }
    }
}

.container {
    margin: 10px 20px;
}

.top-header {
    margin-block: 10px;
    padding-inline: 10px;
    border-radius: 5px;
    display: flex;
    justify-content: space-between;
    align-items: center;

    .nav-left,
    .nav-right {
        display: flex;
        justify-content: left;
        align-items: center;
        gap: 10px;
    }

    .nav-left {
        display: flex;
    }
}
</style>