<template>
  <div class="content-center-page">
    <div class="content-container">
      <div class="page-header">
        <div class="header-left">
          <span class="section-badge">CONTENT</span>
          <h2 class="header-title">内容中心</h2>
          <p class="header-sub">管理你发布的攻略，随时编辑与回顾</p>
        </div>
        <div class="header-action" @click="handleAddScenicSpotStraegy">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
          </svg>
          发布新攻略
        </div>
      </div>

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
            @change="searchScenicSpotStraegyList"
          />
          <div class="search-btn" @click="searchScenicSpotStraegyList">搜索</div>
          <div class="reset-btn" @click="resetCondition" v-if="scenicSpotStrategyQueryDTO.title || dateRanges.length">
            重置
          </div>
        </div>
      </div>

      <div class="stats-strip">
        <div class="stat-item">
          <span class="stat-num">{{ totalPageCount }}</span>
          <span class="stat-label">篇攻略</span>
        </div>
        <div class="stat-divider"></div>
        <div class="stat-item">
          <span class="stat-num">{{ scenicSpotStrategyListVO.length }}</span>
          <span class="stat-label">当前页</span>
        </div>
      </div>

      <div v-if="!scenicSpotStrategyListVO.length" class="empty-state">
        <div class="empty-icon">📝</div>
        <div class="empty-text">暂无攻略数据</div>
        <div class="empty-hint">点击右上角发布你的第一篇攻略吧</div>
        <div class="empty-action" @click="handleAddScenicSpotStraegy">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
          </svg>
          发布攻略
        </div>
      </div>

      <div v-else class="strategy-grid">
        <div
          v-for="item in scenicSpotStrategyListVO"
          :key="item.id"
          class="strategy-card"
        >
          <div class="card-cover" @click="goDetail(item.id as any)">
            <img :src="item.cover" :alt="item.title" />
            <div class="cover-overlay">
              <span class="cover-date" v-if="item.createTime">{{ formatDate(item.createTime) }}</span>
            </div>
          </div>
          <div class="card-body">
            <h4 class="card-title" @click="goDetail(item.id as any)">{{ item.title }}</h4>
            <p class="card-summary">{{ item.summary }}</p>
            <div class="card-actions">
              <div class="action-view" @click="goDetail(item.id as any)">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                  <circle cx="12" cy="12" r="3"/>
                </svg>
                <span>查看</span>
              </div>
              <div class="action-edit" @click="goEdit(item.id as any)">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                </svg>
                <span>编辑</span>
              </div>
              <div class="action-delete" @click="delScenicSpotStraegy(item)">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <polyline points="3 6 5 6 21 6"/>
                  <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                </svg>
                <span>删除</span>
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
  </div>
</template>

<script setup lang="ts">
import { ElMessage, ElMessageBox, ElNotification } from "element-plus"
import { ref, reactive, onMounted } from "vue"
import { useRouter } from "vue-router"
import { handleDateRange } from "@/utils/date"
import type {
  ScenicSpotStrategy,
  ScenicSpotStrategyQueryDTO,
  ScenicSpotStrategyListVO
} from "@/types/scenic-spot-strategy"
import {
  queryScenciSpotStrategyApi,
  delScenciSpotStrategyApi
} from "@/api/scenic-spot-strategy-api"

const router = useRouter()
const scenicSpotStrategyQueryDTO = reactive<ScenicSpotStrategyQueryDTO>({
  current: 1,
  size: 12,
  title: '',
  scenicSpotId: null
})

const dateRanges = ref<Date[]>([])
const scenicSpotStrategyListVO = ref<ScenicSpotStrategyListVO[]>([])
const totalPageCount = ref<number>(0)

const formatDate = (date: Date | string) => {
  const d = new Date(date)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

const resetCondition = async () => {
  scenicSpotStrategyQueryDTO.title = ''
  scenicSpotStrategyQueryDTO.startTime = null
  scenicSpotStrategyQueryDTO.endTime = null
  scenicSpotStrategyQueryDTO.current = 1
  dateRanges.value = []
  await fetchScenicSpotStrategy()
}

const goDetail = (id: number) => {
  window.open(`/scenic-spot-strategy-detail?scenicSpotStrategyId=${id}`)
}

const goEdit = (id: number) => {
  window.open(`/scenic-spot-strategy-edit?scenicSpotStrategyId=${id}`)
}

const searchScenicSpotStraegyList = async () => {
  const dates = handleDateRange(dateRanges.value)
  if (dates) {
    scenicSpotStrategyQueryDTO.startTime = dates.start
    scenicSpotStrategyQueryDTO.endTime = dates.end
  }
  scenicSpotStrategyQueryDTO.current = 1
  await fetchScenicSpotStrategy()
}

const delScenicSpotStraegy = async (scenicSpotStategy: ScenicSpotStrategy) => {
  try {
    const response = await ElMessageBox.confirm(
      `确定要删除"【${scenicSpotStategy.title}】"吗？`,
      '删除确认',
      { confirmButtonText: '确定删除', cancelButtonText: '取消', type: 'warning', center: true }
    )
    if (response === 'confirm') {
      try {
        await delScenciSpotStrategyApi(scenicSpotStategy.id as any)
        await fetchScenicSpotStrategy()
        ElNotification.success({
          title: '景点攻略删除',
          message: `景点攻略【${scenicSpotStategy.title}】删除成功`,
          duration: 1500
        })
      } catch (error: any) {
        ElMessage.error(error)
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
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const fetchScenicSpotStrategy = async () => {
  try {
    const { data, total } = await queryScenciSpotStrategyApi(scenicSpotStrategyQueryDTO)
    scenicSpotStrategyListVO.value = data
    totalPageCount.value = total
  } catch (error: any) {
    ElMessage.error('景点攻略查询异常')
  }
}

const handleAddScenicSpotStraegy = () => {
  window.open('/scenic-spot-strategy-save')
}

onMounted(async () => {
  await fetchScenicSpotStrategy()
})
</script>

<style lang="scss" scoped>
.content-center-page {
  min-height: 100vh;
  background: #FAFAFA;
  padding: 32px 0 60px;
}

.content-container {
  max-width: 1100px;
  margin: 0 auto;
  padding: 0 24px;
}

.page-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 28px;

  .header-left {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .section-badge {
    display: inline-block;
    width: fit-content;
    padding: 4px 14px;
    background: rgba(166, 27, 46, 0.08);
    color: var(--primary-color);
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 3px;
    border-radius: 100px;
  }

  .header-title {
    font-family: var(--font-serif);
    font-size: 26px;
    font-weight: 700;
    color: var(--text-main);
    letter-spacing: 2px;
  }

  .header-sub {
    font-size: 14px;
    color: var(--text-light);
    letter-spacing: 1px;
  }

  .header-action {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 24px;
    background: var(--primary-color);
    color: white;
    border-radius: 100px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;
    box-shadow: 0 4px 16px rgba(166, 27, 46, 0.25);
    white-space: nowrap;
    margin-top: 24px;

    &:hover {
      background: var(--primary-light);
      transform: translateY(-1px);
      box-shadow: 0 6px 20px rgba(166, 27, 46, 0.3);
    }
  }
}

.filter-bar {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 20px;
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

    .search-btn {
      padding: 8px 20px;
      background: var(--primary-color);
      color: white;
      border-radius: 100px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;

      &:hover { background: var(--primary-light); }
    }

    .reset-btn {
      padding: 8px 18px;
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

.stats-strip {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 24px;
  padding: 16px 24px;
  background: white;
  border: 1px solid rgba(0, 0, 0, 0.06);
  border-radius: 12px;

  .stat-item {
    display: flex;
    align-items: baseline;
    gap: 6px;

    .stat-num {
      font-size: 24px;
      font-weight: 700;
      font-family: var(--font-serif);
      color: var(--text-main);
    }

    .stat-label {
      font-size: 13px;
      color: var(--text-light);
    }
  }

  .stat-divider {
    width: 1px;
    height: 20px;
    background: #ECEEF0;
  }
}

.empty-state {
  text-align: center;
  padding: 80px 20px;

  .empty-icon { font-size: 48px; margin-bottom: 16px; }
  .empty-text { font-size: 16px; font-weight: 600; color: var(--text-main); margin-bottom: 8px; }
  .empty-hint { font-size: 14px; color: var(--text-light); margin-bottom: 24px; }

  .empty-action {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 10px 28px;
    background: var(--primary-color);
    color: white;
    border-radius: 100px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;

    &:hover {
      background: var(--primary-light);
      transform: translateY(-1px);
    }
  }
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

      .cover-date {
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
      margin-bottom: 14px;
      min-height: 42px;
    }

    .card-actions {
      display: flex;
      align-items: center;
      gap: 4px;

      .action-view, .action-edit, .action-delete {
        display: flex;
        align-items: center;
        gap: 4px;
        padding: 6px 12px;
        border-radius: 100px;
        font-size: 12px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
      }

      .action-view {
        color: var(--primary-color);
        background: rgba(166, 27, 46, 0.06);

        &:hover { background: rgba(166, 27, 46, 0.12); }
      }

      .action-edit {
        color: var(--text-secondary);
        background: #F5F5F5;

        &:hover { color: #409EFF; background: rgba(64, 158, 255, 0.06); }
      }

      .action-delete {
        color: var(--text-secondary);
        background: #F5F5F5;
        margin-left: auto;

        &:hover { color: #F56C6C; background: rgba(245, 108, 108, 0.06); }
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
  .page-header { flex-direction: column; gap: 16px; }
  .page-header .header-action { margin-top: 0; }
}

@media (max-width: 500px) {
  .strategy-grid { grid-template-columns: 1fr; }
}
</style>
