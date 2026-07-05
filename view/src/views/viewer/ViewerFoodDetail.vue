<template>
  <div class="food-detail-page" v-if="foodInfo">
    <nav class="detail-nav" :class="{ scrolled: isScrolled }">
      <div class="nav-inner">
        <div class="nav-back" @click="$router.push(isUserContext ? '/user/user-main' : '/viewer')">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
          </svg>
          <span>返回</span>
        </div>
        <div class="nav-breadcrumb">
          <span @click="$router.push(isUserContext ? '/user/user-main' : '/viewer')">首页</span>
          <span class="sep">/</span>
          <span @click="$router.push(foodListPath)">特色美食</span>
          <span class="sep">/</span>
          <span class="current">{{ foodInfo.name }}</span>
        </div>
      </div>
    </nav>

    <section class="hero-section">
      <div class="hero-bg">
        <img :src="foodInfo.coverUrl" :alt="foodInfo.name" />
        <div class="hero-overlay"></div>
      </div>
      <div class="hero-content">
        <div class="hero-badge">{{ foodInfo.tag }}</div>
        <h1 class="hero-title">{{ foodInfo.name }}</h1>
        <div class="hero-address" v-if="foodInfo.address">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/>
            <circle cx="12" cy="10" r="3"/>
          </svg>
          <span>{{ foodInfo.address }}</span>
        </div>
      </div>
    </section>

    <section class="intro-section">
      <div class="section-inner">
        <div class="intro-layout">
          <div class="intro-main">
            <div class="section-label">
              <span class="label-dot"></span>
              <span>美食简介</span>
            </div>
            <p class="intro-text">{{ foodInfo.description }}</p>
          </div>
          <div class="intro-sidebar">
            <div class="sidebar-card">
              <div class="sidebar-icon">📍</div>
              <div class="sidebar-info">
                <div class="sidebar-title">推荐打卡地</div>
                <div class="sidebar-address">{{ foodInfo.address || '暂无地址信息' }}</div>
              </div>
              <div
                class="sidebar-action"
                v-if="foodInfo.longitude && foodInfo.latitude"
                @click="scrollToMap"
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/>
                  <circle cx="12" cy="10" r="3"/>
                </svg>
                <span>导航</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="detail-section" v-if="foodInfo.detail">
      <div class="section-inner">
        <div class="section-label">
          <span class="label-dot"></span>
          <span>详细介绍</span>
        </div>
        <div class="detail-content" v-html="foodInfo.detail"></div>
      </div>
    </section>

    <section class="map-section" ref="mapSectionRef" v-if="foodInfo.longitude && foodInfo.latitude">
      <div class="section-inner">
        <div class="section-label">
          <span class="label-dot"></span>
          <span>位置导航</span>
          <span class="label-hint">导航至最火门店</span>
        </div>
        <div class="map-info-bar">
          <div class="info-left">
            <div class="info-name">{{ foodInfo.name }}</div>
            <div class="info-address">{{ foodInfo.address }}</div>
          </div>
          <a
            class="info-nav-btn"
            :href="`https://uri.amap.com/navigation?to=${foodInfo.longitude},${foodInfo.latitude},${foodInfo.name}&mode=bus&src=henitongyou`"
            target="_blank"
            rel="noopener"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polygon points="3 11 22 2 13 21 11 13 3 11"/>
            </svg>
            <span>去导航</span>
          </a>
        </div>
        <div id="amap-container" class="amap-container"></div>
      </div>
    </section>

    <section class="no-map-section" v-else>
      <div class="section-inner">
        <div class="no-map-card">
          <div class="no-map-icon">🗺️</div>
          <div class="no-map-text">暂无位置导航信息</div>
          <div class="no-map-hint">该美食的门店位置信息正在完善中</div>
        </div>
      </div>
    </section>
  </div>

  <div class="food-detail-loading" v-else>
    <div class="loading-spinner"></div>
    <p>加载中...</p>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick, computed, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getFoodDetailApi } from '@/api/food-api'
import type { Food } from '@/types/food'

const route = useRoute()
const router = useRouter()
const foodInfo = ref<Food | null>(null)
const isScrolled = ref(false)
const mapSectionRef = ref<HTMLElement>()
let mapInstance: any = null

const isUserContext = computed(() => route.path.startsWith('/user/'))
const foodListPath = computed(() => isUserContext.value ? '/user/user-food' : '/viewer-food')

const handleScroll = () => {
  isScrolled.value = window.scrollY > 60
}

const scrollToMap = () => {
  if (mapSectionRef.value) {
    mapSectionRef.value.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }
}

const loadDetail = async () => {
  const id = Number(route.query.id)
  if (!id) return
  try {
    const res = await getFoodDetailApi(id)
    foodInfo.value = res.data
    if (foodInfo.value?.longitude && foodInfo.value?.latitude) {
      await nextTick()
      await nextTick()
      initAmap()
    }
  } catch (e) {
    console.error(e)
  }
}

const initAmap = () => {
  const existingScript = document.querySelector('#amap-jsapi')
  if (existingScript) {
    createMap()
    return
  }

  ;(window as any)._AMapSecurityConfig = {
    securityJsCode: '3046590da85289ee9403a79181de9869',
  }

  const script = document.createElement('script')
  script.id = 'amap-jsapi'
  script.src = 'https://webapi.amap.com/maps?v=2.0&key=622ced2f0adbc85657918a75b7caccc5'
  script.onload = () => {
    createMap()
  }
  document.head.appendChild(script)
}

const createMap = () => {
  const AMap = (window as any).AMap
  if (!AMap || !foodInfo.value) return

  const container = document.getElementById('amap-container')
  if (!container) {
    setTimeout(() => createMap(), 200)
    return
  }

  if (mapInstance) {
    mapInstance.destroy()
    mapInstance = null
  }

  const lng = foodInfo.value.longitude!
  const lat = foodInfo.value.latitude!

  mapInstance = new AMap.Map('amap-container', {
    zoom: 15,
    center: [lng, lat],
    viewMode: '2D',
  })

  const marker = new AMap.Marker({
    position: [lng, lat],
    title: foodInfo.value.name,
    map: mapInstance,
  })

  marker.setLabel({
    direction: 'top',
    offset: new AMap.Pixel(0, -8),
    content: `<div style="padding:4px 12px;background:#A61B2E;color:#fff;font-size:13px;border-radius:4px;white-space:nowrap;font-family:sans-serif;">${foodInfo.value.name}</div>`,
  })
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  loadDetail()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  if (mapInstance) {
    mapInstance.destroy()
    mapInstance = null
  }
})
</script>

<style lang="scss" scoped>
.food-detail-page {
  min-height: 100vh;
  background: #FAFAFA;
}

.detail-nav {
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
    gap: 24px;
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

  .nav-breadcrumb {
    font-size: 13px;
    color: rgba(255, 255, 255, 0.6);

    span { cursor: pointer; transition: color 0.3s; }
    span:hover { color: white; }
    .sep { margin: 0 8px; cursor: default; }
    .current { color: rgba(255, 255, 255, 0.9); cursor: default; }
  }

  &.scrolled .nav-breadcrumb {
    color: var(--text-light);
    span:hover { color: var(--text-main); }
    .current { color: var(--text-main); }
  }
}

.hero-section {
  position: relative;
  height: 480px;
  overflow: hidden;

  .hero-bg {
    position: absolute;
    inset: 0;

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .hero-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(to top, rgba(0, 0, 0, 0.75) 0%, rgba(0, 0, 0, 0.2) 50%, rgba(0, 0, 0, 0.1) 100%);
    }
  }

  .hero-content {
    position: absolute;
    bottom: 60px;
    left: 0;
    right: 0;
    z-index: 2;
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 40px;

    .hero-badge {
      display: inline-block;
      padding: 6px 16px;
      background: var(--primary-color);
      color: white;
      font-size: 13px;
      font-weight: 600;
      letter-spacing: 2px;
      border-radius: 100px;
      margin-bottom: 20px;
    }

    .hero-title {
      font-family: var(--font-serif);
      font-size: clamp(32px, 5vw, 48px);
      font-weight: 700;
      color: white;
      letter-spacing: 4px;
      margin-bottom: 16px;
    }

    .hero-address {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 15px;
      color: rgba(255, 255, 255, 0.7);
      letter-spacing: 1px;
    }
  }
}

.section-inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 40px;
}

.section-label {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 20px;
  font-weight: 700;
  color: var(--text-main);
  letter-spacing: 2px;
  margin-bottom: 28px;
  font-family: var(--font-serif);

  .label-dot {
    width: 4px;
    height: 20px;
    border-radius: 2px;
    background: var(--primary-color);
  }

  .label-hint {
    font-size: 13px;
    font-weight: 400;
    color: var(--text-light);
    letter-spacing: 1px;
    margin-left: 8px;
  }
}

.intro-section {
  padding: 48px 0;
  background: white;
  border-bottom: 1px solid rgba(0, 0, 0, 0.04);

  .intro-layout {
    display: flex;
    gap: 32px;
    align-items: flex-start;
  }

  .intro-main {
    flex: 1;

    .intro-text {
      font-size: 16px;
      color: var(--text-secondary);
      line-height: 2;
      letter-spacing: 0.5px;
    }
  }

  .intro-sidebar {
    flex-shrink: 0;
    width: 320px;

    .sidebar-card {
      background: #FAFAFA;
      border: 1px solid rgba(0, 0, 0, 0.06);
      border-radius: 16px;
      padding: 24px;
      display: flex;
      align-items: center;
      gap: 16px;

      .sidebar-icon {
        font-size: 32px;
        flex-shrink: 0;
      }

      .sidebar-info {
        flex: 1;
        min-width: 0;

        .sidebar-title {
          font-size: 14px;
          font-weight: 600;
          color: var(--text-main);
          margin-bottom: 4px;
          letter-spacing: 1px;
        }

        .sidebar-address {
          font-size: 13px;
          color: var(--text-light);
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }
      }

      .sidebar-action {
        display: flex;
        align-items: center;
        gap: 4px;
        padding: 8px 16px;
        background: var(--primary-color);
        color: white;
        border-radius: 100px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        flex-shrink: 0;

        &:hover {
          background: var(--primary-light);
          transform: translateY(-1px);
        }
      }
    }
  }
}

.detail-section {
  padding: 48px 0;
  background: white;
  margin-top: 16px;

  .detail-content {
    font-size: 15px;
    line-height: 1.9;
    color: var(--text-secondary);

    :deep(img) {
      max-width: 100%;
      border-radius: 12px;
      margin: 20px 0;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
    }

    :deep(p) {
      margin-bottom: 16px;
    }

    :deep(h2), :deep(h3), :deep(h4) {
      color: var(--text-main);
      margin: 24px 0 12px;
    }
  }
}

.map-section {
  padding: 48px 0 80px;
  background: white;
  margin-top: 16px;

  .map-info-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20px 24px;
    background: #FAFAFA;
    border: 1px solid rgba(0, 0, 0, 0.06);
    border-radius: 16px;
    margin-bottom: 20px;

    .info-left {
      .info-name {
        font-size: 16px;
        font-weight: 600;
        color: var(--text-main);
        margin-bottom: 4px;
        letter-spacing: 1px;
      }

      .info-address {
        font-size: 13px;
        color: var(--text-light);
      }
    }

    .info-nav-btn {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 10px 24px;
      background: var(--primary-color);
      color: white;
      border-radius: 100px;
      font-size: 14px;
      font-weight: 600;
      text-decoration: none;
      transition: all 0.3s;
      letter-spacing: 1px;

      &:hover {
        background: var(--primary-light);
        transform: translateY(-1px);
        box-shadow: 0 8px 24px rgba(166, 27, 46, 0.3);
      }
    }
  }

  .amap-container {
    width: 100%;
    height: 480px;
    border-radius: 16px;
    overflow: hidden;
    border: 1px solid rgba(0, 0, 0, 0.06);
  }
}

.no-map-section {
  padding: 48px 0 80px;
  background: white;
  margin-top: 16px;

  .no-map-card {
    text-align: center;
    padding: 60px 20px;
    background: #FAFAFA;
    border-radius: 16px;
    border: 1px dashed rgba(0, 0, 0, 0.1);

    .no-map-icon {
      font-size: 48px;
      margin-bottom: 16px;
    }

    .no-map-text {
      font-size: 16px;
      font-weight: 600;
      color: var(--text-main);
      margin-bottom: 8px;
    }

    .no-map-hint {
      font-size: 14px;
      color: var(--text-light);
    }
  }
}

.food-detail-loading {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;

  .loading-spinner {
    width: 32px;
    height: 32px;
    border: 3px solid rgba(166, 27, 46, 0.15);
    border-top-color: var(--primary-color);
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }

  p {
    font-size: 14px;
    color: var(--text-light);
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }
}

@media (max-width: 1024px) {
  .intro-section .intro-layout {
    flex-direction: column;

    .intro-sidebar {
      width: 100%;
    }
  }
}

@media (max-width: 768px) {
  .detail-nav .nav-inner { padding: 0 20px; }
  .section-inner { padding: 0 20px; }

  .hero-section {
    height: 360px;

    .hero-content {
      bottom: 40px;

      .hero-title { letter-spacing: 2px; }
    }
  }

  .intro-section .intro-sidebar .sidebar-card {
    flex-wrap: wrap;

    .sidebar-action {
      width: 100%;
      justify-content: center;
    }
  }

  .map-section {
    .map-info-bar {
      flex-direction: column;
      gap: 16px;
      align-items: flex-start;

      .info-nav-btn {
        width: 100%;
        justify-content: center;
      }
    }

    .amap-container { height: 360px; }
  }
}
</style>
