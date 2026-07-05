<template>
  <div class="container">
    <div class="top-header">
      <div class="nav-left"></div>
      <div class="nav-right">
        <div>
          <Input placeholder="通过美食名称搜索，按Enter↙键" @listener="handleSearch" />
        </div>
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>
          添加美食
        </el-button>
      </div>
    </div>

    <div class="table-container">
      <el-table :data="foodList" stripe style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="ID" width="60" />
        <el-table-column label="封面" width="100">
          <template #default="{ row }">
            <img :src="row.coverUrl" style="width: 70px; height: 70px; object-fit: cover; border-radius: 6px;" />
          </template>
        </el-table-column>
        <el-table-column prop="name" label="美食名称" width="160" />
        <el-table-column prop="tag" label="标签" width="100">
          <template #default="{ row }">
            <el-tag type="danger" size="small">{{ row.tag }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="简介" show-overflow-tooltip />
        <el-table-column prop="address" label="地址" width="180" show-overflow-tooltip />
        <el-table-column label="经纬度" width="180">
          <template #default="{ row }">
            <span v-if="row.longitude && row.latitude">
              {{ row.longitude }}, {{ row.latitude }}
            </span>
            <span v-else style="color: #999;">未设置</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
          v-model:current-page="queryDto.current"
          v-model:page-size="queryDto.size"
          :page-sizes="[10, 20, 50]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>

    <el-dialog
      :title="isCreate ? '添加美食' : '编辑美食'"
      v-model="dialogVisible"
      width="650px"
      :close-on-click-modal="false"
    >
      <el-form :model="formData" label-width="100px" ref="formRef">
        <el-form-item label="美食名称" prop="name" :rules="[{ required: true, message: '请输入美食名称' }]">
          <el-input v-model="formData.name" placeholder="请输入美食名称" />
        </el-form-item>

        <el-form-item label="封面图">
          <div class="upload-area">
            <img v-if="formData.coverUrl" :src="formData.coverUrl" class="preview-img" />
            <el-upload
              action="http://localhost:21090/api/v1.0/online-travel-api/file/upload"
              :show-file-list="false"
              :on-success="handleUploadSuccess"
              :before-upload="beforeUpload"
            >
              <el-button type="primary" size="small">
                <el-icon><Upload /></el-icon>
                {{ formData.coverUrl ? '更换封面' : '上传封面' }}
              </el-button>
            </el-upload>
          </div>
        </el-form-item>

        <el-form-item label="特色标签">
          <el-select v-model="formData.tag" placeholder="请选择标签" style="width: 100%;">
            <el-option label="招牌必点" value="招牌必点" />
            <el-option label="本地特色" value="本地特色" />
            <el-option label="人气爆款" value="人气爆款" />
          </el-select>
        </el-form-item>

        <el-form-item label="简短介绍">
          <el-input v-model="formData.description" type="textarea" :rows="2" placeholder="1-2行介绍美食特点" />
        </el-form-item>

        <el-form-item label="详细介绍">
          <el-input v-model="formData.detail" type="textarea" :rows="4" placeholder="美食的详细介绍" />
        </el-form-item>

        <el-form-item label="地址">
          <el-input v-model="formData.address" placeholder="美食所在地址" />
        </el-form-item>

        <el-form-item label="经度">
          <el-input v-model.number="formData.longitude" placeholder="如 115.469" type="number" />
        </el-form-item>

        <el-form-item label="纬度">
          <el-input v-model.number="formData.latitude" placeholder="如 35.256" type="number" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">
          {{ isCreate ? '添加' : '保存' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance } from 'element-plus'
import { Plus, Upload } from '@element-plus/icons-vue'
import Input from '@/components/Input.vue'
import { queryFoodApi, saveFoodApi, updateFoodApi, delFoodApi } from '@/api/food-api'
import type { Food } from '@/types/food'

const loading = ref(false)
const dialogVisible = ref(false)
const submitLoading = ref(false)
const isCreate = ref(true)
const formRef = ref<FormInstance>()
const foodList = ref<Food[]>([])
const total = ref(0)

const queryDto = reactive({
  current: 1,
  size: 10,
  name: '' as string | null,
  tag: null as string | null,
})

const formData = reactive<Partial<Food>>({
  id: undefined,
  name: '',
  coverUrl: '',
  description: '',
  tag: '',
  detail: '',
  longitude: null,
  latitude: null,
  address: '',
})

const fetchData = async () => {
  loading.value = true
  try {
    const res = await queryFoodApi({
      current: queryDto.current,
      size: queryDto.size,
      name: queryDto.name,
      tag: queryDto.tag,
    })
    foodList.value = res.data || []
    total.value = res.total || 0
  } catch (e: any) {
    ElMessage.error(e.message || '获取数据失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = (keyword: string) => {
  queryDto.name = keyword
  queryDto.current = 1
  fetchData()
}

const handleAdd = () => {
  resetForm()
  isCreate.value = true
  dialogVisible.value = true
}

const handleEdit = (row: Food) => {
  resetForm()
  Object.assign(formData, row)
  isCreate.value = false
  dialogVisible.value = true
}

const handleDelete = async (row: Food) => {
  try {
    await ElMessageBox.confirm(`确定要删除美食"${row.name}"吗？`, '删除确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    })
    await delFoodApi(row.id)
    ElMessage.success('删除成功')
    fetchData()
  } catch {
    // cancelled
  }
}

const handleSubmit = async () => {
  if (!formRef.value) return
  try {
    await formRef.value.validate()
  } catch {
    ElMessage.warning('请完善表单')
    return
  }

  submitLoading.value = true
  try {
    if (isCreate.value) {
      await saveFoodApi(formData)
      ElMessage.success('添加成功')
    } else {
      await updateFoodApi(formData)
      ElMessage.success('修改成功')
    }
    dialogVisible.value = false
    fetchData()
  } catch (e: any) {
    ElMessage.warning(e.message || '操作失败')
  } finally {
    submitLoading.value = false
  }
}

const resetForm = () => {
  formRef.value?.clearValidate()
  Object.assign(formData, {
    id: undefined,
    name: '',
    coverUrl: '',
    description: '',
    tag: '',
    detail: '',
    longitude: null,
    latitude: null,
    address: '',
  })
}

const handleSizeChange = (size: number) => {
  queryDto.size = size
  queryDto.current = 1
  fetchData()
}

const handleCurrentChange = (page: number) => {
  queryDto.current = page
  fetchData()
}

const handleUploadSuccess = (response: any) => {
  if (response.code === 200) {
    formData.coverUrl = response.data
    ElMessage.success('封面上传成功')
  } else {
    ElMessage.error(response.message || '上传失败')
  }
}

const beforeUpload = (file: File) => {
  const isImage = file.type === 'image/jpeg' || file.type === 'image/png'
  const isLt20M = file.size / 1024 / 1024 < 20
  if (!isImage) {
    ElMessage.error('只能上传 JPG/PNG 格式')
    return false
  }
  if (!isLt20M) {
    ElMessage.error('图片大小不能超过 20MB')
    return false
  }
  return true
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped lang="scss">
.container {
  background: #fff;
  border-radius: 8px;
}

.top-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 0 26px 0;

  .nav-left,
  .nav-right {
    display: flex;
    align-items: center;
    gap: 12px;
  }
}

.pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
  padding: 16px 0;
}

.upload-area {
  display: flex;
  align-items: center;
  gap: 16px;

  .preview-img {
    width: 120px;
    height: 120px;
    object-fit: cover;
    border-radius: 8px;
    border: 1px solid #eee;
  }
}

:deep(.el-form-item) {
  margin-bottom: 20px;
}
</style>
