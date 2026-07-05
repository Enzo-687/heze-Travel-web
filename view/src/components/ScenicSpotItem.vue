<template>
  <div class="spot-section">
    <div class="section-head">
      <div class="head-left">
        <span class="section-badge">{{ badge }}</span>
        <h3 class="section-title">{{ title }}</h3>
        <p class="section-sub">{{ subTitle }}</p>
      </div>
      <div class="head-right" @click="handleSearch">
        <span>查看全部</span>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M5 12h14M12 5l7 7-7 7"/>
        </svg>
      </div>
    </div>

    <div v-if="scrollable" class="spot-scroll-wrapper">
      <div class="spot-scroll-track" :class="{ paused: isPaused }">
        <div
          v-for="(spot, index) in scenicSpotList"
          :key="'a-' + spot.id"
          class="spot-card scroll-card"
          @click="handleDetail(spot)"
        >
          <div class="card-cover">
            <img :src="spot.cover" :alt="spot.title" />
            <div class="cover-overlay">
              <span class="cover-index">{{ String(index + 1).padStart(2, '0') }}</span>
            </div>
          </div>
          <div class="card-body">
            <h4 class="card-title">{{ spot.title }}</h4>
            <div class="card-location">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/>
                <circle cx="12" cy="10" r="3"/>
              </svg>
              <span>{{ [spot.countyName, spot.townName, spot.villageName].filter(Boolean).join('·') }}</span>
            </div>
            <p class="card-summary">{{ spot.summary }}</p>
          </div>
        </div>
        <div
          v-for="(spot, index) in scenicSpotList"
          :key="'b-' + spot.id"
          class="spot-card scroll-card"
          @click="handleDetail(spot)"
        >
          <div class="card-cover">
            <img :src="spot.cover" :alt="spot.title" />
            <div class="cover-overlay">
              <span class="cover-index">{{ String(index + 1).padStart(2, '0') }}</span>
            </div>
          </div>
          <div class="card-body">
            <h4 class="card-title">{{ spot.title }}</h4>
            <div class="card-location">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/>
                <circle cx="12" cy="10" r="3"/>
              </svg>
              <span>{{ [spot.countyName, spot.townName, spot.villageName].filter(Boolean).join('·') }}</span>
            </div>
            <p class="card-summary">{{ spot.summary }}</p>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="spot-grid">
      <div
        v-for="(spot, index) in scenicSpotList"
        :key="spot.id"
        class="spot-card"
        @click="handleDetail(spot)"
      >
        <div class="card-cover">
          <img :src="spot.cover" :alt="spot.title" />
          <div class="cover-overlay">
            <span class="cover-index">{{ String(index + 1).padStart(2, '0') }}</span>
          </div>
        </div>
        <div class="card-body">
          <h4 class="card-title">{{ spot.title }}</h4>
          <div class="card-location">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/>
              <circle cx="12" cy="10" r="3"/>
            </svg>
            <span>{{ [spot.countyName, spot.townName, spot.villageName].filter(Boolean).join('·') }}</span>
          </div>
          <p class="card-summary">{{ spot.summary }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { ScenicSpotListVO } from '@/types/scenic-spot'

const props = withDefaults(defineProps<{
  scenicSpotList: ScenicSpotListVO[]
  title: string
  subTitle: string
  badge?: string
  scrollable?: boolean
}>(), {
  scrollable: false,
})

const emit = defineEmits<{
  (e: 'viewDetail', id: number): void
  (e: 'search'): void
}>()

const isPaused = ref(false)

const handleDetail = (spot: ScenicSpotListVO) => {
  emit('viewDetail', spot.id)
}

const handleSearch = () => {
  emit('search')
}
</script>

<style lang="scss" scoped>
.spot-section {
  margin-bottom: 56px;

  &:last-child { margin-bottom: 0; }
}

.section-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-bottom: 28px;
  gap: 16px;

  .head-left {
    .section-badge {
      display: inline-block;
      padding: 4px 12px;
      background: rgba(166, 27, 46, 0.08);
      color: var(--primary-color);
      font-size: 11px;
      font-weight: 600;
      letter-spacing: 2px;
      border-radius: 100px;
      margin-bottom: 10px;
    }

    .section-title {
      font-family: var(--font-serif);
      font-size: 24px;
      font-weight: 700;
      color: var(--text-main);
      letter-spacing: 2px;
      margin-bottom: 4px;
    }

    .section-sub {
      font-size: 14px;
      color: var(--text-light);
      letter-spacing: 1px;
    }
  }

  .head-right {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 14px;
    font-weight: 500;
    color: var(--primary-color);
    cursor: pointer;
    transition: all 0.3s;
    letter-spacing: 1px;
    flex-shrink: 0;
    padding: 8px 20px;
    border-radius: 100px;
    border: 1px solid rgba(166, 27, 46, 0.2);

    &:hover {
      background: rgba(166, 27, 46, 0.06);
      border-color: var(--primary-color);
    }
  }
}

.spot-scroll-wrapper {
  overflow: hidden;
  margin: 0 -48px;
  padding: 0 48px;

  &:hover .spot-scroll-track {
    animation-play-state: paused;
  }
}

.spot-scroll-track {
  display: flex;
  gap: 20px;
  width: max-content;
  animation: scrollLoop 30s linear infinite;

  &.paused {
    animation-play-state: paused;
  }

  @keyframes scrollLoop {
    from { transform: translateX(0); }
    to { transform: translateX(-50%); }
  }
}

.spot-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
}

.spot-card {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);

  &:hover {
    transform: translateY(-6px);
    box-shadow: 0 16px 48px rgba(0, 0, 0, 0.08);
    border-color: rgba(166, 27, 46, 0.2);

    .card-cover img {
      transform: scale(1.06);
    }

    .cover-overlay {
      opacity: 1;
    }
  }

  &.scroll-card {
    width: 260px;
    flex-shrink: 0;
  }

  .card-cover {
    position: relative;
    width: 100%;
    height: 160px;
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
      background: linear-gradient(to top, rgba(0, 0, 0, 0.5) 0%, transparent 50%);
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
        color: rgba(255, 255, 255, 0.25);
        line-height: 1;
      }
    }
  }

  .card-body {
    padding: 16px;

    .card-title {
      font-size: 15px;
      font-weight: 600;
      color: var(--text-main);
      margin-bottom: 8px;
      letter-spacing: 0.5px;
      display: -webkit-box;
      -webkit-box-orient: vertical;
      -webkit-line-clamp: 1;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .card-location {
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: 12px;
      color: var(--text-light);
      margin-bottom: 8px;

      svg { flex-shrink: 0; opacity: 0.5; }

      span {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
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
    }
  }
}

@media (max-width: 1200px) {
  .spot-grid {
    grid-template-columns: repeat(4, 1fr);
  }
}

@media (max-width: 1024px) {
  .spot-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .spot-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 14px;
  }

  .spot-card {
    &.scroll-card { width: 220px; }
    .card-cover { height: 130px; }
  }

  .section-head .head-right {
    font-size: 13px;
    padding: 6px 16px;
  }
}

@media (max-width: 480px) {
  .spot-grid {
    grid-template-columns: 1fr;
  }
}
</style>
