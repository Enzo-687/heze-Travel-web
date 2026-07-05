<template>
  <div class="page-layout">
    <!-- 顶部导航 -->
    <nav class="page-nav" :class="{ scrolled: isScrolled }">
      <div class="nav-inner">
        <div class="nav-logo" @click="goHome">
          <img src="/logo.png" alt="菏你同游" class="logo-img" />
          <span class="logo-text">菏你同游</span>
        </div>
        <div class="nav-actions">
          <div v-if="!isLoggedIn" class="nav-login-btn" @click="goLogin">
            登录 / 注册
          </div>
          <div v-else class="nav-user-btn" @click="goUserCenter">
            <el-avatar :size="32" :src="userInfo?.avatar" />
            <span>{{ userInfo?.username || '用户' }}</span>
          </div>
        </div>
      </div>
    </nav>

    <!-- 页面头部 -->
    <header class="page-header">
      <div class="header-bg">
        <div class="peony-decoration">
          <svg viewBox="0 0 200 200" class="peony-svg">
            <defs>
              <radialGradient id="peonyGrad" cx="50%" cy="40%" r="50%">
                <stop offset="0%" style="stop-color:#C4364A;stop-opacity:0.25" />
                <stop offset="100%" style="stop-color:#7A1220;stop-opacity:0.05" />
              </radialGradient>
            </defs>
            <g opacity="0.3">
              <ellipse cx="100" cy="80" rx="30" ry="45" fill="url(#peonyGrad)" transform="rotate(0 100 100)" />
              <ellipse cx="100" cy="80" rx="30" ry="45" fill="url(#peonyGrad)" transform="rotate(45 100 100)" />
              <ellipse cx="100" cy="80" rx="30" ry="45" fill="url(#peonyGrad)" transform="rotate(90 100 100)" />
              <ellipse cx="100" cy="80" rx="30" ry="45" fill="url(#peonyGrad)" transform="rotate(135 100 100)" />
            </g>
            <circle cx="100" cy="100" r="12" fill="#E38995" opacity="0.2" />
          </svg>
        </div>
        <div class="header-overlay"></div>
      </div>
      <div class="header-content">
        <h1 class="header-title">{{ title }}</h1>
        <p class="header-subtitle">{{ subtitle }}</p>
        <div class="header-breadcrumb">
          <span class="breadcrumb-item" @click="goHome">首页</span>
          <span class="breadcrumb-separator">/</span>
          <span class="breadcrumb-item active">{{ title }}</span>
        </div>
      </div>
    </header>

    <!-- 页面内容 -->
    <main class="page-main">
      <div class="main-inner">
        <slot />
      </div>
    </main>

    <!-- 页脚 -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { getToken } from '@/utils/storage'
import { useUserStore } from '@/stores/user'
import AppFooter from './AppFooter.vue'

const props = defineProps<{
  title: string
  subtitle?: string
}>()

const router = useRouter()
const userStore = useUserStore()
const isScrolled = ref(false)

const isLoggedIn = computed(() => !!getToken())
const userInfo = computed(() => userStore.userInfo)

const goHome = () => router.push('/viewer')
const goLogin = () => router.push('/login')
const goUserCenter = () => router.push('/user')

const handleScroll = () => {
  isScrolled.value = window.scrollY > 60
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped lang="scss">
.page-layout {
  min-height: 100vh;
  background: #faf8f5;
}

// 导航
.page-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  height: 64px;
  transition: all 0.3s ease;
  background: transparent;

  &.scrolled {
    background: rgba(250, 248, 245, 0.95);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-bottom: 1px solid rgba(166, 27, 46, 0.08);
    box-shadow: 0 2px 20px rgba(0, 0, 0, 0.04);

    .logo-text {
      color: #1a1a2e;
    }

    .nav-login-btn {
      border-color: #a61b2e;
      color: #a61b2e;
    }
  }

  .nav-inner {
    max-width: 1280px;
    margin: 0 auto;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 40px;
  }

  .nav-logo {
    display: flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;

    .logo-img {
      width: 36px;
      height: 36px;
      object-fit: contain;
      border-radius: 8px;
    }

    .logo-text {
      font-family: 'Noto Serif SC', serif;
      font-size: 18px;
      font-weight: 600;
      color: white;
      letter-spacing: 2px;
      transition: color 0.3s;
    }
  }

  .nav-actions {
    display: flex;
    align-items: center;
    gap: 16px;
  }

  .nav-login-btn {
    padding: 8px 24px;
    border: 1px solid rgba(255, 255, 255, 0.5);
    border-radius: 100px;
    color: white;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s;

    &:hover {
      background: #a61b2e;
      border-color: #a61b2e;
      color: white;
    }
  }

  .nav-user-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    padding: 4px 12px 4px 4px;
    border-radius: 100px;
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    transition: all 0.3s;

    span {
      color: white;
      font-size: 14px;
    }

    &:hover {
      background: rgba(166, 27, 46, 0.1);
      border-color: rgba(166, 27, 46, 0.3);
    }
  }

  &.scrolled .nav-user-btn {
    background: rgba(0, 0, 0, 0.04);
    border-color: rgba(0, 0, 0, 0.08);

    span {
      color: #1a1a2e;
    }
  }
}

// 页面头部
.page-header {
  position: relative;
  height: 320px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  background: linear-gradient(135deg, #0A0A0A 0%, #1A0A0E 30%, #2A1018 60%, #0A0A0A 100%);

  .header-bg {
    position: absolute;
    inset: 0;
    background: #1a1a2e;

    .peony-decoration {
      position: absolute;
      right: 5%;
      top: 50%;
      transform: translateY(-50%);
      width: 300px;
      height: 300px;
      opacity: 0.6;
    }

    .peony-svg {
      width: 100%;
      height: 100%;
    }

    .header-overlay {
      position: absolute;
      inset: 0;
      background: radial-gradient(ellipse at 30% 50%, rgba(166, 27, 46, 0.15) 0%, transparent 60%);
    }
  }

  .header-content {
    position: relative;
    z-index: 2;
    text-align: center;
    padding: 0 24px;

    .header-title {
      font-family: 'Noto Serif SC', serif;
      font-size: 42px;
      font-weight: 600;
      color: white;
      margin: 0 0 12px;
      letter-spacing: 4px;
    }

    .header-subtitle {
      font-size: 16px;
      color: rgba(255, 255, 255, 0.6);
      margin: 0 0 24px;
      letter-spacing: 2px;
    }

    .header-breadcrumb {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      font-size: 14px;

      .breadcrumb-item {
        color: rgba(255, 255, 255, 0.5);
        cursor: pointer;
        transition: color 0.25s;

        &:hover {
          color: #e38995;
        }

        &.active {
          color: rgba(255, 255, 255, 0.8);
          cursor: default;
        }
      }

      .breadcrumb-separator {
        color: rgba(255, 255, 255, 0.3);
      }
    }
  }
}

// 页面主体
.page-main {
  padding: 60px 0;

  .main-inner {
    max-width: 900px;
    margin: 0 auto;
    padding: 0 40px;
  }
}

// 响应式
@media (max-width: 768px) {
  .page-nav .nav-inner {
    padding: 0 20px;
  }

  .page-header {
    height: 260px;

    .header-content {
      .header-title {
        font-size: 28px;
      }

      .header-subtitle {
        font-size: 14px;
      }
    }

    .peony-decoration {
      width: 180px !important;
      height: 180px !important;
      opacity: 0.4 !important;
    }
  }

  .page-main {
    padding: 40px 0;

    .main-inner {
      padding: 0 20px;
    }
  }
}
</style>
