<template>
  <div class="spot-page">
    <section class="hero-section">
      <div class="hero-bg">
        <div class="hero-gradient"></div>
        <div class="hero-particles">
          <span v-for="n in 10" :key="n" class="particle" :style="particleStyle(n)"></span>
        </div>
      </div>
      <div class="hero-content">
        <div class="hero-badge">HEZE TRAVEL</div>
        <h1 class="hero-title">菏泽景点</h1>
        <p class="hero-desc">千年古城，牡丹之都，发现每一处风景</p>
        <div class="hero-stat">
          <span class="stat-num">{{ totalPageCount }}</span>
          <span class="stat-label">处景点收录</span>
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
          <input v-model="scenicSpotQueryDTO.title" placeholder="搜索景点名称..." @keyup.enter="searchScenicSpotList" />
          <div class="search-btn" @click="searchScenicSpotList">搜索</div>
        </div>

        <div class="theme-filter">
          <span class="filter-label">四色菏泽</span>
          <div class="theme-chips">
            <div class="theme-chip" :class="{ active: !activeTheme }" @click="selectTheme(null)">
              <span class="chip-dot all"></span>全部
            </div>
            <div v-for="theme in themes" :key="theme.key" class="theme-chip"
              :class="{ active: activeTheme === theme.key }" @click="selectTheme(theme.key)">
              <span class="chip-dot" :style="{ background: theme.color }"></span>{{ theme.name }}
            </div>
          </div>
        </div>

        <div class="region-filter" v-if="countyList.length">
          <span class="filter-label">区县</span>
          <div class="region-chips">
            <div class="chip" :class="{ active: !selectedCountyId }" @click="selectCounty(null)">全部</div>
            <div v-for="county in countyList" :key="county.id" class="chip"
              :class="{ active: selectedCountyId === county.id }" @click="selectCounty(county.id)">
              {{ county.name }}
            </div>
          </div>
        </div>

        <div class="region-filter sub" v-if="townList.length">
          <span class="filter-label">乡镇</span>
          <div class="region-chips">
            <div class="chip" :class="{ active: !selectedTownId }" @click="selectTown(null)">全部</div>
            <div v-for="town in townList" :key="town.id" class="chip"
              :class="{ active: selectedTownId === town.id }" @click="selectTown(town.id)">
              {{ town.name }}
            </div>
          </div>
        </div>

        <div class="region-filter sub" v-if="villageList.length">
          <span class="filter-label">村</span>
          <div class="region-chips">
            <div class="chip" :class="{ active: !selectedVillageId }" @click="selectVillage(null)">全部</div>
            <div v-for="village in villageList" :key="village.id" class="chip"
              :class="{ active: selectedVillageId === village.id }" @click="selectVillage(village.id)">
              {{ village.name }}
            </div>
          </div>
        </div>

        <div class="filter-actions" v-if="scenicSpotQueryDTO.title || scenicSpotQueryDTO.categoryKey || selectedCountyId">
          <div class="reset-btn" @click="resetCondition">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M1 4v6h6M23 20v-6h-6"/>
              <path d="M20.49 9A9 9 0 0 0 5.64 5.64L1 10m22 4l-4.64 4.36A9 9 0 0 1 3.51 15"/>
            </svg>
            重置筛选
          </div>
        </div>
      </div>
    </section>

    <section class="spot-section">
      <div class="spot-inner">
        <div v-if="!scenicSpotListVOS.length" class="empty-state">
          <div class="empty-icon">📍</div>
          <div class="empty-text">暂无景点数据</div>
          <div class="empty-hint">换个关键词试试？</div>
          <div class="empty-action" @click="resetCondition">重置筛选</div>
        </div>

        <div v-else class="spot-grid">
          <div v-for="spot in scenicSpotListVOS" :key="spot.id" class="spot-card" @click="goDetail(spot.id)">
            <div class="card-cover">
              <img :src="spot.cover" :alt="spot.title" />
              <div class="cover-badges">
                <span class="badge-region" v-if="spot.countyName">
                  <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/>
                  </svg>
                  {{ spot.countyName }}
                </span>
              </div>
            </div>
            <div class="card-body">
              <h4 class="card-title">{{ spot.title }}</h4>
              <p class="card-summary">{{ spot.summary }}</p>
              <div class="card-tags">
                <span v-for="cat in spot.categoryNames ? spot.categoryNames.split(',') : []" :key="cat" class="tag-category"
                  :style="{ background: getCategoryColor(cat) + '14', color: getCategoryColor(cat), borderColor: getCategoryColor(cat) + '30' }">
                  {{ cat }}
                </span>
                <span class="tag-region" v-if="spot.townName">{{ spot.townName }}</span>
                <span class="tag-region" v-if="spot.villageName">{{ spot.villageName }}</span>
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
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue"
import { ElMessage } from "element-plus"
import type { ScenicSpotListVO, ScenicSpotQueryDTO } from "@/types/scenic-spot"
import type { Region, RegionQueryDTO } from "@/types/region"
import {
    queryScenicSpotByViewerApi,
    queryRegionListByViewerApi
} from "@/api/viewer-api"

const themes = [
  { key: '古城遗韵', name: '古城遗韵', color: '#8B6914', icon: '🏯' },
  { key: '牡丹之都', name: '牡丹之都', color: '#A61B2E', icon: '🌺' },
  { key: '红色之旅', name: '红色之旅', color: '#C4364A', icon: '⭐' },
  { key: '非遗传承', name: '非遗传承', color: '#2E7D32', icon: '🎭' }
]

const activeTheme = ref<string | null>(null)
const scenicSpotQueryDTO = reactive<ScenicSpotQueryDTO>({
  current: 1, size: 12, title: '', regionIds: [], regionId: null, startTime: null, endTime: null
})

const countyList = ref<Region[]>([])
const townList = ref<Region[]>([])
const villageList = ref<Region[]>([])

const selectedCountyId = ref<number | null>(null)
const selectedTownId = ref<number | null>(null)
const selectedVillageId = ref<number | null>(null)

const scenicSpotListVOS = ref<ScenicSpotListVO[]>([])
const totalPageCount = ref<number>(0)

const particleStyle = (n: number) => {
  const x = Math.random() * 100, y = Math.random() * 100
  const size = 1.5 + Math.random() * 3, dur = 12 + Math.random() * 20, delay = Math.random() * 8
  return { left: `${x}%`, top: `${y}%`, width: `${size}px`, height: `${size}px`, animationDuration: `${dur}s`, animationDelay: `${delay}s` }
}

const getCategoryColor = (name: string) => {
  if (name.includes('古城') || name.includes('遗韵')) return '#8B6914'
  if (name.includes('牡丹') || name.includes('花')) return '#A61B2E'
  if (name.includes('红色') || name.includes('革命')) return '#C4364A'
  if (name.includes('非遗') || name.includes('传承') || name.includes('民俗')) return '#2E7D32'
  return '#666'
}

const selectTheme = (key: string | null) => {
  activeTheme.value = key
  scenicSpotQueryDTO.categoryKey = key || ''
  searchScenicSpotList()
}

const selectCounty = async (id: number | null) => {
  selectedCountyId.value = id
  selectedTownId.value = null
  selectedVillageId.value = null
  townList.value = []
  villageList.value = []
  if (id) {
    try {
      const { data } = await queryRegionListByViewerApi({ parentId: id })
      townList.value = data
    } catch (error: any) { ElMessage.error('查询乡镇信息异常') }
  }
  searchScenicSpotList()
}

const selectTown = async (id: number | null) => {
  selectedTownId.value = id
  selectedVillageId.value = null
  villageList.value = []
  if (id) {
    try {
      const { data } = await queryRegionListByViewerApi({ parentId: id })
      villageList.value = data
    } catch (error: any) { ElMessage.error('查询村信息异常') }
  }
  searchScenicSpotList()
}

const selectVillage = (id: number | null) => {
  selectedVillageId.value = id
  searchScenicSpotList()
}

const resetCondition = async () => {
  scenicSpotQueryDTO.title = ''
  scenicSpotQueryDTO.categoryKey = ''
  scenicSpotQueryDTO.regionId = null
  scenicSpotQueryDTO.regionIds = []
  scenicSpotQueryDTO.startTime = null
  scenicSpotQueryDTO.endTime = null
  selectedCountyId.value = null
  selectedTownId.value = null
  selectedVillageId.value = null
  townList.value = []
  villageList.value = []
  activeTheme.value = null
  await fetchScenicSpot()
}

const goDetail = (id: number) => {
  window.open(`/viewer-scenic-spot-info?scenicSpotId=${id}`)
}

const searchScenicSpotList = async () => {
  if (selectedVillageId.value) {
    scenicSpotQueryDTO.regionId = selectedVillageId.value
  } else if (selectedTownId.value) {
    scenicSpotQueryDTO.regionId = selectedTownId.value
  } else if (selectedCountyId.value) {
    scenicSpotQueryDTO.regionId = selectedCountyId.value
  } else {
    scenicSpotQueryDTO.regionId = null
  }
  scenicSpotQueryDTO.regionIds = []
  scenicSpotQueryDTO.current = 1
  await fetchScenicSpot()
}

const handleSizeChange = async (size: number) => {
  scenicSpotQueryDTO.size = size
  scenicSpotQueryDTO.current = 1
  await fetchScenicSpot()
}

const handleCurrentChange = async (current: number) => {
  scenicSpotQueryDTO.current = current
  await fetchScenicSpot()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const fetchScenicSpot = async () => {
  try {
    const { data, total } = await queryScenicSpotByViewerApi(scenicSpotQueryDTO)
    scenicSpotListVOS.value = data
    totalPageCount.value = total
  } catch (error: any) {
    ElMessage.error('景点查询异常')
  }
}

onMounted(async () => {
  try {
    const { data } = await queryRegionListByViewerApi({ parentId: -1 })
    countyList.value = data
  } catch (error: any) {
    ElMessage.error('查询地区信息异常')
  }
  await fetchScenicSpot()
})
</script>

<style lang="scss" scoped>
.spot-page {
  min-height: 100vh;
  background: #FAFAFA;
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

      .stat-num { font-size: 36px; font-weight: 700; font-family: var(--font-serif); color: white; }
      .stat-label { font-size: 14px; color: rgba(255, 255, 255, 0.5); letter-spacing: 2px; }
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
    display: flex; align-items: center; background: white; border: 2px solid rgba(0, 0, 0, 0.1);
    border-radius: 100px; padding: 4px; max-width: 480px; margin-bottom: 20px; transition: all 0.3s;
    &:focus-within { border-color: var(--primary-color); box-shadow: 0 0 0 4px rgba(166, 27, 46, 0.08); }
    svg { margin-left: 16px; color: var(--text-light); flex-shrink: 0; }
    input { flex: 1; border: none; background: transparent; padding: 10px 12px; font-size: 14px; outline: none; color: var(--text-main); font-family: inherit; &::placeholder { color: var(--text-light); } }
    .search-btn { padding: 8px 24px; background: var(--primary-color); color: white; border-radius: 100px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.3s; letter-spacing: 1px; flex-shrink: 0; &:hover { background: var(--primary-light); } }
  }

  .theme-filter, .region-filter {
    display: flex; align-items: flex-start; gap: 12px; margin-bottom: 14px;
    &.sub { padding-left: 48px; }
    .filter-label { font-size: 13px; font-weight: 600; color: var(--text-secondary); padding: 7px 0; flex-shrink: 0; min-width: 36px; }
  }

  .theme-chips { display: flex; flex-wrap: wrap; gap: 8px;
    .theme-chip {
      display: flex; align-items: center; gap: 6px; padding: 6px 18px; border-radius: 100px;
      font-size: 14px; font-weight: 500; color: var(--text-secondary); background: #F5F5F5;
      cursor: pointer; transition: all 0.25s; border: 1.5px solid transparent;
      .chip-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0;
        &.all { background: var(--text-light); }
      }
      &:hover { background: rgba(166, 27, 46, 0.04); }
      &.active { background: white; border-color: var(--primary-color); color: var(--primary-color); font-weight: 600; box-shadow: 0 2px 8px rgba(166, 27, 46, 0.1); }
    }
  }

  .region-chips { display: flex; flex-wrap: wrap; gap: 8px;
    .chip {
      padding: 6px 16px; border-radius: 100px; font-size: 13px; font-weight: 500;
      color: var(--text-secondary); background: #F5F5F5; cursor: pointer; transition: all 0.2s;
      &:hover { background: rgba(166, 27, 46, 0.06); color: var(--primary-color); }
      &.active { background: var(--primary-color); color: white; }
    }
  }

  .filter-actions {
    margin-top: 8px;

    .reset-btn {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 6px 16px;
      border-radius: 100px;
      font-size: 13px;
      font-weight: 500;
      color: var(--text-secondary);
      background: #F5F5F5;
      cursor: pointer;
      transition: all 0.3s;

      &:hover { background: rgba(166, 27, 46, 0.06); color: var(--primary-color); }
    }
  }
}

.spot-section {
  padding: 40px 0 80px;

  .spot-inner {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 40px;
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
    &:hover { background: var(--primary-light); transform: translateY(-1px); }
  }
}

.spot-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;
}

.spot-card {
  background: white;
  border: 1px solid rgba(0, 0, 0, 0.06);
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);

  &:hover {
    transform: translateY(-6px);
    box-shadow: 0 16px 48px rgba(0, 0, 0, 0.08);
    border-color: rgba(166, 27, 46, 0.12);

    .card-cover img { transform: scale(1.06); }
    .cover-badges { opacity: 1; }
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

    .cover-badges { position: absolute; top: 12px; left: 12px; opacity: 0; transition: opacity 0.3s;
      .badge-region { display: inline-flex; align-items: center; gap: 3px; padding: 3px 10px; background: rgba(0,0,0,0.55); backdrop-filter: blur(8px); border-radius: 100px; font-size: 11px; color: rgba(255,255,255,0.9); font-weight: 500; }
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

    .card-summary {
      font-size: 13px;
      color: var(--text-light);
      line-height: 1.7;
      display: -webkit-box;
      -webkit-box-orient: vertical;
      -webkit-line-clamp: 2;
      overflow: hidden;
      text-overflow: ellipsis;
      min-height: 44px;
      margin-bottom: 12px;
    }

    .card-tags { display: flex; flex-wrap: wrap; gap: 6px;
      .tag-category { display: inline-block; padding: 2px 10px; border-radius: 100px; font-size: 11px; font-weight: 600; border: 1px solid; letter-spacing: 0.5px; }
      .tag-region { display: inline-block; padding: 2px 10px; border-radius: 100px; font-size: 11px; font-weight: 500; color: var(--text-light); background: #F5F5F5; }
    }
  }
}

.pagination {
  display: flex;
  justify-content: center;
  padding: 48px 0 0;
}

@media (max-width: 1200px) {
  .spot-grid { grid-template-columns: repeat(3, 1fr); }
}

@media (max-width: 900px) {
  .spot-grid { grid-template-columns: repeat(2, 1fr); gap: 16px; }
  .hero-section { height: 280px; }
  .filter-section .filter-inner,
  .spot-section .spot-inner { padding: 0 20px; }
  .filter-section .search-box { max-width: 100%; }
}

@media (max-width: 600px) {
  .spot-grid { grid-template-columns: 1fr; }
  .hero-section { height: 240px; }
  .filter-section .filter-inner,
  .spot-section .spot-inner { padding: 0 16px; }
}
</style>
