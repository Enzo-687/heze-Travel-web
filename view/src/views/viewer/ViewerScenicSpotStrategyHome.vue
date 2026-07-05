<template>
  <div class="strategy-page">
    <nav class="strategy-nav" :class="{ scrolled: isScrolled }">
      <div class="nav-inner">
        <div class="nav-back" @click="$router.push(isUserContext ? '/user/user-main' : '/viewer')">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
          </svg>
          <span>返回</span>
        </div>
        <div class="nav-title">景点攻略</div>
      </div>
    </nav>

    <section class="hero-section" v-if="!isUserContext">
      <div class="hero-bg">
        <div class="hero-gradient"></div>
        <div class="hero-particles">
          <span v-for="n in 10" :key="n" class="particle" :style="particleStyle(n)"></span>
        </div>
      </div>
      <div class="hero-content">
        <div class="hero-badge">HEZE TRAVEL</div>
        <h1 class="hero-title">菏泽景点攻略</h1>
        <p class="hero-desc">行走在千年古城，发现不一样的风景</p>
        <div class="hero-stat">
          <span class="stat-num">{{ totalPageCount }}</span>
          <span class="stat-label">篇攻略收录</span>
        </div>
      </div>
    </section>

    <section class="filter-section">
      <div class="filter-inner">
        <div class="search-box">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"/>
            <line x1="21" y1="21" x2="16.65" y2="16.65"/>
          </svg>
          <input
            v-model="scenicSpotStrategyQueryDTO.title"
            placeholder="搜索攻略标题..."
            @keyup.enter="handleSearch"
          />
          <div class="search-btn" @click="handleSearch">搜索</div>
        </div>
        <div class="date-filter">
          <el-date-picker
            v-model="dateRanges"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            size="default"
            style="max-width: 320px;"
            @change="handleDateChange"
          />
          <div class="reset-btn" @click="resetCondition" v-if="dateRanges.length || scenicSpotStrategyQueryDTO.title">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M1 4v6h6M23 20v-6h-6"/>
              <path d="M20.49 9A9 9 0 0 0 5.64 5.64L1 10m22 4l-4.64 4.36A9 9 0 0 1 3.51 15"/>
            </svg>
            <span>重置</span>
          </div>
        </div>
      </div>
    </section>

    <section class="strategy-section">
      <div class="strategy-inner">
        <div v-if="loading" class="loading-state">
          <div class="loading-spinner"></div>
          <span>加载中...</span>
        </div>

        <div v-else-if="!scenicSpotStrategyListVO.length" class="empty-state">
          <div class="empty-icon">📝</div>
          <div class="empty-text">暂无景点攻略数据</div>
          <div class="empty-hint">换个关键词试试？</div>
          <div class="empty-action" @click="resetCondition">重置筛选</div>
        </div>

        <div v-else class="strategy-grid">
          <div
            v-for="(item, index) in scenicSpotStrategyListVO"
            :key="`strategy-${item.id}`"
            class="strategy-card"
            @click="goDetail(item.id)"
          >
            <div class="card-cover">
              <img :src="item.cover" :alt="item.title" />
              <div class="cover-overlay">
                <span class="cover-index">{{ String(index + 1 + (scenicSpotStrategyQueryDTO.current - 1) * scenicSpotStrategyQueryDTO.size).padStart(2, '0') }}</span>
              </div>
            </div>
            <div class="card-body">
              <h3 class="card-title">{{ item.title }}</h3>
              <p class="card-desc">{{ item.summary }}</p>
              <div class="card-author">
                <img :src="item.avatar" class="author-avatar" />
                <span class="author-name">{{ item.username }}</span>
                <span class="card-date" v-if="item.createTime">{{ formatDate(item.createTime) }}</span>
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
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { handleDateRange } from '@/utils/date'
import type {
  ScenicSpotStrategyQueryDTO,
  ScenicSpotStrategyListVO
} from '@/types/scenic-spot-strategy'
import {
  queryAllScenciSpotStrategyByViewerApi
} from '@/api/viewer-api'

const router = useRouter()
const route = useRoute()
const loading = ref(false)
const isScrolled = ref(false)
const dateRanges = ref<Date[]>([])
const scenicSpotStrategyListVO = ref<ScenicSpotStrategyListVO[]>([])
const totalPageCount = ref<number>(0)

const scenicSpotStrategyQueryDTO = ref<ScenicSpotStrategyQueryDTO>({
  current: 1,
  size: 12,
  title: '',
  scenicSpotId: null
})

const isUserContext = computed(() => route.path.startsWith('/user/'))

const formatDate = (date: Date | string) => {
  const d = new Date(date)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

const particleStyle = (n: number) => {
  const x = Math.random() * 100
  const y = Math.random() * 100
  const size = 1.5 + Math.random() * 3
  const dur = 12 + Math.random() * 20
  const delay = Math.random() * 8
  return {
    left: `${x}%`,
    top: `${y}%`,
    width: `${size}px`,
    height: `${size}px`,
    animationDuration: `${dur}s`,
    animationDelay: `${delay}s`,
  }
}

const handleScroll = () => {
  isScrolled.value = window.scrollY > 60
}

const handleSearch = async () => {
  scenicSpotStrategyQueryDTO.value.current = 1
  await fetchScenicSpotStrategy()
}

const handleDateChange = async () => {
  const dates = handleDateRange(dateRanges.value)
  if (dates) {
    scenicSpotStrategyQueryDTO.value.startTime = dates.start
    scenicSpotStrategyQueryDTO.value.endTime = dates.end
  } else {
    scenicSpotStrategyQueryDTO.value.startTime = null
    scenicSpotStrategyQueryDTO.value.endTime = null
  }
  scenicSpotStrategyQueryDTO.value.current = 1
  await fetchScenicSpotStrategy()
}

const resetCondition = async () => {
  scenicSpotStrategyQueryDTO.value.title = ''
  scenicSpotStrategyQueryDTO.value.startTime = null
  scenicSpotStrategyQueryDTO.value.endTime = null
  scenicSpotStrategyQueryDTO.value.current = 1
  dateRanges.value = []
  await fetchScenicSpotStrategy()
}

const handleSizeChange = async (size: number) => {
  scenicSpotStrategyQueryDTO.value.size = size
  scenicSpotStrategyQueryDTO.value.current = 1
  await fetchScenicSpotStrategy()
}

const handleCurrentChange = async (current: number) => {
  scenicSpotStrategyQueryDTO.value.current = current
  await fetchScenicSpotStrategy()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const goDetail = (id: number | undefined) => {
  if (!id) return
  if (isUserContext.value) {
    router.push({ path: '/scenic-spot-strategy-detail', query: { scenicSpotStrategyId: String(id) } })
  } else {
    window.open(`/viewer-scenic-spot-strategy-detail?scenicSpotStrategyId=${id}`)
  }
}

const fetchScenicSpotStrategy = async () => {
  loading.value = true
  try {
    const { data, total } = await queryAllScenciSpotStrategyByViewerApi(scenicSpotStrategyQueryDTO.value)
    scenicSpotStrategyListVO.value = data
    totalPageCount.value = total
  } catch (error: any) {
    ElMessage.error('景点攻略查询异常')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  fetchScenicSpotStrategy()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style lang="scss" scoped>
.strategy-page {
  min-height: 100vh;
  background: #FAFAFA;
}

.strategy-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  height: 56px;
  background: transparent;
  transition: all 0.3s;

  &.scrolled {
    background: rgba(255, 255, 255, 0.92);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-bottom: 1px solid rgba(0, 0, 0, 0.06);
  }

  .nav-inner {
    max-width: 1200px;
    margin: 0 auto;
    height: 100%;
    display: flex;
    align-items: center;
    gap: 20px;
    padding: 0 40px;
  }

  .nav-back {
    display: flex;
    align-items: center;
    gap: 6px;
    color: rgba(255, 255, 255, 0.8);
    cursor: pointer;
    transition: color 0.3s;
    font-size: 14px;

    &:hover { color: white; }
  }

  &.scrolled .nav-back {
    color: var(--text-secondary);
    &:hover { color: var(--text-main); }
  }

  .nav-title {
    font-family: var(--font-serif);
    font-size: 16px;
    font-weight: 600;
    color: rgba(255, 255, 255, 0.9);
    letter-spacing: 2px;
  }

  &.scrolled .nav-title {
    color: var(--text-main);
  }
}

.hero-section {
  position: relative;
  height: 360px;
  overflow: hidden;

  .hero-bg {
    position: absolute;
    inset: 0;

    .hero-gradient {
      position: absolute;
      inset: 0;
      background: linear-gradient(135deg, #0A0A0A 0%, #1A0A0E 30%, #2A1018 60%, #0A0A0A 100%);
    }

    .hero-particles {
      position: absolute;
      inset: 0;

      .particle {
        position: absolute;
        border-radius: 50%;
        background: rgba(166, 27, 46, 0.2);
        animation: floatUp linear infinite;

        @keyframes floatUp {
          0%, 100% { transform: translateY(0) scale(1); opacity: 0; }
          5% { opacity: 0.6; }
          95% { opacity: 0.6; }
          50% { transform: translateY(-80px) scale(1.3); opacity: 0.3; }
        }
      }
    }
  }

  .hero-content {
    position: relative;
    z-index: 2;
    max-width: 1200px;
    margin: 0 auto;
    padding: 100px 40px 0;

    .hero-badge {
      display: inline-block;
      padding: 6px 16px;
      background: rgba(166, 27, 46, 0.2);
      border: 1px solid rgba(166, 27, 46, 0.4);
      border-radius: 100px;
      color: #E38995;
      font-size: 12px;
      font-weight: 600;
      letter-spacing: 4px;
      margin-bottom: 20px;
    }

    .hero-title {
      font-family: var(--font-serif);
      font-size: clamp(32px, 5vw, 48px);
      font-weight: 700;
      color: white;
      letter-spacing: 6px;
      margin-bottom: 12px;
    }

    .hero-desc {
      font-size: 16px;
      color: rgba(255, 255, 255, 0.4);
      letter-spacing: 4px;
      font-family: var(--font-serif);
      margin-bottom: 24px;
    }

    .hero-stat {
      display: inline-flex;
      align-items: baseline;
      gap: 6px;

      .stat-num {
        font-size: 36px;
        font-weight: 700;
        font-family: var(--font-serif);
        color: white;
      }

      .stat-label {
        font-size: 14px;
        color: rgba(255, 255, 255, 0.5);
        letter-spacing: 2px;
      }
    }
  }
}

.filter-section {
  padding: 32px 0;
  background: white;
  border-bottom: 1px solid rgba(0, 0, 0, 0.04);

  .filter-inner {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 40px;
  }

  .search-box {
    display: flex;
    align-items: center;
    gap: 0;
    background: white;
    border: 2px solid rgba(0, 0, 0, 0.1);
    border-radius: 100px;
    padding: 4px;
    margin-bottom: 16px;
    max-width: 480px;
    transition: all 0.3s;

    &:focus-within {
      border-color: var(--primary-color);
      box-shadow: 0 0 0 4px rgba(166, 27, 46, 0.08);
    }

    svg {
      margin-left: 16px;
      color: var(--text-light);
      flex-shrink: 0;
    }

    input {
      flex: 1;
      border: none;
      background: transparent;
      padding: 10px 12px;
      font-size: 14px;
      outline: none;
      color: var(--text-main);
      font-family: inherit;

      &::placeholder {
        color: var(--text-light);
      }
    }

    .search-btn {
      padding: 8px 24px;
      background: var(--primary-color);
      color: white;
      border-radius: 100px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
      letter-spacing: 1px;
      flex-shrink: 0;

      &:hover {
        background: var(--primary-light);
      }
    }
  }

  .date-filter {
    display: flex;
    align-items: center;
    gap: 16px;
    flex-wrap: wrap;

    .reset-btn {
      display: inline-flex;
      align-items: center;
      gap: 6px;
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

.strategy-section {
  padding: 40px 0 80px;

  .strategy-inner {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 40px;
  }
}

.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 80px 0;
  color: var(--text-light);
  font-size: 14px;

  .loading-spinner {
    width: 32px;
    height: 32px;
    border: 3px solid rgba(166, 27, 46, 0.15);
    border-top-color: var(--primary-color);
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
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
  gap: 24px;
}

.strategy-card {
  background: white;
  border: 1px solid rgba(0, 0, 0, 0.06);
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);

  &:hover {
    transform: translateY(-6px);
    box-shadow: 0 16px 48px rgba(0, 0, 0, 0.08);
    border-color: rgba(166, 27, 46, 0.15);

    .card-cover img {
      transform: scale(1.06);
    }

    .cover-overlay {
      opacity: 1;
    }
  }

  .card-cover {
    position: relative;
    height: 200px;
    overflow: hidden;

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.5s ease;
    }

    .cover-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(to top, rgba(0, 0, 0, 0.4) 0%, transparent 50%);
      opacity: 0;
      transition: opacity 0.3s;
      display: flex;
      align-items: flex-end;
      justify-content: flex-end;
      padding: 12px;

      .cover-index {
        font-size: 28px;
        font-weight: 800;
        font-family: var(--font-serif);
        color: rgba(255, 255, 255, 0.2);
        line-height: 1;
      }
    }
  }

  .card-body {
    padding: 18px;

    .card-title {
      font-family: var(--font-serif);
      font-size: 17px;
      font-weight: 600;
      color: var(--text-main);
      letter-spacing: 1px;
      margin-bottom: 8px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .card-desc {
      font-size: 13px;
      color: var(--text-light);
      line-height: 1.7;
      display: -webkit-box;
      -webkit-box-orient: vertical;
      -webkit-line-clamp: 2;
      overflow: hidden;
      text-overflow: ellipsis;
      margin-bottom: 14px;
      min-height: 44px;
    }

    .card-author {
      display: flex;
      align-items: center;
      gap: 8px;

      .author-avatar {
        width: 24px;
        height: 24px;
        border-radius: 50%;
        object-fit: cover;
        flex-shrink: 0;
      }

      .author-name {
        font-size: 13px;
        color: var(--text-secondary);
        font-weight: 500;
      }

      .card-date {
        font-size: 12px;
        color: var(--text-light);
        margin-left: auto;
      }
    }
  }
}

.pagination {
  display: flex;
  justify-content: center;
  padding: 48px 0 0;
}

@media (max-width: 1200px) {
  .strategy-grid { grid-template-columns: repeat(3, 1fr); }
}

@media (max-width: 900px) {
  .strategy-grid { grid-template-columns: repeat(2, 1fr); gap: 16px; }

  .hero-section { height: 280px; }

  .filter-section .filter-inner,
  .strategy-section .strategy-inner { padding: 0 20px; }

  .filter-section .search-box { max-width: 100%; }
}

@media (max-width: 600px) {
  .strategy-grid { grid-template-columns: 1fr; }

  .hero-section { height: 240px; }

  .strategy-nav .nav-inner { padding: 0 16px; }

  .filter-section .filter-inner,
  .strategy-section .strategy-inner { padding: 0 16px; }

  .strategy-card .card-cover { height: 180px; }
}
</style>
