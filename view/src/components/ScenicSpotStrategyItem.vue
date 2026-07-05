<template>
  <div class="strategy-section">
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

    <div v-if="scrollable" class="strategy-scroll-wrapper">
      <div class="strategy-scroll-track">
        <div
          v-for="(strategy, index) in scenicSpotStrategyList"
          :key="'a-' + strategy.id"
          class="strategy-card scroll-card"
          @click="handleView(strategy)"
        >
          <div class="card-cover">
            <img :src="strategy.cover" :alt="strategy.title" />
            <div class="cover-overlay">
              <span class="cover-index">{{ String(index + 1).padStart(2, '0') }}</span>
            </div>
          </div>
          <div class="card-body">
            <h4 class="card-title">{{ strategy.title }}</h4>
            <p class="card-summary">{{ strategy.summary }}</p>
            <div class="card-author">
              <img class="author-avatar" :src="strategy.avatar" :alt="strategy.username" />
              <span class="author-name">{{ strategy.username }}</span>
            </div>
          </div>
        </div>
        <div
          v-for="(strategy, index) in scenicSpotStrategyList"
          :key="'b-' + strategy.id"
          class="strategy-card scroll-card"
          @click="handleView(strategy)"
        >
          <div class="card-cover">
            <img :src="strategy.cover" :alt="strategy.title" />
            <div class="cover-overlay">
              <span class="cover-index">{{ String(index + 1).padStart(2, '0') }}</span>
            </div>
          </div>
          <div class="card-body">
            <h4 class="card-title">{{ strategy.title }}</h4>
            <p class="card-summary">{{ strategy.summary }}</p>
            <div class="card-author">
              <img class="author-avatar" :src="strategy.avatar" :alt="strategy.username" />
              <span class="author-name">{{ strategy.username }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="strategy-grid">
      <div
        v-for="(strategy, index) in scenicSpotStrategyList"
        :key="strategy.id"
        class="strategy-card"
        @click="handleView(strategy)"
      >
        <div class="card-cover">
          <img :src="strategy.cover" :alt="strategy.title" />
          <div class="cover-overlay">
            <span class="cover-index">{{ String(index + 1).padStart(2, '0') }}</span>
          </div>
        </div>
        <div class="card-body">
          <h4 class="card-title">{{ strategy.title }}</h4>
          <p class="card-summary">{{ strategy.summary }}</p>
          <div class="card-author">
            <img class="author-avatar" :src="strategy.avatar" :alt="strategy.username" />
            <span class="author-name">{{ strategy.username }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { ScenicSpotStrategyListVO } from '@/types/scenic-spot-strategy'

const props = withDefaults(defineProps<{
  scenicSpotStrategyList: ScenicSpotStrategyListVO[]
  title: string
  subTitle: string
  badge?: string
  scrollable?: boolean
}>(), {
  scrollable: false,
})

const emit = defineEmits<{
  (e: 'view', id: number): void
  (e: 'search', id: number | null): void
}>()

const handleView = (strategy: ScenicSpotStrategyListVO) => {
  if (!strategy.id) return
  emit('view', strategy.id)
}

const handleSearch = () => {
  emit('search', null)
}
</script>

<style lang="scss" scoped>
.strategy-section {
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

.strategy-scroll-wrapper {
  overflow: hidden;
  margin: 0 -48px;
  padding: 0 48px;

  &:hover .strategy-scroll-track {
    animation-play-state: paused;
  }
}

.strategy-scroll-track {
  display: flex;
  gap: 20px;
  width: max-content;
  animation: scrollLoop 35s linear infinite;

  @keyframes scrollLoop {
    from { transform: translateX(0); }
    to { transform: translateX(-50%); }
  }
}

.strategy-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.strategy-card {
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
    width: 280px;
    flex-shrink: 0;
  }

  .card-cover {
    position: relative;
    width: 100%;
    height: 180px;
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

    .card-summary {
      font-size: 13px;
      color: var(--text-light);
      line-height: 1.6;
      margin-bottom: 14px;
      display: -webkit-box;
      -webkit-box-orient: vertical;
      -webkit-line-clamp: 2;
      overflow: hidden;
      text-overflow: ellipsis;
      min-height: 41.6px;
    }

    .card-author {
      display: flex;
      align-items: center;
      gap: 8px;
      padding-top: 12px;
      border-top: 1px solid var(--border-color);

      .author-avatar {
        width: 24px;
        height: 24px;
        border-radius: 50%;
        object-fit: cover;
        border: 1px solid var(--border-color);
      }

      .author-name {
        font-size: 13px;
        color: var(--text-light);
        letter-spacing: 0.5px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 120px;
      }
    }
  }
}

@media (max-width: 1200px) {
  .strategy-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 1024px) {
  .strategy-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .strategy-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 14px;
  }

  .strategy-card {
    &.scroll-card { width: 240px; }
    .card-cover { height: 140px; }
  }

  .section-head .head-right {
    font-size: 13px;
    padding: 6px 16px;
  }
}

@media (max-width: 480px) {
  .strategy-grid {
    grid-template-columns: 1fr;
  }
}
</style>
