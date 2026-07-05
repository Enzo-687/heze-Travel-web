<template>
  <div class="strategy-collection">
    <div class="filter-bar">
      <div class="search-box">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="11" cy="11" r="8"/>
          <line x1="21" y1="21" x2="16.65" y2="16.65"/>
        </svg>
        <input v-model="scenicSpotStrategyQueryDTO.title" placeholder="搜索攻略标题..." @keyup.enter="searchScenicSpotStraegyList" />
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
        <div class="reset-btn" @click="resetCondition" v-if="scenicSpotStrategyQueryDTO.title || dateRanges.length">
          重置
        </div>
      </div>
    </div>

    <div v-if="!scenicSpotStrategyListVO.length" class="empty-state">
      <div class="empty-icon">📝</div>
      <div class="empty-text">暂无收藏攻略</div>
      <div class="empty-hint">去攻略页面逛逛，收藏感兴趣的攻略吧</div>
    </div>

    <div v-else class="strategy-grid">
      <div
        v-for="item in scenicSpotStrategyListVO"
        :key="item.id"
        class="strategy-card"
      >
        <div class="card-cover" @click="goDetail(item.id)">
          <img :src="item.cover" :alt="item.title" />
        </div>
        <div class="card-body">
          <h4 class="card-title" @click="goDetail(item.id)">{{ item.title }}</h4>
          <p class="card-summary">{{ item.summary }}</p>
          <div class="card-meta">
            <div class="meta-author">
              <img :src="item.avatar" class="author-avatar" />
              <span class="author-name">{{ item.username }}</span>
            </div>
            <div class="card-actions">
              <div class="action-view" @click="goDetail(item.id)">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                  <circle cx="12" cy="12" r="3"/>
                </svg>
              </div>
              <div class="action-uncollect" @click="cannelCollection(item)">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="scenicSpotStrategyListVO.length" class="pagination">
      <el-pagination
        v-model:current-page="scenicSpotStrategyQueryDTO.current"
        v-model:page-size="scenicSpotStrategyQueryDTO.size"
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox, ElNotification } from 'element-plus'
import { useRouter } from 'vue-router'
import { handleDateRange } from '@/utils/date'
import type {
  ScenicSpotStrategy,
  ScenicSpotStrategyQueryDTO,
  ScenicSpotStrategyListVO
} from '@/types/scenic-spot-strategy'
import type { UserActionOperation } from '@/types/user-action-operation'
import { queryUserCollectionApi } from '@/api/scenic-spot-strategy-api'
import { collectionApi } from '@/api/user-action-operation-api'

const emit = defineEmits(['countChange'])

const router = useRouter()
const scenicSpotStrategyQueryDTO = reactive<ScenicSpotStrategyQueryDTO>({
  current: 1,
  size: 8,
  title: '',
  scenicSpotId: null
})

const dateRanges = ref<Date[]>([])
const contentModule = ref('SCENIC_SPOT_STRATEGY')
const scenicSpotStrategyListVO = ref<ScenicSpotStrategyListVO[]>([])
const totalPageCount = ref<number>(0)

const goDetail = (id: number | undefined) => {
  if (!id) return
  router.push({ path: '/scenic-spot-strategy-detail', query: { scenicSpotStrategyId: String(id) } })
}

const searchScenicSpotStraegyList = async () => {
  scenicSpotStrategyQueryDTO.current = 1
  await fetchScenicSpotStrategy()
}

const handleDateChange = async () => {
  const dates = handleDateRange(dateRanges.value)
  if (dates) {
    scenicSpotStrategyQueryDTO.startTime = dates.start
    scenicSpotStrategyQueryDTO.endTime = dates.end
  } else {
    scenicSpotStrategyQueryDTO.startTime = null
    scenicSpotStrategyQueryDTO.endTime = null
  }
  scenicSpotStrategyQueryDTO.current = 1
  await fetchScenicSpotStrategy()
}

const resetCondition = async () => {
  scenicSpotStrategyQueryDTO.title = ''
  scenicSpotStrategyQueryDTO.startTime = null
  scenicSpotStrategyQueryDTO.endTime = null
  scenicSpotStrategyQueryDTO.current = 1
  dateRanges.value = []
  await fetchScenicSpotStrategy()
}

const cannelCollection = async (strategy: ScenicSpotStrategy) => {
  try {
    const response = await ElMessageBox.confirm(
      `确定要取消收藏"【${strategy.title}】"吗？`,
      '操作确认',
      { confirmButtonText: '确定取消收藏', cancelButtonText: '取消', type: 'warning', center: true }
    )
    if (response === 'confirm') {
      try {
        if (!strategy.id) return
        const userActionOperation: UserActionOperation = {
          contentModule: contentModule.value,
          contentId: strategy.id
        }
        await collectionApi(userActionOperation)
        await fetchScenicSpotStrategy()
        ElNotification.success({ title: '操作成功', message: '已取消收藏', duration: 1500 })
      } catch (error: any) {
        ElNotification.warning({ title: '操作异常', message: error, duration: 1500 })
      }
    }
  } catch (error) { }
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
    const { data, total } = await queryUserCollectionApi(scenicSpotStrategyQueryDTO)
    scenicSpotStrategyListVO.value = data
    totalPageCount.value = total
    emit('countChange', total)
  } catch (error: any) {
    ElMessage.error('攻略查询异常')
  }
}

onMounted(() => {
  fetchScenicSpotStrategy()
})
</script>

<style lang="scss" scoped>
.strategy-collection {
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

.strategy-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.strategy-card {
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

    .card-meta {
      display: flex;
      align-items: center;
      justify-content: space-between;

      .meta-author {
        display: flex;
        align-items: center;
        gap: 6px;

        .author-avatar {
          width: 22px;
          height: 22px;
          border-radius: 50%;
          object-fit: cover;
        }

        .author-name {
          font-size: 13px;
          color: var(--text-secondary);
          font-weight: 500;
        }
      }

      .card-actions {
        display: flex;
        align-items: center;
        gap: 8px;

        .action-view, .action-uncollect {
          display: flex;
          align-items: center;
          justify-content: center;
          width: 30px;
          height: 30px;
          border-radius: 50%;
          cursor: pointer;
          transition: all 0.2s;
        }

        .action-view {
          color: var(--primary-color);
          background: rgba(166, 27, 46, 0.06);

          &:hover { background: rgba(166, 27, 46, 0.12); }
        }

        .action-uncollect {
          color: var(--text-light);
          background: #F5F5F5;

          &:hover { color: #E6A23C; background: rgba(230, 162, 60, 0.08); }
        }
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
  .strategy-grid { grid-template-columns: repeat(3, 1fr); }
}

@media (max-width: 700px) {
  .strategy-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
  .filter-bar { flex-direction: column; align-items: flex-start; }
  .filter-bar .search-box { max-width: 100%; }
}

@media (max-width: 500px) {
  .strategy-grid { grid-template-columns: 1fr; }
}
</style>
