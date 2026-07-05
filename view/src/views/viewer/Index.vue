<template>
  <div class="viewer-layout">
    <nav class="nav-bar" :class="{ scrolled: isScrolled }">
      <div class="nav-inner">
        <div class="nav-logo" @click="scrollToTop">
          <img src="/logo.png" alt="菏你同游" class="logo-img" />
          <span class="logo-text">菏你同游</span>
        </div>
        <ul class="nav-links">
          <li
            v-for="item in navItems"
            :key="item.key"
            :class="{ active: defaultPathKey === item.key }"
            @click="navItemClick(item.key)"
          >
            {{ item.label }}
          </li>
        </ul>
        <div class="nav-actions">
          <div class="nav-login-btn" @click="$router.push('/login')">登录 / 注册</div>
        </div>
      </div>
    </nav>

    <section class="hero-section">
      <div class="hero-canvas">
        <div class="hero-gradient"></div>
        <div class="hero-mesh"></div>
        <div class="hero-particles">
          <span v-for="n in 20" :key="n" class="particle" :style="particleStyle(n)"></span>
        </div>
      </div>

      <div class="hero-layout">
        <div class="hero-left">
          <div class="hero-eyebrow">
            <span class="eyebrow-dot"></span>
            <span>中国牡丹之都 · 山东菏泽</span>
          </div>
          <h1 class="hero-heading">
            <span class="heading-line">菏你同游</span>
            <span class="heading-line heading-sub">遇见千年牡丹之城</span>
          </h1>
          <p class="hero-desc">千年古韵 · 牡丹花城 · 红色热土 · 非遗传承</p>
          <div class="hero-actions">
            <div class="cta-primary" @click="scrollToThemes">
              <span>开始探索</span>
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M5 12h14M12 5l7 7-7 7"/>
              </svg>
            </div>
            <div class="cta-secondary" @click="$router.push('/viewer-themes')">
              <span>四大主题</span>
            </div>
          </div>
        </div>
        <div class="hero-right">
          <div class="peony-frame">
            <Peony3D />
          </div>
        </div>
      </div>

      <div class="hero-marquee">
        <div class="marquee-track">
          <div class="marquee-item" v-for="n in 2" :key="'m'+n">
            <span class="marquee-stat" v-for="stat in heroStats" :key="stat.label + n">
              <strong>{{ stat.value }}</strong>
              <span>{{ stat.label }}</span>
              <span class="marquee-sep">◆</span>
            </span>
          </div>
        </div>
      </div>
    </section>

    <section class="themes-showcase" ref="themesSection">
      <div class="showcase-inner">
        <div class="showcase-header">
          <div class="showcase-label">DISCOVER HEZE</div>
          <h2 class="showcase-title">四色菏泽</h2>
        </div>
        <div class="showcase-scroll">
          <div class="showcase-track">
            <div
              v-for="(cat, i) in categories"
              :key="cat.key"
              class="showcase-card"
              :style="{ '--accent': cat.accent }"
              @click="navItemClick(cat.key)"
            >
              <div class="card-visual" :style="{ background: cat.gradient }">
                <div class="visual-rings">
                  <span class="ring"></span>
                  <span class="ring"></span>
                </div>
                <span class="visual-icon">{{ cat.icon }}</span>
                <span class="visual-label">{{ cat.pattern }}</span>
              </div>
              <div class="card-body">
                <div class="card-index">{{ String(i + 1).padStart(2, '0') }}</div>
                <h3 class="card-title">{{ cat.title }}</h3>
                <p class="card-desc">{{ cat.desc }}</p>
                <div class="card-link">
                  <span>了解更多</span>
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M5 12h14M12 5l7 7-7 7"/>
                  </svg>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="content-section">
      <div class="content-inner">
        <div class="content-header">
          <div class="content-title-group">
            <h2 class="content-title">{{ defaultPathKey === 'home' ? '热门景点' : '景点攻略' }}</h2>
            <p class="content-subtitle">{{ defaultPathKey === 'home' ? '发现菏泽最值得一去的地方' : '旅行者的真实体验与推荐' }}</p>
          </div>
          <div class="content-switcher">
            <button
              class="switch-btn"
              :class="{ active: defaultPathKey === 'home' }"
              @click="defaultPathKey = 'home'"
            >
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/>
                <polyline points="9 22 9 12 15 12 15 22"/>
              </svg>
              <span>景点</span>
            </button>
            <button
              class="switch-btn"
              :class="{ active: defaultPathKey === 'strategy' }"
              @click="defaultPathKey = 'strategy'"
            >
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M2 3h6a4 4 0 014 4v14a3 3 0 00-3-3H2z"/>
                <path d="M22 3h-6a4 4 0 00-4 4v14a3 3 0 013-3h7z"/>
              </svg>
              <span>攻略</span>
            </button>
            <div class="switch-indicator" :class="{ right: defaultPathKey === 'strategy' }"></div>
          </div>
        </div>
        <transition name="fade-slide" mode="out-in">
          <IndexScenicSpot v-if="defaultPathKey === 'home'" key="home" />
          <IndexStrategy v-else key="strategy" />
        </transition>
      </div>
    </section>

    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import gsap from 'gsap'
import { ScrollToPlugin } from 'gsap/ScrollToPlugin'
import IndexScenicSpot from './IndexScenicSpot.vue'
import IndexStrategy from './IndexStrategy.vue'
import Peony3D from '@/components/Peony3D.vue'
import AppFooter from '@/components/AppFooter.vue'
import { getToken } from '@/utils/storage'
import { tokenAuthApi } from '@/api/user-api'

gsap.registerPlugin(ScrollToPlugin)

const router = useRouter()
const isScrolled = ref(false)
const defaultPathKey = ref('home')
const themesSection = ref<HTMLElement>()

const heroStats = [
  { value: '1,237', label: '牡丹品种' },
  { value: '4,000+', label: '年建城史' },
  { value: '86', label: '红色遗址' },
  { value: '32', label: '国家级非遗' },
  { value: '9大', label: '色系花型' },
  { value: '200+', label: '非遗传承人' },
]

const navItems = [
  { key: 'home', label: '首页', route: null },
  { key: 'themes', label: '四色菏泽', route: '/viewer-themes' },
  { key: 'strategy', label: '景点攻略', route: '/viewer-scenic-spot-strategy-list' },
  { key: 'food', label: '特色美食', route: '/viewer-food' },
]

const categories = [
  {
    key: 'home',
    icon: '🏯',
    title: '古城遗韵',
    pattern: '曹州古城',
    desc: '千年曹州，古韵悠长，探寻历史深处的文化印记',
    accent: '#C49A6C',
    gradient: 'linear-gradient(135deg, #2C1810 0%, #5C3A28 50%, #3E2418 100%)',
  },
  {
    key: 'home',
    icon: '🌺',
    title: '牡丹之都',
    pattern: '国色天香',
    desc: '唯有牡丹真国色，花开时节动京城',
    accent: '#E38995',
    gradient: 'linear-gradient(135deg, #5C1A28 0%, #A61B2E 50%, #7A1220 100%)',
  },
  {
    key: 'home',
    icon: '⭐',
    title: '红色之旅',
    pattern: '革命圣地',
    desc: '革命老区，红色热土，追寻先辈的光辉足迹',
    accent: '#D4545A',
    gradient: 'linear-gradient(135deg, #1A1A1A 0%, #3A1A1A 50%, #2A0A0A 100%)',
  },
  {
    key: 'strategy',
    icon: '🎨',
    title: '非遗传承',
    pattern: '匠心独运',
    desc: '菏泽面塑、曹州剪纸，匠心独运的民间艺术',
    accent: '#7AB87A',
    gradient: 'linear-gradient(135deg, #1A2A1A 0%, #2A4A2A 50%, #1A3A1A 100%)',
  },
]

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

const scrollToTop = () => {
  gsap.to(window, { scrollTo: 0, duration: 1, ease: 'power3.inOut' })
}

const scrollToThemes = () => {
  if (themesSection.value) {
    gsap.to(window, { scrollTo: { y: themesSection.value, offsetY: 0 }, duration: 1.2, ease: 'power3.inOut' })
  }
}

const navItemClick = (key: string) => {
  const item = navItems.find(n => n.key === key)
  if (item?.route) {
    router.push(item.route)
    return
  }
  defaultPathKey.value = key
  const contentEl = document.querySelector('.content-section')
  if (contentEl) {
    gsap.to(window, { scrollTo: { y: contentEl, offsetY: 80 }, duration: 1, ease: 'power3.inOut' })
  }
}

const handleScroll = () => {
  isScrolled.value = window.scrollY > 60
}

const playHeroAnimation = () => {
  const tl = gsap.timeline({ defaults: { ease: 'power3.out' } })
  tl.from('.hero-eyebrow', { y: 20, opacity: 0, duration: 0.6 })
    .from('.heading-line:first-child', { y: 60, opacity: 0, duration: 0.8 }, '-=0.3')
    .from('.heading-sub', { y: 40, opacity: 0, duration: 0.7 }, '-=0.4')
    .from('.hero-desc', { y: 20, opacity: 0, duration: 0.6 }, '-=0.3')
    .from('.hero-actions', { y: 20, opacity: 0, duration: 0.6 }, '-=0.3')
    .from('.peony-frame', { scale: 0.8, opacity: 0, duration: 1.2, ease: 'elastic.out(1, 0.6)' }, 0.3)
    .from('.hero-marquee', { y: 30, opacity: 0, duration: 0.6 }, '-=0.5')
}

const playShowcaseAnimation = () => {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          gsap.from('.showcase-card', {
            y: 80,
            opacity: 0,
            duration: 0.7,
            stagger: 0.12,
            ease: 'power3.out',
          })
          observer.unobserve(entry.target)
        }
      })
    },
    { threshold: 0.15 }
  )
  if (themesSection.value) observer.observe(themesSection.value)
}

const tokenAuth = async () => {
  const token = getToken()
  if (!token) return
  try {
    const { data } = await tokenAuthApi()
    if (data.role === 1) router.push('/admin')
    else if (data.role === 2) router.push('/user')
  } catch (error) {
    // not logged in
  }
}

onMounted(async () => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  playHeroAnimation()
  playShowcaseAnimation()
  await tokenAuth()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped lang="scss">
.viewer-layout {
  width: 100%;
  min-height: 100vh;
  background: #0A0A0A;
}

.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  height: 64px;
  transition: all 0.4s ease;
  background: transparent;

  &.scrolled {
    background: rgba(10, 10, 10, 0.85);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  }

  .nav-inner {
    max-width: 1400px;
    margin: 0 auto;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 48px;
  }

  .nav-logo {
    display: flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    transition: opacity 0.3s;

    &:hover { opacity: 0.8; }

    .logo-img {
      width: 36px;
      height: 36px;
      object-fit: contain;
      border-radius: 8px;
    }

    .logo-text {
      font-family: var(--font-serif);
      font-size: 20px;
      font-weight: 600;
      color: white;
      letter-spacing: 2px;
    }
  }

  .nav-links {
    display: flex;
    gap: 4px;
    list-style: none;
    padding: 0;
    margin: 0;

    li {
      font-size: 14px;
      font-weight: 500;
      color: rgba(255, 255, 255, 0.6);
      cursor: pointer;
      padding: 8px 20px;
      border-radius: 100px;
      transition: all 0.3s;
      letter-spacing: 1px;

      &:hover {
        color: white;
        background: rgba(255, 255, 255, 0.08);
      }

      &.active {
        background: var(--primary-color);
        color: white;
      }
    }
  }

  .nav-login-btn {
    font-size: 13px;
    font-weight: 600;
    color: white;
    padding: 8px 24px;
    border-radius: 100px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    cursor: pointer;
    transition: all 0.3s;
    letter-spacing: 1px;

    &:hover {
      background: white;
      color: var(--primary-color);
      border-color: white;
    }
  }
}

.hero-section {
  position: relative;
  width: 100%;
  min-height: 100vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;

  .hero-canvas {
    position: absolute;
    inset: 0;

    .hero-gradient {
      position: absolute;
      inset: 0;
      background: linear-gradient(160deg, #0A0A0A 0%, #1A0A0E 25%, #2A1018 50%, #1A0A0E 75%, #0A0A0A 100%);
    }

    .hero-mesh {
      position: absolute;
      inset: 0;
      background:
        radial-gradient(ellipse 70% 50% at 65% 35%, rgba(166, 27, 46, 0.18) 0%, transparent 70%),
        radial-gradient(ellipse 50% 70% at 25% 65%, rgba(122, 18, 32, 0.12) 0%, transparent 60%);
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
          50% { transform: translateY(-120px) scale(1.4); opacity: 0.3; }
        }
      }
    }
  }

  .hero-layout {
    position: relative;
    z-index: 2;
    flex: 1;
    display: flex;
    align-items: center;
    max-width: 1400px;
    width: 100%;
    margin: 0 auto;
    padding: 80px 48px 0;
    gap: 40px;
  }

  .hero-left {
    flex: 1;
    min-width: 0;

    .hero-eyebrow {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 6px 16px 6px 10px;
      background: rgba(166, 27, 46, 0.12);
      border: 1px solid rgba(166, 27, 46, 0.25);
      border-radius: 100px;
      margin-bottom: 28px;

      .eyebrow-dot {
        width: 6px;
        height: 6px;
        border-radius: 50%;
        background: var(--primary-color);
        box-shadow: 0 0 8px rgba(166, 27, 46, 0.5);
      }

      span:last-child {
        font-size: 12px;
        font-weight: 500;
        color: rgba(227, 137, 149, 0.9);
        letter-spacing: 2px;
      }
    }

    .hero-heading {
      margin: 0 0 24px;

      .heading-line {
        display: block;
        font-family: var(--font-serif);
        font-weight: 700;
        color: white;
        line-height: 1.15;

        &:first-child {
          font-size: clamp(48px, 7vw, 88px);
          letter-spacing: 12px;
        }

        &.heading-sub {
          font-size: clamp(22px, 3vw, 36px);
          font-weight: 400;
          color: rgba(255, 255, 255, 0.55);
          letter-spacing: 6px;
          margin-top: 8px;
        }
      }
    }

    .hero-desc {
      font-size: 16px;
      color: rgba(255, 255, 255, 0.35);
      letter-spacing: 6px;
      font-family: var(--font-serif);
      margin-bottom: 40px;
    }

    .hero-actions {
      display: flex;
      gap: 16px;
      align-items: center;

      .cta-primary {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        padding: 14px 32px;
        background: var(--primary-color);
        color: white;
        border-radius: 100px;
        font-size: 15px;
        font-weight: 600;
        letter-spacing: 2px;
        cursor: pointer;
        transition: all 0.3s;

        &:hover {
          background: var(--primary-light);
          transform: translateY(-2px);
          box-shadow: 0 12px 40px rgba(166, 27, 46, 0.35);
        }
      }

      .cta-secondary {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 14px 28px;
        background: transparent;
        color: rgba(255, 255, 255, 0.7);
        border: 1px solid rgba(255, 255, 255, 0.15);
        border-radius: 100px;
        font-size: 15px;
        font-weight: 500;
        letter-spacing: 1px;
        cursor: pointer;
        transition: all 0.3s;

        &:hover {
          background: rgba(255, 255, 255, 0.06);
          border-color: rgba(255, 255, 255, 0.3);
          color: white;
        }
      }
    }
  }

  .hero-right {
    flex-shrink: 0;
    width: 45%;
    max-width: 640px;
    transform: translateX(-25px);
    padding: 10px;

    .peony-frame {
      width: 100%;
      height: 70vh;
      min-height: 500px;
      max-height: 700px;
      border-radius: 32px;
      overflow: visible;
      border: 1px solid rgba(255, 255, 255, 0.06);
      background: rgba(255, 255, 255, 0.02);
      position: relative;
      z-index: 1;

      &::before {
        content: '';
        position: absolute;
        inset: -1px;
        border-radius: 32px;
        padding: 1px;
        background: linear-gradient(135deg, rgba(166, 27, 46, 0.3), transparent 50%, rgba(166, 27, 46, 0.1));
        -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        -webkit-mask-composite: xor;
        mask-composite: exclude;
        pointer-events: none;
        z-index: 1;
      }

      :deep(.peony-3d-container) {
        position: absolute;
        top: -45px;
        left: -150px;
        right: -150px;
        bottom: -45px;
        width: auto;
        height: auto;
        z-index: 3;
      }
    }
  }

  .hero-marquee {
    position: relative;
    z-index: 2;
    overflow: hidden;
    padding: 20px 0;
    border-top: 1px solid rgba(255, 255, 255, 0.04);

    .marquee-track {
      display: flex;
      animation: marqueeScroll 30s linear infinite;
      width: max-content;

      .marquee-item {
        display: flex;
        align-items: center;
        gap: 0;
        flex-shrink: 0;

        .marquee-stat {
          display: flex;
          align-items: center;
          gap: 8px;
          padding: 0 32px;
          white-space: nowrap;

          strong {
            font-size: 20px;
            font-weight: 700;
            font-family: var(--font-serif);
            color: white;
            letter-spacing: 1px;
          }

          span:nth-child(2) {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.35);
            letter-spacing: 1px;
          }

          .marquee-sep {
            font-size: 8px;
            color: rgba(166, 27, 46, 0.4);
            margin-left: 24px;
          }
        }
      }
    }

    @keyframes marqueeScroll {
      from { transform: translateX(0); }
      to { transform: translateX(-50%); }
    }
  }
}

.themes-showcase {
  padding: 80px 0 120px;
  background: linear-gradient(180deg, #0A0A0A 0%, #0F0A0C 40%, #1A0F14 70%, #2A1520 100%);
  position: relative;

  .showcase-inner {
    position: relative;
    z-index: 2;
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 48px;
  }

  .showcase-header {
    margin-bottom: 56px;

    .showcase-label {
      font-size: 11px;
      font-weight: 600;
      letter-spacing: 8px;
      color: rgba(166, 27, 46, 0.7);
      margin-bottom: 12px;
    }

    .showcase-title {
      font-family: var(--font-serif);
      font-size: clamp(36px, 4vw, 52px);
      font-weight: 700;
      letter-spacing: 8px;
      background: linear-gradient(135deg, #fff, rgba(255, 255, 255, 0.6));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
  }

  .showcase-scroll {
    overflow-x: auto;
    overflow-y: hidden;
    -webkit-overflow-scrolling: touch;
    scrollbar-width: none;
    padding-bottom: 8px;

    &::-webkit-scrollbar { display: none; }
  }

  .showcase-track {
    display: flex;
    gap: 24px;
    width: max-content;
  }

  .showcase-card {
    width: 320px;
    flex-shrink: 0;
    border-radius: 24px;
    overflow: hidden;
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.08);
    cursor: pointer;
    transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);

    &:hover {
      transform: translateY(-6px);
      border-color: var(--accent);
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);

      .card-visual .visual-rings .ring {
        border-color: rgba(255, 255, 255, 0.1);
      }

      .card-link {
        opacity: 1;
        transform: translateX(0);
      }
    }

    .card-visual {
      height: 220px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;

      .visual-rings {
        position: absolute;
        inset: 0;
        display: flex;
        align-items: center;
        justify-content: center;

        .ring {
          position: absolute;
          border-radius: 50%;
          border: 1px solid rgba(255, 255, 255, 0.05);
          transition: border-color 0.4s;

          &:first-child {
            width: 160px;
            height: 160px;
            animation: ringBreath 5s ease-in-out infinite;
          }

          &:last-child {
            width: 260px;
            height: 260px;
            animation: ringBreath 5s ease-in-out infinite 2.5s;
          }

          @keyframes ringBreath {
            0%, 100% { transform: scale(1); opacity: 0.4; }
            50% { transform: scale(1.08); opacity: 0.7; }
          }
        }
      }

      .visual-icon {
        font-size: 56px;
        z-index: 2;
        filter: drop-shadow(0 4px 16px rgba(0, 0, 0, 0.3));
      }

      .visual-label {
        font-size: 18px;
        color: rgba(255, 255, 255, 0.35);
        letter-spacing: 6px;
        z-index: 2;
        margin-top: 8px;
      }
    }

    .card-body {
      padding: 24px;

      .card-index {
        font-size: 36px;
        font-weight: 800;
        font-family: var(--font-serif);
        color: rgba(255, 255, 255, 0.06);
        line-height: 1;
        margin-bottom: -12px;
      }

      .card-title {
        font-family: var(--font-serif);
        font-size: 22px;
        font-weight: 600;
        color: rgba(255, 255, 255, 0.9);
        letter-spacing: 3px;
        margin-bottom: 10px;
      }

      .card-desc {
        font-size: 14px;
        color: rgba(255, 255, 255, 0.4);
        line-height: 1.7;
        letter-spacing: 0.5px;
        margin-bottom: 20px;
      }

      .card-link {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        font-size: 13px;
        font-weight: 600;
        color: var(--accent);
        letter-spacing: 1px;
        opacity: 0;
        transform: translateX(-8px);
        transition: all 0.3s;
      }
    }
  }
}

.content-section {
  padding: 100px 0 120px;
  background: var(--bg-color);
  border-radius: 40px 40px 0 0;
  margin-top: -40px;
  position: relative;
  z-index: 10;
  box-shadow: 0 -20px 60px rgba(0, 0, 0, 0.15);

  .content-inner {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 48px;
  }

  .content-header {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    margin-bottom: 48px;
    gap: 24px;

    .content-title-group {
      .content-title {
        font-family: var(--font-serif);
        font-size: 32px;
        font-weight: 700;
        color: var(--text-main);
        letter-spacing: 4px;
        margin-bottom: 6px;
      }

      .content-subtitle {
        font-size: 15px;
        color: var(--text-light);
        letter-spacing: 1px;
      }
    }

    .content-switcher {
      display: flex;
      position: relative;
      background: rgba(0, 0, 0, 0.04);
      border-radius: 100px;
      padding: 4px;
      gap: 2px;

      .switch-btn {
        display: flex;
        align-items: center;
        gap: 7px;
        padding: 10px 28px;
        border-radius: 100px;
        border: none;
        background: transparent;
        font-size: 14px;
        font-weight: 500;
        color: var(--text-light);
        cursor: pointer;
        transition: color 0.3s;
        letter-spacing: 1px;
        font-family: inherit;
        position: relative;
        z-index: 2;

        svg {
          transition: all 0.3s;
          opacity: 0.4;
        }

        &:hover {
          color: var(--text-main);

          svg { opacity: 0.7; }
        }

        &.active {
          color: white;

          svg { opacity: 1; }
        }
      }

      .switch-indicator {
        position: absolute;
        top: 4px;
        left: 4px;
        width: calc(50% - 5px);
        height: calc(100% - 8px);
        background: var(--primary-color);
        border-radius: 100px;
        transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1);
        z-index: 1;

        &.right {
          transform: translateX(calc(100% + 2px));
        }
      }
    }
  }
}

.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.3s ease;
}

.fade-slide-enter-from {
  opacity: 0;
  transform: translateY(16px);
}

.fade-slide-leave-to {
  opacity: 0;
  transform: translateY(-16px);
}

@media (max-width: 1024px) {
  .hero-section {
    .hero-layout {
      flex-direction: column;
      padding: 100px 32px 0;
      text-align: center;

      .hero-left {
        .hero-eyebrow { margin-left: auto; margin-right: auto; }
        .hero-actions { justify-content: center; }
      }

      .hero-right {
        width: 80%;
        max-width: 500px;

        .peony-frame {
          height: 50vh;
          min-height: 350px;
        }
      }
    }
  }

  .themes-showcase .showcase-inner { padding: 0 32px; }
  .content-section .content-inner { padding: 0 32px; }
}

@media (max-width: 768px) {
  .nav-bar {
    .nav-inner { padding: 0 20px; }
    .nav-links { display: none; }
    .nav-login-btn { font-size: 12px; padding: 7px 18px; }
  }

  .hero-section {
    .hero-layout {
      padding: 90px 20px 0;

      .hero-left {
        .hero-heading .heading-line:first-child {
          letter-spacing: 6px;
        }
        .hero-desc {
          font-size: 13px;
          letter-spacing: 3px;
        }
        .hero-actions {
          flex-direction: column;
          gap: 12px;

          .cta-primary, .cta-secondary {
            width: 100%;
            justify-content: center;
          }
        }
      }

      .hero-right {
        width: 100%;
        max-width: 360px;

        .peony-frame {
          height: 40vh;
          min-height: 280px;
          border-radius: 24px;
        }
      }
    }

    .hero-marquee .marquee-track .marquee-item .marquee-stat {
      padding: 0 20px;

      strong { font-size: 16px; }
      span:nth-child(2) { font-size: 11px; }
    }
  }

  .themes-showcase {
    padding: 80px 0;

    .showcase-inner { padding: 0 20px; }
    .showcase-card { width: 280px; }
  }

  .content-section {
    padding: 80px 0 100px;
    border-radius: 24px 24px 0 0;
    margin-top: -24px;

    .content-inner { padding: 0 20px; }

    .content-header {
      flex-direction: column;
      align-items: flex-start;

      .content-title { font-size: 24px; }
    }
  }
}
</style>
