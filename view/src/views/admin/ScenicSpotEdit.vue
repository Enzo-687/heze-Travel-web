<template>
    <div class="scenic-spot-save-container">
        <!-- 页头 -->
        <div class="page-header">
            <el-page-header icon="ArrowLeft" content="景点新增" @back="router.go(-1)" class="header-content">
                <template #content>
                    <h2 class="header-title">景点信息修改</h2>
                </template>
            </el-page-header>
        </div>

        <!-- 主容器 -->
        <div class="main-container">
            <!-- 步骤条 -->
            <div class="steps-wrapper">
                <el-steps :active="activeStepIndex" finish-status="success" class="steps-bar" space="auto">
                    <el-step v-for="(step, index) in steps" :key="index" :title="step.title" :icon="step.icon"
                        class="step-item"></el-step>
                </el-steps>
            </div>
            <!-- 操作按钮区 -->
            <div class="action-bar">
                <el-button round type="primary" @click="last" size="mini" class="action-btn prev-btn"
                    :disabled="activeStepIndex === 1">
                    <el-icon>
                        <ArrowLeft />
                    </el-icon>
                    上一步
                </el-button>
                <div class="action-right">
                    <el-button type="primary" round @click="next" size="mini" class="action-btn next-btn"
                        :disabled="activeStepIndex === 5">
                        下一步
                        <el-icon>
                            <ArrowRight />
                        </el-icon>
                    </el-button>
                    <el-button round type="primary" size="mini" class="action-btn submit-btn" @click="editScenicSpot"
                        v-if="activeStepIndex === 5">
                        <el-icon style="margin-right: 10px;">
                            <CircleCheckFilled />
                        </el-icon>
                        修改景点信息
                    </el-button>
                </div>
            </div>

            <!-- 内容卡片 -->
            <div class="content-card">
                <!-- 基本信息区域 -->
                <div class="form-section" v-if="activeStepIndex === 1">
                    <div class="form-group">
                        <label class="form-label">标题 <span class="required">*</span></label>
                        <el-input v-model="scenicSpotEditDTO.title" placeholder="请输入景点标题（100字以内）" maxlength="100"
                            show-word-limit size="large" class="form-input"></el-input>
                    </div>

                    <div class="form-group" style="margin-bottom: 20px;">
                        <label class="form-label">封面 <span class="required">*</span></label>
                        <div class="upload-cover-wrapper">
                            <div class="cover-preview" v-if="cover">
                                <img :src="cover" alt="封面预览" class="cover-img" />
                                <div @click="cover = ''" class="cover-remove-btn">
                                    <span>
                                        <el-icon>
                                            <delete />
                                        </el-icon>

                                    </span>
                                    <span>
                                        移除
                                    </span>
                                </div>

                            </div>
                            <el-upload class="cover-uploader" :action="uploadApi" :show-file-list="false"
                                :on-success="handleImageSuccess" :before-upload="beforeCoverUpload">
                                <el-button type="primary" round size="mini" class="upload-btn">
                                    <el-icon>
                                        <UploadFilled />
                                    </el-icon>
                                    {{ cover ? '更换封面' : '上传封面' }}
                                </el-button>
                                <div class="upload-tip">支持JPG/PNG格式，大小不超过2MB</div>
                            </el-upload>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">摘要 <span class="required">*</span></label>
                        <el-input type="textarea" :rows="4" placeholder="请输入景点摘要（200字以内）"
                            v-model="scenicSpotEditDTO.summary" maxlength="200" show-word-limit size="large"
                            class="form-textarea"></el-input>
                    </div>
                </div>

                <!-- 地区区域 -->
                <div class="form-section" v-if="activeStepIndex === 2">
                    <div class="region-group">
                        <div class="region-level">
                            <label class="form-label">县 <span class="required">*</span></label>
                            <el-radio-group v-model="regionProvinceId" @change="handleChangeProvince"
                                class="radio-group">
                                <el-radio v-for="region in regionList" :key="region.id" :value="region.id"
                                    class="radio-item">
                                    {{ region.name }}
                                </el-radio>
                            </el-radio-group>
                        </div>

                        <div class="region-level" v-if="childrenRegionList.length">
                            <label class="form-label">乡镇 <span class="required">*</span></label>
                            <el-radio-group v-model="scenicSpotEditDTO.regionId" class="radio-group">
                                <el-radio v-for="region in childrenRegionList" :key="region.id" :value="region.id"
                                    class="radio-item">
                                    {{ region.name }}
                                </el-radio>
                            </el-radio-group>
                        </div>

                        <div class="empty-tip" v-else>
                            <el-empty description="请先选择县"></el-empty>
                        </div>
                    </div>
                </div>

                <!-- 类别区域 -->
                <div class="form-section" v-if="activeStepIndex === 3">
                    <div class="category-group">
                        <div class="category-level">
                            <label class="form-label">一级类别 <span class="required">*</span></label>
                            <el-radio-group v-model="parentCategoryId" @change="handleChangeParentCategory"
                                class="radio-group">
                                <el-radio v-for="parentCategory in parentCategoryList" :key="parentCategory.id"
                                    :value="parentCategory.id" class="radio-item">
                                    {{ parentCategory.name }}
                                </el-radio>
                            </el-radio-group>
                        </div>

                        <div class="category-level" v-if="childrenCategoryList.length">
                            <label class="form-label">二级类别 <span class="required">*</span></label>
                            <el-radio-group v-model="childrenCategoryId" @change="handleChangeChildrenCategory"
                                class="radio-group">
                                <el-radio v-for="childrenCategory in childrenCategoryList" :key="childrenCategory.id"
                                    :value="childrenCategory.id" class="radio-item">
                                    {{ childrenCategory.name }}
                                </el-radio>
                            </el-radio-group>
                        </div>

                        <div class="category-level" v-if="childrenPlusCategoryList.length">
                            <label class="form-label">三级类别 <span class="required">*</span></label>
                            <el-radio-group v-model="childrenPlusCategoryId" class="radio-group">
                                <el-radio v-for="childrenPlusCategory in childrenPlusCategoryList"
                                    :key="childrenPlusCategory.id" :value="childrenPlusCategory.id" class="radio-item">
                                    {{ childrenPlusCategory.name }}
                                </el-radio>
                            </el-radio-group>
                        </div>

                        <div class="empty-tip" v-if="!parentCategoryId">
                            <el-empty description="请先选择一级类别"></el-empty>
                        </div>
                    </div>
                </div>

                <!-- 景点介绍区域 -->
                <div class="form-section" v-if="activeStepIndex === 4">
                    <label class="form-label">景点介绍 <span class="required">*</span></label>
                    <WangEditor v-show="activeStepIndex === 4 && contentWithImage" :receive-content="contentWithImage"
                        height="500px" :api="uploadApi" @on-listener="handleContentWithImageChange"
                        class="editor-wrapper" />
                </div>

                <!-- 景点图册区域 -->
                <div class="form-section album-section" v-if="activeStepIndex === 5">
                    <label class="form-label">景点图册 <span class="required">*</span></label>
                    <div class="album-upload-wrapper">
                        <el-upload :action="uploadApi" list-type="picture-card" :file-list="albumImages"
                            :on-success="handleAlbumImageSuccess" :before-upload="beforeAlbumUpload"
                            :on-remove="handleAlbumImageRemove" :on-preview="handleAlbumImagePreview" :limit="5"
                            class="album-uploader">
                            <div class="upload-card">
                                <el-icon size="24">
                                    <Plus />
                                </el-icon>
                                <p class="upload-text">上传图片</p>
                            </div>
                        </el-upload>
                        <div class="upload-tip">最多上传5张，支持JPG/PNG/GIF/WebP格式，单张不超过5MB</div>
                    </div>

                    <!-- 拖拽排序区域 -->
                    <div class="album-sort-wrapper" v-if="albumImages.length > 0">
                        <div class="sort-header">
                            <el-icon>
                                <Rank />
                            </el-icon>
                            <span class="sort-title">拖拽调整图片顺序</span>
                        </div>
                        <div class="sort-grid">
                            <div v-for="(image, index) in albumImages" :key="image.uid || `image-${index}`"
                                class="sort-item" draggable="true" @dragstart="handleDragStart($event, index)"
                                @dragover.prevent="handleDragOver($event, index)" @drop="handleDrop($event, index)"
                                @dragend="handleDragEnd">
                                <div class="image-card">
                                    <img :src="image.url" :alt="image.name" class="sort-img" />
                                    <div class="image-index">{{ index + 1 }}</div>
                                    <div class="image-actions">
                                        <el-button type="text" icon="View" @click="handleImagePreview(index)"
                                            class="action-btn preview-btn"></el-button>
                                        <el-button type="text" icon="Delete" @click="removeAlbumImage(index)"
                                            class="action-btn delete-btn"></el-button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- 图册预览区域 -->
        <el-image-viewer v-if="previewVisible" :url-list="previewUrlList" :initial-index="previewIndex"
            @close="closePreview" class="image-viewer" />
    </div>
</template>
<script setup lang="ts">
import { ref, reactive, computed, onMounted } from "vue"
import { ElMessage, ElMessageBox, ElNotification } from "element-plus"
import WangEditor from '@/components/Editor.vue'
import type { ScenicSpotQueryDTO, ScenicSpotEditDTO } from "@/types/scenic-spot"
import type { Region, RegionQueryDTO } from "@/types/region"
import type { Category, CategoryQueryDto } from "@/types/category"
import {
    Plus,
    Rank,
    Delete
} from '@element-plus/icons-vue'
import type { UploadFile } from 'element-plus'
import { updateScenicSpotApi, getDetailApi } from "@/api/scenic-spot-api"
import { queryListApi } from "@/api/region-api"
import { queryCategory } from "@/api/category-api"
import router from "@/router"

// 响应式数据
const scenicSpotQueryDTO = reactive<Partial<ScenicSpotQueryDTO>>({
    current: 1,
    size: 10,
    title: '',
    regionIds: []
})
const regionList = ref<Region[]>([])
const childrenRegionList = ref<Region[]>([])
const activeStepIndex = ref(1) // 默认步骤1
const scenicSpotEditDTO = reactive<Partial<ScenicSpotEditDTO>>({
    categoryIds: []
})
const cover = ref('')

const regionQueryDTO = reactive<RegionQueryDTO>({
    parentId: -1
})

const categoryQueryDTO = reactive<CategoryQueryDto>({
    parentId: -1
})

const steps = [
    { title: "步骤一：基本信息", icon: "Tickets" },
    { title: "步骤二：地区信息", icon: "LocationFilled" },
    { title: "步骤三：类别信息", icon: "Menu" },
    { title: "步骤四：景点介绍", icon: "Edit" },
    { title: "步骤五：景点图册", icon: "PictureFilled" }
];

const parentCategoryList = ref<Category[]>([])
const childrenCategoryList = ref<Category[]>([])
const childrenPlusCategoryList = ref<Category[]>([])

const scenicSpotId = ref<number | null>(null)

const regionProvinceId = ref(null) // 县ID

const parentCategoryId = ref(null) // 一级类别
const childrenCategoryId = ref(null) // 二级类别
const childrenPlusCategoryId = ref(null) // 三级类别

const uploadApi = ref('http://localhost:21090/api/v1.0/online-travel-api/file/upload')
const contentWithImage = ref('<p>介绍景点吧</p>')

// 获取景点ID
const getScenicSpotIdWithPath = () => {

    const queryId = router.currentRoute.value.query.scenicSpotId
    if (queryId) {
        scenicSpotId.value = Number(queryId)
    }
}

// 响应式 - 拖拽相关 
const albumImages = ref<UploadFile[]>([]) // 图册图片列表
const dragStartIndex = ref(-1) // 拖拽起始索引
const dragOverIndex = ref(-1) // 拖拽悬停索引

// 响应式 - 图片预览相关
const previewVisible = ref(false)
const previewUrlList = ref<string[]>([])
const previewIndex = ref(0)

// 计算属性
// 获取所有图片的URL列表
const allImageUrls = computed(() => {
    return albumImages.value.map(image => image.url || '').filter(url => url)
})

const queryRegionList = async () => {
    try {
        const { data } = await queryListApi(regionQueryDTO)
        regionList.value = data
    } catch (error: any) {
        ElMessage.error('查询地区信息异常：', error)
    }
}

// 查询一级类别
const queryParentCategoryList = async () => {
    try {
        const { data } = await queryCategory(categoryQueryDTO)
        parentCategoryList.value = data

        const parentCategory = findIntersectionById(
            parentCategoryList.value,
            scenicSpotEditDTO.scenicSpotCategoryList
        )

        // 设置顶级种类ID
        if (parentCategory.length > 0) {
            parentCategoryId.value = parentCategory[0].id
            await handleChangeParentCategory()
        }

    } catch (error: any) {
        ElMessage.error('查询父类别信息异常：', error)
    }
}

// 查询二级类别
const handleChangeParentCategory = async () => {
    try {
        const { data } = await queryCategory({
            parentId: Number(parentCategoryId.value)
        })
        childrenCategoryList.value = data

        const category = findIntersectionById(
            childrenCategoryList.value,
            scenicSpotEditDTO.scenicSpotCategoryList
        )

        // 设置二级种类ID
        if (category.length > 0) {
            childrenCategoryId.value = category[0].id
            await handleChangeChildrenCategory()
        }

    } catch (error: any) {
        ElMessage.error('查询二级类别信息异常：', error)
    }
}

// 查询三级类别
const handleChangeChildrenCategory = async () => {
    try {
        const { data } = await queryCategory({
            parentId: childrenCategoryId.value || undefined
        })
        childrenPlusCategoryList.value = data

        const category = findIntersectionById(
            childrenPlusCategoryList.value,
            scenicSpotEditDTO.scenicSpotCategoryList
        )

        // 设置三级种类ID
        if (category.length > 0) {
            childrenPlusCategoryId.value = category[0].id
        }

    } catch (error: any) {
        ElMessage.error('查询三级类别信息异常：', error)
    }
}



const handleChangeProvince = async () => {
    try {
        const { data } = await queryListApi({
            parentId: regionProvinceId.value
        })
        childrenRegionList.value = data
    } catch (error: any) {
        ElMessage.error('查询子地区信息异常：', error)
    }
}

const findIntersectionById = (categoryList: any, relationList: any) => {
    // 1. 边界校验：非数组直接返回空
    if (!Array.isArray(categoryList) || !Array.isArray(relationList)) {
        console.error('输入必须为数组');
        return [];
    }

    // 2. 提取关联数组中所有 categoryId，存入 Set（去重 + 快速查找）
    const relationIds = new Set(relationList.map(item => item.categoryId));

    // 3. 筛选类别数组中 id 在 relationIds 中的元素
    const intersection = categoryList.filter(category => relationIds.has(category.id));

    return intersection;
}


// ==================== 图片上传相关 ====================
/**
 * 上传前验证
 */
const beforeAlbumUpload = (file: File): boolean => {
    const MAX_SIZE = 5 * 1024 * 1024 // 5MB
    const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/webp']

    // 验证文件类型
    if (!ALLOWED_TYPES.includes(file.type)) {
        ElMessage.error('仅支持 JPG、PNG、GIF、WebP 格式的图片')
        return false
    }

    // 验证文件大小
    if (file.size > MAX_SIZE) {
        ElMessage.error('图片大小不能超过 5MB')
        return false
    }

    // 验证数量限制
    if (albumImages.value.length >= 20) {
        ElMessage.error('最多只能上传 20 张图片')
        return false
    }

    return true
}

/**
 * 图片上传成功处理
 */
const handleAlbumImageSuccess = (response: any, uploadFile: UploadFile): void => {
    if (response.code === 200) {
        // 确保有唯一的uid
        const imageData: UploadFile = {
            ...uploadFile,
            uid: uploadFile.uid || `image-${Date.now()}-${Math.random().toString(36).substr(2)}` as any,
            url: response.data,
            size: uploadFile.size,
            name: uploadFile.name || `图片_${albumImages.value.length + 1}`,
            status: 'success'
        }

        albumImages.value.push(imageData)
        ElMessage.success({
            message: '图片上传成功',
            duration: 1500
        })

        console.log('当前图册:', albumImages.value)
    } else {
        ElMessage.error(response.message || '图片上传失败')
    }
}

/**
 * Element Upload 组件的删除处理
 */
const handleAlbumImageRemove = (file: UploadFile): void => {
    const index = albumImages.value.findIndex(item => item.uid === file.uid)
    if (index !== -1) {
        albumImages.value.splice(index, 1)
        ElMessage.success('图片已移除')
    }
}

// ==================== 图片预览相关 ====================
/**
 * Element Upload 组件的预览处理
 */
const handleAlbumImagePreview = (file: UploadFile): void => {
    openPreviewByFile(file)
}

/**
 * 通过文件对象打开预览
 */
const openPreviewByFile = (file: UploadFile): void => {
    const index = albumImages.value.findIndex(item => item.uid === file.uid)
    if (index !== -1) {
        openPreview(index)
    }
}

/**
 * 通过索引打开预览
 */
const openPreview = (index: number): void => {
    if (index < 0 || index >= albumImages.value.length) return

    // 构建预览URL列表（过滤掉空URL）
    previewUrlList.value = albumImages.value
        .map(img => img.url || '')
        .filter(url => url.trim() !== '')

    // 计算预览索引（因为可能有空URL被过滤）
    const validImages = albumImages.value.filter(img => img.url)
    previewIndex.value = validImages.findIndex(img => img.uid === albumImages.value[index]?.uid)

    if (previewIndex.value === -1) {
        previewIndex.value = 0
    }

    previewVisible.value = true
}

/**
 * 关闭预览
 */
const closePreview = (): void => {
    previewVisible.value = false
    previewUrlList.value = []
    previewIndex.value = 0
}

// ==================== 拖拽排序相关 ====================
/**
 * 拖拽开始
 */
const handleDragStart = (event: DragEvent, index: number): void => {
    dragStartIndex.value = index

    // 设置拖拽数据
    if (event.dataTransfer) {
        event.dataTransfer.effectAllowed = 'move'
        event.dataTransfer.setData('text/plain', index.toString())
    }

    // 添加拖拽样式
    const target = event.target as HTMLElement
    target.classList.add('dragging')
}

/**
 * 拖拽悬停
 */
const handleDragOver = (event: DragEvent, index: number): void => {
    event.preventDefault()

    if (dragStartIndex.value === -1) return

    // 更新悬停索引
    if (dragOverIndex.value !== index) {
        dragOverIndex.value = index

        // 添加悬停样式
        const target = event.currentTarget as HTMLElement
        target.classList.add('drag-over')
    }
}

/**
 * 拖拽放下
 */
const handleDrop = (event: DragEvent, dropIndex: number): void => {
    event.preventDefault()

    if (dragStartIndex.value === -1 || dragStartIndex.value === dropIndex) {
        return
    }

    // 执行排序
    performSort(dragStartIndex.value, dropIndex)

    // 清理样式
    cleanupDragStyles()
}

/**
 * 拖拽结束
 */
const handleDragEnd = (): void => {
    cleanupDragStyles()
}

/**
 * 执行排序操作
 */
const performSort = (fromIndex: number, toIndex: number): void => {
    if (fromIndex === toIndex) return

    const images = [...albumImages.value]
    const [draggedItem] = images.splice(fromIndex, 1)
    images.splice(toIndex, 0, draggedItem as any)

    albumImages.value = images

    ElMessage.success({
        message: `已调整排序：第 ${fromIndex + 1} 张 → 第 ${toIndex + 1} 张`,
        duration: 1500
    })
}

/**
 * 清理拖拽相关样式
 */
const cleanupDragStyles = (): void => {
    // 移除所有拖拽相关样式
    document.querySelectorAll('.dragging, .drag-over').forEach(el => {
        el.classList.remove('dragging', 'drag-over')
    })

    // 重置索引
    dragStartIndex.value = -1
    dragOverIndex.value = -1
}

// ==================== 图片操作相关 ====================
/**
 * 删除图片（带确认）
 */
const removeAlbumImage = async (index: number): Promise<void> => {
    if (index < 0 || index >= albumImages.value.length) return

    const image = albumImages.value[index]
    const imageName = image?.name || `第 ${index + 1} 张图片`
    try {
        await ElMessageBox.confirm(
            `确定要删除"${imageName}"吗？`,
            '删除确认',
            {
                confirmButtonText: '确定删除',
                cancelButtonText: '取消',
                type: 'warning',
                center: true
            }
        )

        albumImages.value.splice(index, 1)
        ElMessage.success('图片已删除')

    } catch (error) {
        // 用户取消删除
        console.log('取消删除')
    }
}

/**
 * 图片预览处理
 */
const handleImagePreview = (index: number): void => {
    openPreview(index)
}

// ==================== 工具函数 ====================
/**
 * 格式化文件大小
 */
const formatFileSize = (bytes?: number): string => {
    if (!bytes) return '未知大小'

    const units = ['B', 'KB', 'MB', 'GB']
    let size = bytes
    let unitIndex = 0

    while (size >= 1024 && unitIndex < units.length - 1) {
        size /= 1024
        unitIndex++
    }

    return `${size.toFixed(unitIndex === 0 ? 0 : 1)} ${units[unitIndex]}`
}


const handleSearch = (keyword: string) => {
    scenicSpotQueryDTO.title = keyword
    scenicSpotQueryDTO.current = 1
}

const next = () => {
    if (activeStepIndex.value++ > 4) {
        activeStepIndex.value = 1
    }
}
const last = () => {
    if (activeStepIndex.value-- === 1) {
        activeStepIndex.value = 5
    }
}

const beforeCoverUpload = (file: File) => {
    const isJPGOrPNG = file.type === 'image/jpeg' || file.type === 'image/png'
    const isLt2M = file.size / 1024 / 1024 < 2

    if (!isJPGOrPNG) {
        ElMessage.error('头像只能是 JPG/PNG 格式!')
        return false
    }
    if (!isLt2M) {
        ElMessage.error('头像大小不能超过 2MB!')
        return false
    }
    return true
}

const handleImageSuccess = (response: any) => {
    if (response.code === 200) {
        cover.value = response.data
        ElMessage.success('封面上传成功')
    } else {
        ElMessage.error(response.message || '封面上传失败')
    }
}

const handleContentWithImageChange = (newContent: string) => {
    contentWithImage.value = newContent
}

// 景点新增
const editScenicSpot = async () => {
    // 参数校验，封装数据，发请求，根据请求结果做后续动作
    if (!scenicSpotEditDTO.title) {
        ElNotification.warning({
            title: '参数校验',
            message: '标题不为空',
            duration: 1500,
            position: 'bottom-right'
        })
        return;
    }
    if (!cover.value) {
        ElNotification.warning({
            title: '封面检验',
            message: '请上传封面',
            duration: 1500,
            position: 'bottom-right'
        })
        return;
    }
    if (!scenicSpotEditDTO.summary) {
        ElNotification.warning({
            title: '参数校验',
            message: '请补充摘要',
            duration: 1500,
            position: 'bottom-right'
        })
        return;
    }
    if (!contentWithImage.value) {
        ElNotification.warning({
            title: '参数校验',
            message: '请补充景点介绍',
            duration: 1500,
            position: 'bottom-right'
        })
        return;
    }
    if (!scenicSpotEditDTO.regionId) {
        ElNotification.warning({
            title: '参数校验',
            message: '请选中地区（子地区）',
            duration: 1500,
            position: 'bottom-right'
        })
        return;
    }
    if (!albumImages.value.length) {
        ElNotification.warning({
            title: '图册校验',
            message: '请上传图册',
            duration: 1500,
            position: 'bottom-right'
        })
        return;
    }
    // 限制最多只能传5张
    if (albumImages.value.length > 5) {
        ElNotification.warning({
            title: '图册校验',
            message: '图册至多5张',
            duration: 1500,
            position: 'bottom-right'
        })
        return;
    }
    // 封面
    scenicSpotEditDTO.cover = cover.value
    // 内容
    scenicSpotEditDTO.content = contentWithImage.value
    // 图册封装成指定的数据结构
    const scenicSpotBrochureList = albumImages.value.map((album, index) => {
        return {
            coverUrl: album.url || '',
            orderNumber: index + 1
        }
    })

    scenicSpotEditDTO.scenicSpotBrochureList = scenicSpotBrochureList

    // 设置类别关联数据
    // childrenPlusCategoryId - childrenCategoryId - parentCategoryId
    if (!scenicSpotEditDTO.categoryIds) {
        scenicSpotEditDTO.categoryIds = []
    }
    if (childrenPlusCategoryId.value) {
        scenicSpotEditDTO.categoryIds.push(childrenPlusCategoryId.value)
    }
    if (childrenCategoryId.value) {
        scenicSpotEditDTO.categoryIds.push(childrenCategoryId.value)
    }
    if (parentCategoryId.value) {
        scenicSpotEditDTO.categoryIds.push(parentCategoryId.value)
    }
    try {
        await updateScenicSpotApi(scenicSpotEditDTO as any)
        ElMessage.success('景点修改成功')
        router.go(-1) // 返回上一页
    } catch (error: any) {
        ElMessage.error('景点修改异常：', error.message)
    }

}

// 获取景点详情
const getScenicSpotDetail = async (id: number | null) => {
    if (!id) {
        console.error("景点ID为空")
        return
    }
    try {
        const { data } = await getDetailApi(id)
        Object.assign(scenicSpotEditDTO, data)
        // 设置封面
        cover.value = data.cover
        // 设置父级地区ID
        regionProvinceId.value = data.parentRegionId
        // 查询父地区
        await queryRegionList()
        // 查询子地区
        await handleChangeProvince()

        // 设置内容，确保有值
        contentWithImage.value = data.content?.trim() || '<p>介绍景点吧</p>'

        albumImages.value = (data.brochureList || []).map((brochure: any) => {
            return {
                ...brochure,
                uid: brochure.uid || `image-${Date.now()}-${Math.random().toString(36).substr(2)}` as any,
                url: brochure.coverUrl,
                size: brochure.size,
                name: brochure.name || `图片_${albumImages.value.length + 1}`,
                status: 'success'
            }
        })

        // 查询并设置类别 - 三级
        await queryParentCategoryList()


    } catch (error: any) {
        // console.error("查询景点详情异常：", error)
    }
}


onMounted(async () => {
    await getScenicSpotIdWithPath()
    if (scenicSpotId.value) {
        await getScenicSpotDetail(scenicSpotId.value)
    }
    if (!scenicSpotEditDTO) {
        await getScenicSpotDetail(scenicSpotId.value)
    }
})


</script>
<style lang="scss" scoped>
// 全局变量
$primary-color: #409eff;
$success-color: #67c23a;
$warning-color: #e6a23c;
$danger-color: #f56c6c;
$text-primary: #303133;
$text-regular: #606266;
$text-secondary: #909399;
$border-color: #e4e7ed;
$bg-color: #fff;
$transition-base: all 0.3s ease;

// 主容器
.scenic-spot-save-container {
    min-height: 100vh;
    background-color: $bg-color;
    padding: 0 20px;
}

// 页头
.page-header {
    padding: 10px 0;
    margin-bottom: 30px;

    .header-content {
        --el-page-header-text-color: $text-primary;

        .header-title {
            font-size: 20px;
            font-weight: 600;
            margin: 0;
        }
    }
}

// 主内容容器
.main-container {
    max-width: 1200px;
    margin: 0 auto;
    background: #fff;
    border-radius: 12px;
    overflow: hidden;
}

// 步骤条
.steps-wrapper {
    padding: 20px;
    background-color: rgb(250, 250, 250);
    border: 1px solid rgb(240, 240, 240);
    display: flex;
    justify-content: left;
    border-radius: 14px;
    gap: 30px;

    .steps-bar {
        --el-steps-finish-color: $primary-color;
        --el-steps-process-color: $primary-color;

        .step-item {
            margin-right: 30px;

            .el-step__title {
                font-size: 14px;
                margin-top: 8px;
            }

            .el-step__description {
                font-size: 12px;
            }
        }
    }
}

// 步骤定义（脚本未改，模板中循环展示）
$steps: (
    (title: "基本信息", icon: "UserFilled"),
    (title: "地区信息", icon: "LocationFilled"),
    (title: "类别信息", icon: "Menu"),
    (title: "景点介绍", icon: "Edit"),
    (title: "景点图册", icon: "PictureFilled")
);

// 内容卡片
.content-card {
    padding: 10px 0;
}

// 表单通用样式
.form-section {


    .form-label {
        display: block;
        font-size: 20px;
        color: #8d8e90;
        color: $text-primary;
        margin-bottom: 8px;

        .required {
            color: $danger-color;
            margin-left: 4px;
        }
    }

    .form-input,
    .form-textarea {
        --el-input-border-radius: 8px;
        --el-input-hover-border-color: $primary-color;
        // --el-input-focus-border-color: $primary-color;
        width: 100%;
        margin-bottom: 20px;
    }

    .empty-tip {
        padding: 40px 0;
        text-align: center;
    }
}

// 封面上传样式
.upload-cover-wrapper {
    display: flex;
    align-items: center;
    gap: 20px;

    .cover-preview {
        position: relative;
        width: 180px;
        height: 120px;
        border-radius: 8px;
        overflow: hidden;
        border: 1px dashed $border-color;

        .cover-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .cover-remove-btn {
            position: absolute;
            top: 8px;
            right: 8px;
            width: 68px;
            height: 28px;
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 20px;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            cursor: pointer;

            &:hover {
                background-color: rgba(0, 0, 0, 0.8);
            }
        }
    }

    .cover-uploader {
        flex: 1;

        .upload-btn {
            --el-button-border-radius: 8px;
            padding: 12px 24px;
        }

        .upload-tip {
            margin-top: 8px;
            font-size: 12px;
            margin-left: 20px;
            color: $text-secondary;
        }
    }
}

// 地区/类别选择样式
.region-group,
.category-group {

    .region-level,
    .category-level {
        margin-bottom: 24px;

        .radio-group {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;

            .radio-item {
                --el-radio-font-size: 14px;
                --el-radio-checked-color: $primary-color;
                padding: 8px 16px;
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

// 编辑器样式
.editor-wrapper {
    --el-editor-border-radius: 8px;
    border: 1px solid $border-color;
    border-radius: 8px;
    overflow: hidden;
}

// 图册区域样式
.album-section {
    .album-upload-wrapper {
        margin-bottom: 24px;

        .album-uploader {
            --el-upload-picture-card-width: 120px;
            --el-upload-picture-card-height: 120px;
            --el-upload-item-border-radius: 8px;

            .upload-card {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                // height: 100%;
                padding: 20px;
                border: 1px dashed $border-color;
                border-radius: 8px;
                cursor: pointer;
                transition: $transition-base;

                &:hover {
                    border-color: $primary-color;
                    background-color: rgba(64, 158, 255, 0.05);
                }

                .upload-text {
                    margin-top: 8px;
                    font-size: 12px;
                    color: $text-secondary;
                }
            }

            :deep(.el-upload-list__item) {
                overflow: hidden;
                border-radius: 8px;
            }
        }

        .upload-tip {
            margin-top: 8px;
            font-size: 12px;
            color: $text-secondary;
        }
    }

    .album-sort-wrapper {
        .sort-header {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
            font-size: 14px;
            font-weight: 500;
            color: $text-primary;
        }

        .sort-grid {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }

        .sort-item {
            width: 120px;
            height: 120px;
            cursor: grab;
            transition: $transition-base;

            &.dragging {
                opacity: 0.7;
                transform: scale(1.05);
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            }

            &.drag-over {
                border: 2px dashed $primary-color;
            }

            .image-card {
                position: relative;
                width: 100%;
                height: 100%;
                border-radius: 8px;
                overflow: hidden;
                border: 1px solid $border-color;

                .sort-img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .image-index {
                    position: absolute;
                    top: 4px;
                    left: 4px;
                    width: 20px;
                    height: 20px;
                    background: rgba(0, 0, 0, 0.5);
                    color: #fff;
                    font-size: 12px;
                    border-radius: 4px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .image-actions {
                    position: absolute;
                    bottom: 0;
                    left: 0;
                    right: 0;
                    display: flex;
                    justify-content: center;
                    gap: 8px;
                    padding: 4px;
                    background: linear-gradient(transparent, rgba(0, 0, 0, 0.6));
                    opacity: 0;
                    transition: $transition-base;

                    .action-btn {
                        width: 28px;
                        height: 28px;
                        padding: 0;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;

                        &.preview-btn {
                            --el-icon-color: #fff;
                        }

                        &.delete-btn {
                            --el-icon-color: #fff;
                        }
                    }
                }

                &:hover .image-actions {
                    opacity: 1;
                }
            }
        }
    }
}

// 操作按钮栏
.action-bar {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    padding: 20px 0;
    margin-top: 10px;

    .action-btn {
        --el-button-border-radius: 8px;
        padding: 12px 24px;
        font-size: 14px;
        font-weight: 500;
    }


}

// 图片预览器
.image-viewer {
    z-index: 9999;
}

:deep(.el-step__icon) {
    background: rgb(250, 250, 250);
}

// 响应式适配
@media (max-width: 768px) {
    .scenic-spot-save-container {
        padding: 0 10px;
    }

    .main-container {
        border-radius: 8px;
    }

    .steps-wrapper,
    .content-card,
    .action-bar {
        padding: 16px;
    }

    .upload-cover-wrapper {
        flex-direction: column;
        gap: 12px;

        .cover-preview {
            width: 100%;
            max-width: 200px;
        }
    }

    .region-group,
    .category-group {
        .radio-group {
            flex-direction: column;
            gap: 12px;

            .radio-item {
                width: 100%;
            }
        }
    }

    .album-section {
        .sort-grid {
            justify-content: center;
        }
    }

    .action-bar {
        flex-direction: column;
        gap: 12px;

        .action-right {
            width: 100%;
            justify-content: flex-end;
        }

        .action-btn {
            width: 100%;
            margin-left: 0 !important;
        }
    }
}
</style>