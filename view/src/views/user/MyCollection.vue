<template>
  <div class="collection-page">
    <div class="collection-header">
      <div class="header-left">
        <span class="section-badge">COLLECTION</span>
        <h2 class="header-title">我的收藏</h2>
        <p class="header-sub">您收藏的景点与攻略，一键回顾</p>
      </div>
    </div>

    <div class="collection-tabs">
      <div
        class="tab-item"
        :class="{ active: activeTab === 'spot' }"
        @click="activeTab = 'spot'"
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/>
          <circle cx="12" cy="10" r="3"/>
        </svg>
        <span>景点收藏</span>
        <span class="tab-count" v-if="activeTab === 'spot' && spotCount">{{ spotCount }}</span>
      </div>
      <div
        class="tab-item"
        :class="{ active: activeTab === 'strategy' }"
        @click="activeTab = 'strategy'"
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
          <polyline points="14 2 14 8 20 8"/>
        </svg>
        <span>攻略收藏</span>
        <span class="tab-count" v-if="activeTab === 'strategy' && strategyCount">{{ strategyCount }}</span>
      </div>
    </div>

    <div class="collection-body">
      <CollectionScenicSpotList v-show="activeTab === 'spot'" @count-change="spotCount = $event" />
      <CollectionScenicSpotStrategy v-show="activeTab === 'strategy'" @count-change="strategyCount = $event" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CollectionScenicSpotList from './CollectionScenicSpotList.vue'
import CollectionScenicSpotStrategy from './CollectionScenicSpotStrategy.vue'

const activeTab = ref<'spot' | 'strategy'>('spot')
const spotCount = ref(0)
const strategyCount = ref(0)
</script>

<style lang="scss" scoped>
.collection-page {
  max-width: 1100px;
  margin: 0 auto;
}

.collection-header {
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
}

.collection-tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 28px;
  border-bottom: 1px solid #ECEEF0;
  padding-bottom: 0;

  .tab-item {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 12px 24px;
    font-size: 15px;
    font-weight: 500;
    color: var(--text-light);
    cursor: pointer;
    border-bottom: 2px solid transparent;
    transition: all 0.3s;
    margin-bottom: -1px;

    &:hover {
      color: var(--text-secondary);
    }

    &.active {
      color: var(--primary-color);
      border-bottom-color: var(--primary-color);
      font-weight: 600;
    }

    .tab-count {
      background: rgba(166, 27, 46, 0.08);
      color: var(--primary-color);
      font-size: 12px;
      font-weight: 600;
      padding: 2px 8px;
      border-radius: 100px;
      min-width: 20px;
      text-align: center;
    }
  }
}

.collection-body {
  min-height: 300px;
}
</style>
