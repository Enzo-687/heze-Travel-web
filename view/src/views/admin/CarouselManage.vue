<template>
    <div class="container">
        <div class="top-header">
            <div class="nav-left">

            </div>
            <div class="nav-right">
                <div>
                    <Input placeholder="通过推介语搜轮播图，按Enter↩︎键" @listener="handleSearch" />
                </div>
                <el-button type="primary" @click="handleAddCarousel">
                    <el-icon>
                        <Plus />
                    </el-icon>
                    添加轮播图
                </el-button>
            </div>
        </div>

        <!-- 表格区域 -->
        <div class="table-container">
            <div class="carousel-list-container">

                <div class="carousel-item" :key="`carousel-item-${carousel.id}`" v-for="carousel in carouselList">
                    <img class="cover" :src="carousel.coverUrl" alt="" srcset="">
                    <div class="btn-group">
                        <div class="block" @click="goDetail(carousel.scenicSpotId)">
                            <el-icon>
                                <View />
                            </el-icon>
                            查看详情
                        </div>
                        <div class="block" @click="handleEdit(carousel)">
                            <el-icon>
                                <Edit />
                            </el-icon>
                            修改
                        </div>
                        <div class="block" @click="delCarousel(carousel)">
                            <el-icon>
                                <Delete />
                            </el-icon>
                            删除
                        </div>
                    </div>
                    <div class="summary">
                        <div class="title">{{ carousel.title }}</div>
                        <div class="detail">{{ carousel.recommendDetail }}</div>
                    </div>
                </div>
            </div>

            <!-- 分页组件 -->
            <div class="pagination">
                <el-pagination v-model:current-page="carouselQueryDto.current" v-model:page-size="carouselQueryDto.size"
                    :page-sizes="[10, 20, 50, 100]" :total="total" layout="total, sizes, prev, pager, next, jumper"
                    @size-change="handleSizeChange" @current-change="handleCurrentChange" />
            </div>
        </div>

        <!-- 轮播图信息操作弹窗 -->
        <el-dialog :title="isCreateModel ? '添加轮播图' : '修改轮播图信息'" v-model="dialogVisible" width="600px"
            :close-on-click-modal="false">

            <div>
                <el-form :model="carousel" label-width="120px" :rules="currentFormRules" ref="formRef">
                    <el-form-item label="推介封面">
                        <div class="avatar-upload-container">
                            <div>
                                <img class="cover" v-if="cover" :src="cover" alt="">
                                <div class="tip" v-if="cover">为显示最优效果，请上传比例3:1的推荐封面</div>
                            </div>

                            <el-upload class="avatar-uploader"
                                action="http://localhost:21090/api/v1.0/online-travel-api/file/upload"
                                :show-file-list="false" :on-success="handleImageSuccess"
                                :before-upload="beforeCoverUpload">
                                <el-button type="primary" size="small">
                                    <el-icon>
                                        <Upload />
                                    </el-icon>
                                    {{ cover ? '更换推荐封面' : '上传推荐封面' }}
                                </el-button>
                            </el-upload>
                        </div>
                    </el-form-item>

                    <el-form-item label="标题" prop="title">
                        <el-input style="width: 90%;" v-model="carousel.title" placeholder="推介标题" />
                    </el-form-item>

                    <el-form-item label="推介语" prop="recommendDetail">
                        <el-input style="width: 90%;" type="textarea" :rows="3" placeholder="请输入推介语（100字以内）"
                            v-model="carousel.recommendDetail" />
                    </el-form-item>

                    <el-form-item style="width: 100%;" label="关联景点" prop="scenicSpotId">
                        <div>
                            <div class="scenic-spot-link" v-if="!isCreateModel">当前关联：景点ID【{{ carousel.scenicSpotId }}】 -
                                {{ carousel.scenicSpotTitle }}</div>
                            <el-autocomplete style="width: 400px;" v-model="searchKey"
                                :fetch-suggestions="querySearchAsync" placeholder="请输入内容"
                                @select="handleSelect"></el-autocomplete>
                        </div>

                    </el-form-item>
                </el-form>
            </div>

            <template #footer>
                <el-button @click="handleCancel">取消</el-button>
                <el-button type="primary" @click="handleConfirm" :loading="confirmLoading">
                    {{ isCreateModel ? '新增' : '修改' }}
                </el-button>
            </template>
        </el-dialog>

    </div>
</template>

<script setup lang="ts">
import { ElMessage, ElNotification, type FormInstance, type FormRules, ElMessageBox } from 'element-plus'
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { Plus, Edit, Delete, Upload } from '@element-plus/icons-vue'
import Input from '@/components/Input.vue'
import type { Carousel, CarouselQueryDto } from '@/types/carousel'
import {
    addCarouselApi,
    queryCarouselApi,
    updateCarouselApi,
    delCarouselApi
} from '@/api/carousel-api'
import {
    queryScenicSpotApi
} from '@/api/scenic-spot-api'

// 响应式数据
const loading = ref(false)
const dialogVisible = ref(false)
const confirmLoading = ref(false)
const isCreateModel = ref(true)
const cover = ref('')
const formRef = ref<FormInstance>()

const carouselList = ref<Carousel[]>([])
const total = ref(0)
const searchKey = ref('')

const router = useRouter()

const carouselQueryDto = reactive<CarouselQueryDto>({
    current: 1,
    size: 10,
    scenicSpotId: null,
    title: ''
})

const carousel = reactive<Partial<Carousel>>({})

// 表单验证规则
const formRules = reactive<FormRules>({
    account: [
        { required: true, message: '请输入账号', trigger: 'blur' },
        { min: 3, max: 20, message: '账号长度在 3-20 个字符', trigger: 'blur' }
    ],
    username: [
        { required: true, message: '请输入昵称', trigger: 'blur' },
        { min: 2, max: 20, message: '昵称长度在 2-20 个字符', trigger: 'blur' }
    ],
    password: [
        { required: true, message: '请输入密码', trigger: 'blur' },
        { min: 6, message: '密码长度至少6位', trigger: 'blur' }
    ]
})

// 动态表单验证规则
const currentFormRules = computed(() => {
    if (isCreateModel.value) {
        return formRules
    }
    const { password, ...otherRules } = formRules
    return otherRules
})

// 生命周期
onMounted(() => {
    fetchCarouselData()
})

// 跳转详情页
const goDetail = (id: number) => {
    router.push(`/admin/scenic-spot-detail?scenicSpotId=${id}`);
}

const delCarousel = async (carousel: Carousel) => {
    try {
        const response = await ElMessageBox.confirm(
            `确定要删除"轮播图【${carousel.title}】"吗？`,
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
                // 删除轮播图数据
                await delCarouselApi(carousel.id)
                // 加载景点列表
                await fetchCarouselData()
                ElNotification.success({
                    title: '景点删除',
                    message: `景点【${carousel.title}】删除成功`,
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

const querySearchAsync = async (queryString: string, cb: any) => {
    try {
        const { data } = await queryScenicSpotApi({
            title: queryString,
            current: 1,
            size: 100
        } as any)
        const suggestions = (data || []).map((item: any) => ({
            value: item.title,  // 显示的值
            id: item.id,        // 保留原始ID
            ...item             // 保留其他属性
        }))
        cb(suggestions)
    } catch (error) {
        console.log("查询景点数据异常");
    }
}

const handleSelect = (item: any) => {
    carousel.scenicSpotId = item.id
    carousel.scenicSpotTitle = item.value
}

// 查询轮播图列表
const fetchCarouselData = async () => {
    loading.value = true
    try {
        const response = await queryCarouselApi(carouselQueryDto)
        carouselList.value = response.data
        total.value = response.total || 0
    } catch (error: any) {
        ElMessage.error(error.message || '获取轮播图数据失败')
    } finally {
        loading.value = false
    }
}


const handleSearch = (keyword: string) => {
    carouselQueryDto.title = keyword
    carouselQueryDto.current = 1
    fetchCarouselData()
}

const handleAddCarousel = () => {
    resetForm()
    isCreateModel.value = true
    dialogVisible.value = true
}

const handleEdit = (item: Carousel) => {
    resetForm()
    Object.assign(carousel, item)
    cover.value = item.coverUrl || ''
    isCreateModel.value = false
    dialogVisible.value = true
}


const handleConfirm = async () => {
    if (!formRef.value) return

    try {
        await formRef.value.validate()
    } catch {
        ElMessage.warning('请完善表单信息')
        return
    }

    confirmLoading.value = true
    try {
        const submitData = { ...carousel }
        submitData.coverUrl = cover.value

        if (isCreateModel.value) {
            try {
                await addCarouselApi(submitData as any)
                ElMessage.success('添加轮播图成功')
                handleCancel()
                fetchCarouselData()
            } catch (error: any) {
                ElMessage.warning(error.message)
                console.log("添加轮播图异常：", error);
            }

        } else {
            try {
                await updateCarouselApi(submitData as any)
                ElMessage.success('修改轮播图成功')
                handleCancel()
                fetchCarouselData()
            } catch (error: any) {
                ElMessage.warning(error.message)
                console.log("修改轮播图异常：", error);
            }
        }

    } catch (error: any) {
        ElMessage.error(error.message || '操作失败')
    } finally {
        confirmLoading.value = false
    }
}

const handleCancel = () => {
    dialogVisible.value = false
    resetForm()
}

const resetForm = () => {
    formRef.value?.clearValidate()
    Object.assign(carousel, {
        id: null,
        scenicSpotId: null,
        coverUrl: '',
        title: '',
        recommendDetail: ''
    })
    Object.assign(carouselQueryDto, {
        current: 1,
        size: 10,
        scenicSpotId: null,
        title: ''
    })
    cover.value = ''
}

const handleSizeChange = (size: number) => {
    carouselQueryDto.size = size
    carouselQueryDto.current = 1
    fetchCarouselData()
}

const handleCurrentChange = (current: number) => {
    carouselQueryDto.current = current
    fetchCarouselData()
}

const handleImageSuccess = (response: any) => {
    if (response.code === 200) {
        cover.value = response.data
        ElMessage.success('推荐封面上传成功')
    } else {
        ElMessage.error(response.message || '推荐封面上传失败')
    }
}

const beforeCoverUpload = (file: File) => {
    const isJPGOrPNG = file.type === 'image/jpeg' || file.type === 'image/png'
    const isLt2M = file.size / 1024 / 1024 < 20

    if (!isJPGOrPNG) {
        ElMessage.error('封面只能是 JPG/PNG 格式!')
        return false
    }
    if (!isLt2M) {
        ElMessage.error('封面大小不能超过 20MB!')
        return false
    }
    return true
}
</script>

<style scoped lang="scss">
.scenic-spot-link {
    border: 1px solid rgb(230, 230, 230);
    background-color: rgb(244, 244, 244);
    user-select: none;
    padding: 2px 10px;
    border-radius: 4px;
    margin-bottom: 6px;
}

.carousel-list-container {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-gap: 20px;

    .carousel-item {
        // 父相子绝
        position: relative;

        padding: 4px;
        box-sizing: border-box;
        cursor: pointer;
        transition: all 0.5s ease;
        border-radius: 10px;

        &:hover {
            box-shadow: 0 4px 6px rgb(240, 240, 240);
        }

        .cover {
            width: 100%;
            object-fit: fill;
            aspect-ratio: 3/1;
            border-radius: 10px;
            cursor: pointer;
            transition: all .5s ease;

            &:hover {
                scale: 1.02;
            }
        }

        .btn-group {
            position: absolute;
            right: 30px;
            top: 30px;
            width: 100%;
            display: flex;
            gap: 20px;
            width: auto;
            justify-content: flex-end;
            background-color: rgba(0, 0, 0, 0.7);
            padding: 12px 20px;
            border-radius: 20px;

            .block {
                color: rgb(255, 255, 255);
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 4px;

                &:hover {
                    text-decoration: underline;
                }
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
            padding: 30px;
            box-sizing: border-box;
            font-size: 14px;

            /* 核心：三行省略关键属性 */
            display: -webkit-box;
            /* 弹性盒模型 */
            -webkit-box-orient: vertical;
            /* 垂直排列 */
            // -webkit-line-clamp: 2;
            /* 限制显示行数 */
            overflow: hidden;
            /* 超出部分隐藏 */
            text-overflow: ellipsis;
            /* 省略号效果（兼容兜底） */
            /* 可选：增加行高，提升可读性 */
            line-height: 1.7;
            /* 防止绝对定位元素被遮挡 */
            // z-index: 10;

            .title {
                font-size: 26px;
                font-weight: 600;
                color: rgb(255, 255, 255);
            }
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

.cover {
    width: 250px;
    aspect-ratio: 3/1;
}

.tip {
    font-size: 12px;
    color: #909399;
}


.container {
    background: #fff;
    border-radius: 8px;
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

.table-container {
    .user-info {
        display: flex;
        align-items: center;
        gap: 8px;

        .username {
            font-weight: 500;
        }
    }

    .text-ellipsis {
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
}

.pagination {
    display: flex;
    justify-content: flex-end;
    margin-top: 20px;
    padding: 16px 0;
}

.avatar-upload-container {
    display: flex;
    align-items: center;
    gap: 16px;
}

.tip-text {
    font-size: 12px;
    color: #909399;
    margin-top: 4px;
}

:deep(.el-tabs__content) {
    padding: 0 16px;
}

:deep(.el-table .cell) {
    padding: 0 6px !important;
}

:deep(.el-form-item) {
    margin-bottom: 20px;
}
</style>