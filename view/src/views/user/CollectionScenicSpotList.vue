<template>
  <div class="spot-collection">
    <div class="filter-bar">
      <div class="search-box">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="11" cy="11" r="8"/>
          <line x1="21" y1="21" x2="16.65" y2="16.65"/>
        </svg>
        <input v-model="scenicSpotQueryDTO.title" placeholder="搜索景点名称..." @keyup.enter="searchScenicSpotList" />
      </div>
      <div class="filter-actions">
        <el-date-picker
          v-model="dateRanges"
          type="daterange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          size="small"
          style="max-width: 260px;"
          @change="handleDateChange"
        />
        <div class="reset-btn" @click="resetCondition" v-if="scenicSpotQueryDTO.title || dateRanges.length">
          重置
        </div>
      </div>
    </div>

    <div v-if="!scenicSpotListVOS.length" class="empty-state">
      <div class="empty-icon">📍</div>
      <div class="empty-text">暂无收藏景点</div>
      <div class="empty-hint">去景点页面逛逛，收藏感兴趣的景点吧</div>
    </div>

    <div v-else class="spot-grid">
      <div
        v-for="spot in scenicSpotListVOS"
        :key="spot.id"
        class="spot-card"
      >
        <div class="card-cover" @click="goDetail(spot.id)">
          <img :src="spot.cover" :alt="spot.title" />
          <div class="cover-overlay">
            <span class="cover-location">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/>
                <circle cx="12" cy="10" r="3"/>
              </svg>
              {{ spot.countyName }}·{{ spot.townName }}
            </span>
          </div>
        </div>
        <div class="card-body">
          <h4 class="card-title" @click="goDetail(spot.id)">{{ spot.title }}</h4>
          <p class="card-summary">{{ spot.summary }}</p>
          <div class="card-actions">
            <div class="action-view" @click="goDetail(spot.id)">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                <circle cx="12" cy="12" r="3"/>
              </svg>
              <span>查看</span>
            </div>
            <div class="action-uncollect" @click="cannelCollection(spot)">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
              </svg>
              <span>取消收藏</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="scenicSpotListVOS.length" class="pagination">
      <el-pagination
        v-model:current-page="scenicSpotQueryDTO.current"
        v-model:page-size="scenicSpotQueryDTO.size"
        :page-sizes="[8, 12, 24]"
        :total="totalPageCount"
        layout="total, sizes, prev, pager, next"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        background
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox, ElNotification } from 'element-plus'
import { useRouter } from 'vue-router'
import type { ScenicSpotListVO, ScenicSpotQueryDTO } from '@/types/scenic-spot'
import { queryUserCollectionApi } from '@/api/scenic-spot-api'
import type { UserActionOperation } from '@/types/user-action-operation'
import { collectionApi } from '@/api/user-action-operation-api'
import { handleDateRange } from '@/utils/date'

const emit = defineEmits(['countChange'])

const router = useRouter()
const scenicSpotQueryDTO = reactive<ScenicSpotQueryDTO>({
  current: 1,
  size: 8,
  title: '',
  regionIds: [],
  startTime: null,
  endTime: null
})

const dateRanges = ref<Date[]>([])
const scenicSpotListVOS = ref<ScenicSpotListVO[]>([])
const totalPageCount = ref<number>(0)
const contentModule = ref('SCENIC_SPOT')

const goDetail = (id: number) => {
  router.push({ path: '/user/user-scenic-spot-info', query: { scenicSpotId: String(id) } })
}

const searchScenicSpotList = async () => {
  scenicSpotQueryDTO.current = 1
  await fetchScenicSpot()
}

const handleDateChange = async () => {
  const dates = handleDateRange(dateRanges.value)
  if (dates) {
    scenicSpotQueryDTO.startTime = dates.start
    scenicSpotQueryDTO.endTime = dates.end
  } else {
    scenicSpotQueryDTO.startTime = null
    scenicSpotQueryDTO.endTime = null
  }
  scenicSpotQueryDTO.current = 1
  await fetchScenicSpot()
}

const resetCondition = async () => {
  scenicSpotQueryDTO.title = ''
  scenicSpotQueryDTO.regionIds = []
  scenicSpotQueryDTO.startTime = null
  scenicSpotQueryDTO.endTime = null
  scenicSpotQueryDTO.current = 1
  dateRanges.value = []
  await fetchScenicSpot()
}

const cannelCollection = async (spot: ScenicSpotListVO) => {
  try {
    const response = await ElMessageBox.confirm(
      `确定要取消收藏"【${spot.title}】"吗？`,
      '操作确认',
      { confirmButtonText: '确定取消收藏', cancelButtonText: '取消', type: 'warning', center: true }
    )
    if (response === 'confirm') {
      try {
        if (!spot.id) return
        const userActionOperation: UserActionOperation = {
          contentModule: contentModule.value,
          contentId: spot.id
        }
        await collectionApi(userActionOperation)
        await fetchScenicSpot()
        ElNotification.success({ title: '操作成功', message: '已取消收藏', duration: 1500 })
      } catch (error: any) {
        ElNotification.warning({ title: '操作异常', message: error, duration: 1500 })
      }
    }
  } catch (error) { }
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

const fetchScenicSpot = async () => {
  try {
    const { data, total } = await queryUserCollectionApi(scenicSpotQueryDTO)
    scenicSpotListVOS.value = data
    totalPageCount.value = total
    emit('countChange', total)
  } catch (error: any) {
    ElMessage.error('景点查询异常')
  }
}

onMounted(() => {
  fetchScenicSpot()
})
</script>

<style lang="scss" scoped>
.spot-collection {
  padding: 0;
}

.filter-bar {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
  flex-wrap: wrap;

  .search-box {
    display: flex;
    align-items: center;
    gap: 0;
    background: white;
    border: 2px solid rgba(0, 0, 0, 0.08);
    border-radius: 100px;
    padding: 4px 4px 4px 14px;
    max-width: 320px;
    transition: all 0.3s;

    &:focus-within {
      border-color: var(--primary-color);
      box-shadow: 0 0 0 3px rgba(166, 27, 46, 0.06);
    }

    svg { color: var(--text-light); flex-shrink: 0; }

    input {
      flex: 1;
      border: none;
      background: transparent;
      padding: 8px 10px;
      font-size: 14px;
      outline: none;
      color: var(--text-main);
      font-family: inherit;

      &::placeholder { color: var(--text-light); }
    }
  }

  .filter-actions {
    display: flex;
    align-items: center;
    gap: 12px;

    .reset-btn {
      padding: 6px 16px;
      border-radius: 100px;
      font-size: 13px;
      font-weight: 500;
      color: var(--text-secondary);
      background: #F5F5F5;
      cursor: pointer;
      transition: all 0.3s;

      &:hover {
        background: rgba(166, 27, 46, 0.06);
        color: var(--primary-color);
      }
    }
  }
}

.empty-state {
  text-align: center;
  padding: 80px 20px;

  .empty-icon { font-size: 48px; margin-bottom: 16px; }
  .empty-text { font-size: 16px; font-weight: 600; color: var(--text-main); margin-bottom: 8px; }
  .empty-hint { font-size: 14px; color: var(--text-light); }
}

.spot-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.spot-card {
  background: white;
  border: 1px solid rgba(0, 0, 0, 0.06);
  border-radius: 14px;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 36px rgba(0, 0, 0, 0.08);
    border-color: rgba(166, 27, 46, 0.12);

    .card-cover img { transform: scale(1.05); }
    .cover-overlay { opacity: 1; }
  }

  .card-cover {
    position: relative;
    height: 170px;
    overflow: hidden;
    cursor: pointer;

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.5s ease;
    }

    .cover-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(to top, rgba(0, 0, 0, 0.5) 0%, transparent 60%);
      opacity: 0;
      transition: opacity 0.3s;
      display: flex;
      align-items: flex-end;
      padding: 12px;

      .cover-location {
        display: flex;
        align-items: center;
        gap: 4px;
        font-size: 12px;
        color: rgba(255, 255, 255, 0.9);
        font-weight: 500;
      }
    }
  }

  .card-body {
    padding: 14px 16px 16px;

    .card-title {
      font-family: var(--font-serif);
      font-size: 16px;
      font-weight: 600;
      color: var(--text-main);
      letter-spacing: 0.5px;
      margin-bottom: 6px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      cursor: pointer;

      &:hover { color: var(--primary-color); }
    }

    .card-summary {
      font-size: 13px;
      color: var(--text-light);
      line-height: 1.6;
      display: -webkit-box;
      -webkit-box-orient: vertical;
      -webkit-line-clamp: 2;
      overflow: hidden;
      text-overflow: ellipsis;
      margin-bottom: 12px;
      min-height: 42px;
    }

    .card-actions {
      display: flex;
      align-items: center;
      gap: 12px;

      .action-view, .action-uncollect {
        display: flex;
        align-items: center;
        gap: 4px;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
      }

      .action-view {
        color: var(--primary-color);

        &:hover { opacity: 0.8; }
      }

      .action-uncollect {
        color: var(--text-light);
        margin-left: auto;

        &:hover { color: #E6A23C; }
      }
    }
  }
}

.pagination {
  display: flex;
  justify-content: center;
  padding: 36px 0 0;
}

@media (max-width: 1000px) {
  .spot-grid { grid-template-columns: repeat(3, 1fr); }
}

@media (max-width: 700px) {
  .spot-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
  .filter-bar { flex-direction: column; align-items: flex-start; }
  .filter-bar .search-box { max-width: 100%; }
}

@media (max-width: 500px) {
  .spot-grid { grid-template-columns: 1fr; }
}
</style>
