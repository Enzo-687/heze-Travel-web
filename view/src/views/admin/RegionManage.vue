<template>
    <div class="Region-container">
        <!-- 搜索条件 -->
        <div class="top-header">
            <div class="nav-left">
                <div>
                    <Input placeholder="搜索县，按Enter↩︎键" @listener="handleSearch" />
                </div>
                <!-- <el-button type="primary" @click="handleRootRegion">
                    新增根节点
                </el-button> -->
            </div>
            <div class="nav-right">

            </div>
        </div>

        <!-- 表格区域 -->
        <div class="table-container">
            <el-table ref="tableRef" :data="RegionList" row-key="id" lazy :load="loadChildren"
                :tree-props="{ children: 'children', hasChildren: 'hasChildren' }" border style="width: 100%;">
                <!-- 地区名称列 -->
                <el-table-column label="区域名称">
                    <template #default="{ row }">
                        <div class="row-info" :style="{ paddingLeft: (row.level - 1) * 4 + 'px' }">
                            <el-icon v-if="row.hasChildren" class="folder-icon">
                                <LocationFilled />
                            </el-icon>
                            <el-icon v-else class="file-icon">
                                <CollectionTag />
                            </el-icon>
                            <span v-if="row.level===1" class="file-icon-name">{{ row.name }}</span>
                            <span v-else class="Region-name">{{ row.name }}</span>
                        </div>
                    </template>
                </el-table-column>
                <!-- 层级列 -->
                <el-table-column prop="level" label="划分级别" width="160" align="center">
                    <template #default="{ row }">
                        <span>{{ getLevelText(row.level) }}</span>
                    </template>
                </el-table-column>

                <!-- 操作列 -->
                <el-table-column label="操作" width="230" align="center" fixed="right">
                    <template #default="{ row }">
                        <!-- 县和乡镇可添加子地区，村不可添加 -->
                        <el-button v-if="row.level < 3" type="info" size="small"
                            @click="handleAddChild(row)" :icon="Plus">
                            添加
                        </el-button>
                        <el-button type="info" size="small" @click="handleEdit(row)" :icon="Edit">
                            编辑
                        </el-button>
                        <el-button @click.stop type="info" size="small"
                            @click="handleDelete(row)" :icon="Delete">
                            删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>

            <!-- 分页（仅根节点分页） -->
            <div v-if="isRootQuery" class="pagination-container">
                <el-pagination v-model:current-page="RegionQueryDTO.current" v-model:page-size="RegionQueryDTO.size"
                    :total="total" :page-sizes="[10, 20, 50, 100]" layout="total, sizes, prev, pager, next, jumper"
                    @size-change="handleSizeChange" @current-change="handleCurrentChange" />
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import Input from "@/components/Input.vue"
import { ElTable, ElMessage, ElMessageBox } from "element-plus"
import { ref, reactive, onMounted, computed } from "vue"
import { Plus, Edit, Delete } from "@element-plus/icons-vue"
import { queryListApi, addRegionApi, updateRegionApi, delRegionApi } from "@/api/region-api"
import type { RegionQueryDTO, Region } from "@/types/region.ts"

// 表格引用
const tableRef = ref<InstanceType<typeof ElTable>>()

// 响应式数据
const RegionList = ref<Region[]>([])
const total = ref(0)

// 是否正在查询根节点
const isRootQuery = computed(() => RegionQueryDTO.parentId === -1)

// 查询参数
const RegionQueryDTO = reactive<RegionQueryDTO>({
    current: 1,
    size: 10,
    name: '',
    parentId: -1, // 初始查询根节点
    level: undefined
})

// 图书类别实体
const Region = reactive<Region>({
    name: '', // 图书类别名
    level: 1, // 默认层级1
    parentId: -1, // 默认根节点
})

// 搜索表单
const searchForm = reactive({
    name: '',
    level: undefined as number | undefined
})

// 图书类别删除
const handleDelete = async (row: any) => {
    try {
        console.log("要删除的节点:", row);

        const confirm = await ElMessageBox.confirm(
            `确定要删除地区 "${row.name}" 吗？`,
            '确认删除',
            {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }
        )

        if (confirm) {
            // 检查是否有真实的子节点
            const hasRealChildren = await checkRealChildren(row)

            if (hasRealChildren) {
                ElMessage.warning('其下含有子节点，不可删除')
                return
            }

            // 执行删除请求
            await delRegionApi(row.id)

            // 根据父节点类型处理删除后的更新
            if (row.parentId === -1) {
                // 如果是根节点，重新加载整个表格
                await loadRootCategories()
            } else {
                // 非根节点，更新父节点的状态
                await updateParentAfterDelete(row.parentId, row.id)
            }

            ElMessage.success('删除成功')
        }
    } catch (error) {
        console.log("删除类别异常：", error)
    }
}

// 检查节点是否真的有子节点
const checkRealChildren = async (row: any): Promise<boolean> => {
    try {
        // 首先检查 hasChildren 状态
        if (!row.hasChildren) {
            return false
        }

        // 检查是否有缓存数据
        const lazyMap = tableRef.value!.store.states.lazyTreeNodeMap.value
        const cachedChildren = lazyMap[row.id]

        if (cachedChildren && cachedChildren.length > 0) {
            return true
        }

        // 如果没有缓存，查询数据库确认
        const childQuery: RegionQueryDTO = {
            parentId: row.id
        }
        const response = await queryListApi(childQuery)

        // 更新 hasChildren 状态（保持与数据库一致）
        if (response.data.length === 0) {
            updateNodeHasChildren(row.id, false)
        }

        return response.data.length > 0
    } catch (error) {
        console.error('检查子节点失败:', error)
        return false
    }
}

// 删除后更新父节点状态
const updateParentAfterDelete = async (parentId: number, deletedChildId: number) => {
    try {
        // 1. 从缓存中移除被删除的子节点
        const lazyMap = tableRef.value!.store.states.lazyTreeNodeMap.value

        if (lazyMap[parentId]) {
            // 过滤掉被删除的子节点
            lazyMap[parentId] = lazyMap[parentId].filter((child: any) => child.id !== deletedChildId)

            console.log('删除后父节点剩余子节点:', lazyMap[parentId])

            // 2. 检查父节点是否还有子节点
            const childQuery: RegionQueryDTO = {
                parentId: parentId
            }
            const response = await queryListApi(childQuery)

            if (response.data.length === 0) {
                // 数据库中没有子节点了，更新父节点状态
                updateNodeHasChildren(parentId, false)

                // 从缓存中移除空数组
                delete lazyMap[parentId]
            } else if (lazyMap[parentId] && lazyMap[parentId].length === 0) {
                // 缓存中没有子节点了，但数据库中有（可能还没加载）
                // 保持 hasChildren 为 true，但清空缓存
                delete lazyMap[parentId]
            }
        } else {
            // 如果父节点没有缓存，查询数据库确认是否还有子节点
            const childQuery: RegionQueryDTO = {
                parentId: parentId
            }
            const response = await queryListApi(childQuery)

            if (response.data.length === 0) {
                // 数据库中没有子节点了，更新父节点状态
                updateNodeHasChildren(parentId, false)
            }
        }

        // 3. 强制刷新表格显示
        setTimeout(() => {
            RegionList.value = [...RegionList.value]
        }, 100)
    } catch (error) {
        console.error('更新父节点失败:', error)
    }
}

// 更新节点的 hasChildren 状态
const updateNodeHasChildren = (nodeId: number, hasChildren: boolean) => {
    const findAndUpdate = (nodes: any[]): boolean => {
        for (const node of nodes) {
            if (node.id === nodeId) {
                node.hasChildren = hasChildren

                // 如果没有子节点了，清空 children 数组和缓存
                if (!hasChildren) {
                    node.children = []

                    // 清除缓存
                    const lazyMap = tableRef.value!.store.states.lazyTreeNodeMap.value
                    if (lazyMap[nodeId]) {
                        delete lazyMap[nodeId]
                    }
                }

                console.log(`更新节点 ${nodeId} 的 hasChildren 为: ${hasChildren}`)
                return true
            }

            if (node.children && node.children.length > 0) {
                if (findAndUpdate(node.children)) {
                    return true
                }
            }
        }
        return false
    }

    findAndUpdate(RegionList.value)
}

// 加载根节点地区（分页查询）
const loadRootCategories = async () => {
    try {
        RegionQueryDTO.parentId = -1

        const response = await queryListApi(RegionQueryDTO)

        RegionList.value = response.data.map(item => ({
            ...item,
            children: []
        })) as Region[]

        total.value = response.total
        searchForm.level = undefined
    } catch (error) {
        console.error("查询根地区异常：", error)
        ElMessage.error("加载地区数据失败")
    }
}

// 懒加载子节点
const loadChildren = async (row: Region, treeNode: any, resolve: (data: Region[]) => void) => {
    try {
        if (row.hasChildren) {
            const childQuery: RegionQueryDTO = {
                name: '',
                parentId: row.id
            }

            const response = await queryListApi(childQuery)

            const children = response.data.map(child => ({
                ...child,
                children: []
            })) as Region[]

            resolve(children)
        } else {
            resolve([])
        }
    } catch (error) {
        console.error("加载子地区异常：", error)
        ElMessage.error("加载子地区失败")
        resolve([])
    }
}

// 根据层级获取标签类型
const getLevelTagType = (level: number): string => {
    const typeMap: { [key: number]: string } = {
        1: 'primary',
        2: 'success',
        3: 'warning'
    }
    return typeMap[level] || 'info'
}

// 获取层级文本
const getLevelText = (level: number): string => {
    const textMap: { [key: number]: string } = {
        1: '县',
        2: '乡镇',
        3: '村'
    }
    return textMap[level] || `层级 ${level}`
}

// 搜索
const handleSearch = (name: any) => {
    RegionQueryDTO.current = 1
    RegionQueryDTO.name = name
    if (searchForm.level) {
        RegionQueryDTO.level = searchForm.level
    } else {
        RegionQueryDTO.level = undefined
    }

    loadRootCategories()
}

// 重置
const handleReset = () => {
    searchForm.name = ''
    searchForm.level = undefined
    RegionQueryDTO.current = 1
    RegionQueryDTO.name = ''
    RegionQueryDTO.level = undefined

    loadRootCategories()
}

const handleRootRegion = async () => {
    try {
        const { value } = await ElMessageBox.prompt('请输入县名称', '添加县', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            inputPattern: /.+/,
            inputErrorMessage: '地区名称不能为空'
        })

        const Region = {
            name: value,
            level: 1,
            parentId: -1,
            hasChildren: false
        }
        try {
            await addRegionApi(Region)
            console.log(`添加的县名称：${value}`)
            ElMessage.success('添加成功')
            loadRootCategories()
        } catch (e: any) {
            ElMessage.warning(e.messsage)
        }

    } catch (error) {
        if (error !== 'cancel') {
            console.error('添加县失败：', error)
            ElMessage.error('添加失败')
        }
    }
}

// 添加子地区
const handleAddChild = async (row: Region) => {
    try {
        console.log("当前节点：", row);

        const childLevelText = row.level === 1 ? '乡镇' : '村'
        const { value } = await ElMessageBox.prompt(`请输入 ${row.name} 下的${childLevelText}名称`, `添加${childLevelText}`, {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            inputPattern: /.+/,
            inputErrorMessage: '地区名称不能为空'
        })
        if(!row.level){
            return
        }
        Region.level = row.level + 1
        Region.name = value
        Region.parentId = row.id as number
        try {
            const { data } = await addRegionApi(Region)
            if (row.id) {
                // 确保父节点的 hasChildren 为 true
                row.hasChildren = true

                // 更新缓存
                const lazyMap = tableRef.value!.store.states.lazyTreeNodeMap.value
                lazyMap[row.id] = [
                    ...(lazyMap[row.id] || []),
                    { ...data, children: [], hasChildren: false }
                ]
            }
            ElMessage.success('子节点添加成功')
        } catch (e: any) {
            ElMessage.warning(e.messsage)
        }

    } catch (error) {
        if (error !== 'cancel') {
            console.error('添加子地区失败：', error)
            ElMessage.error('添加失败')
        }
    }
}

// 编辑地区
const handleEdit = async (row: Region) => {
    try {
        console.log("当前节点：", row);

        const { value } = await ElMessageBox.prompt('请输入新的地区名称', '编辑地区', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            inputValue: row.name,
            inputPattern: /.+/,
            inputErrorMessage: '地区名称不能为空'
        })

        const RegionUpdateDTO = {
            id: row.id,
            name: value
        }
        try {
            await updateRegionApi(RegionUpdateDTO as any)
            row.name = value
            ElMessage.success('子节点修改成功')
        } catch (e: any) {
            ElMessage.warning(e.messsage)
        }

    } catch (error) {
        if (error !== 'cancel') {
            console.error('添加子地区失败：', error)
            ElMessage.error('添加失败')
        }
    }
}

// 分页大小改变
const handleSizeChange = (size: number) => {
    RegionQueryDTO.size = size
    RegionQueryDTO.current = 1
    loadRootCategories()
}

// 当前页改变
const handleCurrentChange = (current: number) => {
    RegionQueryDTO.current = current
    loadRootCategories()
}

// 页面加载时获取根节点数据
onMounted(() => {
    loadRootCategories()
})
</script>

<style lang="scss" scoped>

.row-info{
    display: flex;
    justify-content: left;
    align-items: center;
}

:deep(.el-table__body-wrapper) {
    overflow: hidden !important;
    scrollbar-width: none !important;
    /* Firefox */
    -ms-overflow-style: none !important;
    /* IE/Edge */
}

:deep(.el-table__body-wrapper::-webkit-scrollbar) {
    display: none !important;
    width: 0 !important;
    height: 0 !important;
}

:deep(.el-table__fixed-body-wrapper) {
    overflow: hidden !important;
}

:deep(.el-table__fixed-right .el-table__fixed-body-wrapper) {
    overflow: hidden !important;
}

/* 隐藏所有可能的滚动容器 */
:deep([class*="scrollbar"]) {
    overflow: hidden !important;
}

/* 隐藏所有可能的 ::-webkit-scrollbar */
:deep(::-webkit-scrollbar) {
    display: none !important;
}

.top-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 0 12px 0;
    background: #fff;
    border-radius: 6px;

    .nav-left,
    .nav-right {
        display: flex;
        align-items: center;
        gap: 12px;
    }
}

.Region-container {
    padding: 10px 0;
    background-color: #fff;
    border-radius: 4px;
    /* 移除固定高度，让内容自然撑开 */
}

.search-box {
    padding: 20px;
    background-color: #fff7f7;
    border-bottom: 1px solid rgb(240, 240, 240);
    border-radius: 4px;

    .el-form-item {
        margin-bottom: 0;
    }
}

.table-container {
    /* 移除flex相关设置，让表格自然高度 */

    :deep(.el-table) {
        /* 移除固定高度相关设置 */

        .folder-icon {
            color: rgb(31,31,31);
            font-weight: 700;
            font-size: 18px;
            margin-right: 8px;
        }

        .file-icon {
            color: rgb(51,51,51);
            margin-right: 8px;
        }

        
        .file-icon-name {
            color: rgb(51,51,51);
            margin-right: 8px;
            font-size: 18px;
        }

        .Region-name {
            color: rgb(93, 92, 92);
            font-weight: 400;
            font-size: 16px;
        }

        .el-table__expand-icon {
            cursor: pointer;
            font-size: 14px;
        }

        .el-table__placeholder {
            display: none !important;
        }

        /* 完全隐藏滚动条，让内容自然撑开 */
        .el-table__body-wrapper {
            overflow-y: hidden !important;
            /* 隐藏纵向滚动条 */
            overflow-x: hidden !important;
            /* 隐藏横向滚动条 */
        }

        /* 移除之前的所有滚动条样式 */
        .el-table__body-wrapper::-webkit-scrollbar {
            display: none !important;
            /* 隐藏Webkit滚动条 */
        }

        /* 处理固定列 */
        .el-table__fixed-right {
            .el-table__fixed-body-wrapper {
                overflow-y: hidden !important;

                &::-webkit-scrollbar {
                    display: none !important;
                }
            }
        }

        /* 对于Firefox */
        .el-table__body-wrapper {
            scrollbar-width: none !important;
            /* Firefox */
            -ms-overflow-style: none !important;
            /* IE/Edge */
        }
    }
}

.pagination-container {
    display: flex;
    padding: 8px 20px 8px 10px;
    border-radius: 4px;
}

:deep(.el-tag) {
    font-size: 16px;
}

:deep(.el-table .cell) {
    display: flex;
    align-items: center;
    el-icon{
        font-size: 16px;
    }
}

:deep(.el-table tr) {
    height: 65px;
}

:deep(.el-table th.el-table__cell) {
    background-color: rgb(255, 255, 255) !important;
}
</style>