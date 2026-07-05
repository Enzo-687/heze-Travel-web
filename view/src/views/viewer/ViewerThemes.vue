<template>
  <div class="themes-page">
    <nav class="themes-nav" :class="{ scrolled: isScrolled }" v-if="!isUserContext">
      <div class="nav-inner">
        <div class="nav-back" @click="$router.push('/viewer')">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
          </svg>
          <span>返回首页</span>
        </div>
        <div class="nav-indicators">
          <div
            v-for="(theme, i) in themes"
            :key="i"
            class="indicator"
            :class="{ active: activeIndex === i }"
            @click="scrollToSection(i)"
          >
            <span class="indicator-dot"></span>
            <span class="indicator-label">{{ theme.name }}</span>
          </div>
        </div>
      </div>
    </nav>

    <div class="hero-banner" v-if="!isUserContext">
      <div class="hero-bg-layers">
        <div class="hero-gradient"></div>
        <div class="hero-particles">
          <span v-for="n in 20" :key="n" class="particle" :style="particleStyle(n)"></span>
        </div>
      </div>
      <div class="hero-content">
        <div class="hero-eyebrow">DISCOVER HEZE</div>
        <h1 class="hero-title">
          <span class="title-char" v-for="(char, i) in '四色菏泽'" :key="i" :style="{ animationDelay: i * 0.1 + 's' }">{{ char }}</span>
        </h1>
        <p class="hero-subtitle">每一面 · 都值得探寻</p>
        <div class="hero-scroll" @click="scrollToSection(0)">
          <span>向下探索</span>
          <div class="scroll-arrow">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 5v14M19 12l-7 7-7-7"/>
            </svg>
          </div>
        </div>
      </div>
      <div class="hero-preview-strip">
        <div
          v-for="(theme, i) in themes"
          :key="i"
          class="preview-card"
          :style="{ background: theme.gradient }"
          @click="scrollToSection(i)"
        >
          <span class="preview-icon">{{ theme.icon }}</span>
          <span class="preview-name">{{ theme.name }}</span>
        </div>
      </div>
    </div>

    <section
      v-for="(theme, index) in themes"
      :key="index"
      class="theme-section"
      :class="[theme.key, { 'in-view': visibleSections.has(index) }]"
      :ref="el => sectionRefs[index] = el"
    >
      <div class="section-bg">
        <div class="bg-gradient" :style="{ background: theme.sectionGradient }"></div>
        <div class="bg-pattern" :style="{ backgroundImage: theme.patternBg }"></div>
        <div class="bg-glow" :style="{ background: theme.glowColor }"></div>
      </div>

      <div class="section-content">
        <div class="section-header" :class="{ 'from-left': index % 2 === 0, 'from-right': index % 2 === 1 }">
          <div class="theme-number">{{ String(index + 1).padStart(2, '0') }}</div>
          <div class="theme-badge">{{ theme.badge }}</div>
          <h2 class="theme-name">{{ theme.name }}</h2>
          <p class="theme-slogan">{{ theme.slogan }}</p>
          <div class="name-decoration">
            <span class="deco-line"></span>
            <span class="deco-icon">{{ theme.icon }}</span>
            <span class="deco-line"></span>
          </div>
        </div>

        <div class="section-body" :class="{ 'layout-reverse': index % 2 === 1 }">
          <div class="theme-visual-area">
            <div class="visual-main" :style="{ background: theme.gradient }">
              <div class="visual-icon-large">{{ theme.icon }}</div>
              <div class="visual-pattern">{{ theme.pattern }}</div>
              <div class="visual-rings">
                <span class="ring ring-1"></span>
                <span class="ring ring-2"></span>
                <span class="ring ring-3"></span>
              </div>
            </div>
            <div class="visual-stat-row">
              <div class="stat-item" v-for="(stat, si) in theme.stats" :key="si">
                <div class="stat-value">{{ stat.value }}</div>
                <div class="stat-label">{{ stat.label }}</div>
              </div>
            </div>
          </div>

          <div class="theme-detail-area">
            <p class="theme-description">{{ theme.description }}</p>

            <div class="highlights-grid">
              <div
                v-for="(hl, hi) in theme.highlights"
                :key="hi"
                class="highlight-card"
                :style="{ animationDelay: hi * 0.1 + 's' }"
              >
                <div class="hl-index">{{ String(hi + 1).padStart(2, '0') }}</div>
                <div class="hl-content">
                  <div class="hl-title">{{ hl.title }}</div>
                  <div class="hl-desc">{{ hl.desc }}</div>
                </div>
              </div>
            </div>

            <div class="theme-tags">
              <span
                v-for="(tag, ti) in theme.tags"
                :key="ti"
                class="theme-tag"
                :style="{ borderColor: theme.tagColor, color: theme.tagColor }"
              >
                {{ tag }}
              </span>
            </div>

            <div class="theme-cta" :style="{ background: theme.gradient }" @click="exploreTheme(theme.key)">
              <span>探索{{ theme.name }}</span>
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M5 12h14M12 5l7 7-7 7"/>
              </svg>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="themes-epilogue">
      <div class="epilogue-content">
        <div class="epilogue-icon">🏛️</div>
        <h2 class="epilogue-title">菏泽，不止一面</h2>
        <p class="epilogue-desc">四色交织，绘就千年曹州的壮美画卷。每一次到访，都是一场全新的发现之旅。</p>
        <div class="epilogue-cta" @click="$router.push('/viewer')">
          <span>返回首页</span>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M5 12h14M12 5l7 7-7 7"/>
          </svg>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const isScrolled = ref(false)
const isUserContext = computed(() => route.path.startsWith('/user/'))
const activeIndex = ref(0)
const visibleSections = ref(new Set<number>())
const sectionRefs = ref<HTMLElement[]>([])

const themes = [
  {
    key: 'ancient',
    name: '古城遗韵',
    badge: 'THEME 01',
    icon: '🏯',
    pattern: '曹州古城',
    slogan: '千年城垣 · 青砖黛瓦间尽是岁月',
    gradient: 'linear-gradient(135deg, #2C1810 0%, #5C3A28 50%, #3E2418 100%)',
    sectionGradient: 'linear-gradient(180deg, #0D0806 0%, #1A0F0A 40%, #0D0806 100%)',
    patternBg: 'radial-gradient(circle at 20% 50%, rgba(92, 58, 40, 0.15) 0%, transparent 50%)',
    glowColor: 'radial-gradient(ellipse 60% 40% at 70% 30%, rgba(139, 90, 43, 0.12) 0%, transparent 70%)',
    tagColor: '#C49A6C',
    description: '菏泽古称曹州，拥有数千年建城史。漫步古城街巷，青砖黛瓦间尽是岁月沉淀的痕迹。从曹州牡丹园到古城墙遗址，每一处都在诉说着这座城市的悠远故事。',
    highlights: [
      { title: '曹州古城墙遗址', desc: '千年城垣的沧桑印记' },
      { title: '百狮坊 · 百寿坊', desc: '清代石雕艺术巅峰' },
      { title: '菏泽市博物馆', desc: '珍藏曹州文明瑰宝' },
      { title: '冀鲁豫边区革命纪念馆', desc: '红色记忆永存' },
    ],
    stats: [
      { value: '4000+', label: '年建城史' },
      { value: '126', label: '处古迹遗址' },
      { value: '38', label: '座古建筑群' },
    ],
    tags: ['历史古迹', '人文景观', '古建筑', '文化探秘'],
  },
  {
    key: 'peony',
    name: '牡丹之都',
    badge: 'THEME 02',
    icon: '🌺',
    pattern: '国色天香',
    slogan: '唯有牡丹真国色 · 花开时节动京城',
    gradient: 'linear-gradient(135deg, #5C1A28 0%, #A61B2E 50%, #7A1220 100%)',
    sectionGradient: 'linear-gradient(180deg, #0D0608 0%, #1A0A0E 40%, #0D0608 100%)',
    patternBg: 'radial-gradient(circle at 80% 40%, rgba(166, 27, 46, 0.12) 0%, transparent 50%)',
    glowColor: 'radial-gradient(ellipse 50% 50% at 30% 60%, rgba(196, 54, 74, 0.1) 0%, transparent 70%)',
    tagColor: '#E38995',
    description: '菏泽是世界最大的牡丹种植基地，拥有九大色系、十大花型、1237个品种。每年四月牡丹花开时节，万紫千红、国色天香，吸引全球游客慕名而来。',
    highlights: [
      { title: '曹州牡丹园', desc: '世界最大牡丹观赏基地' },
      { title: '百花园', desc: '九大色系汇聚一园' },
      { title: '牡丹文化节', desc: '每年4月盛大开幕' },
      { title: '牡丹产业', desc: '从观赏到深加工全产业链' },
    ],
    stats: [
      { value: '1237', label: '个牡丹品种' },
      { value: '9大', label: '色系花型' },
      { value: '100万+', label: '亩种植面积' },
    ],
    tags: ['牡丹观赏', '花卉摄影', '文化节庆', '国花之旅'],
  },
  {
    key: 'red',
    name: '红色之旅',
    badge: 'THEME 03',
    icon: '⭐',
    pattern: '革命圣地',
    slogan: '革命老区 · 红色热土 · 薪火相传',
    gradient: 'linear-gradient(135deg, #1A1A1A 0%, #3A1A1A 50%, #2A0A0A 100%)',
    sectionGradient: 'linear-gradient(180deg, #0A0A0A 0%, #120808 40%, #0A0A0A 100%)',
    patternBg: 'radial-gradient(circle at 50% 60%, rgba(166, 27, 46, 0.08) 0%, transparent 50%)',
    glowColor: 'radial-gradient(ellipse 60% 40% at 60% 40%, rgba(166, 27, 46, 0.08) 0%, transparent 70%)',
    tagColor: '#D4545A',
    description: '菏泽是冀鲁豫边区革命根据地的中心，无数革命先烈在此浴血奋战。红色遗址遍布城乡，革命精神薪火相传，是开展爱国主义教育和红色旅游的重要目的地。',
    highlights: [
      { title: '冀鲁豫边区革命纪念馆', desc: '铭记革命历史' },
      { title: '鲁西南战役纪念馆', desc: '解放战争重要战场' },
      { title: '湖西革命烈士陵园', desc: '缅怀革命先烈' },
      { title: '红色文化村', desc: '体验革命岁月生活' },
    ],
    stats: [
      { value: '86', label: '处红色遗址' },
      { value: '12', label: '座纪念馆' },
      { value: '3大', label: '战役纪念地' },
    ],
    tags: ['红色教育', '革命遗址', '爱国主义', '历史研学'],
  },
  {
    key: 'heritage',
    name: '非遗传承',
    badge: 'THEME 04',
    icon: '🎭',
    pattern: '匠心独运',
    slogan: '指尖上的民间艺术 · 百年匠心薪火传',
    gradient: 'linear-gradient(135deg, #1A2A1A 0%, #2A4A2A 50%, #1A3A1A 100%)',
    sectionGradient: 'linear-gradient(180deg, #060D06 0%, #0E1A0E 40%, #060D06 100%)',
    patternBg: 'radial-gradient(circle at 30% 50%, rgba(42, 74, 42, 0.12) 0%, transparent 50%)',
    glowColor: 'radial-gradient(ellipse 50% 50% at 70% 50%, rgba(74, 140, 74, 0.08) 0%, transparent 70%)',
    tagColor: '#7AB87A',
    description: '菏泽非物质文化遗产丰富多彩，涵盖传统戏剧、手工技艺、民俗活动等多个门类。从菏泽弦索乐到曹州面人，每一项非遗都凝聚着匠人的智慧与坚守。',
    highlights: [
      { title: '菏泽弦索乐', desc: '国家级非遗传统音乐' },
      { title: '曹州面人', desc: '指尖上的民间艺术' },
      { title: '菏泽木版年画', desc: '百年传承的民间美术' },
      { title: '鄄城砖塑', desc: '独特的建筑装饰艺术' },
    ],
    stats: [
      { value: '32', label: '项国家级非遗' },
      { value: '68', label: '项省级非遗' },
      { value: '200+', label: '位传承人' },
    ],
    tags: ['非遗体验', '传统手艺', '民间艺术', '文化传承'],
  },
]

const particleStyle = (n: number) => {
  const x = Math.random() * 100
  const y = Math.random() * 100
  const size = 2 + Math.random() * 4
  const duration = 10 + Math.random() * 20
  const delay = Math.random() * 10
  return {
    left: `${x}%`,
    top: `${y}%`,
    width: `${size}px`,
    height: `${size}px`,
    animationDuration: `${duration}s`,
    animationDelay: `${delay}s`,
  }
}

const scrollToSection = (index: number) => {
  const el = sectionRefs.value[index]
  if (el) {
    el.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }
}

const exploreTheme = (key: string) => {
  router.push('/viewer')
}

const handleScroll = () => {
  isScrolled.value = window.scrollY > 60

  let current = 0
  sectionRefs.value.forEach((el, i) => {
    if (el) {
      const rect = el.getBoundingClientRect()
      if (rect.top <= window.innerHeight * 0.5) {
        current = i
      }
    }
  })
  activeIndex.value = current
}

let observer: IntersectionObserver

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })

  observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        const index = sectionRefs.value.indexOf(entry.target as HTMLElement)
        if (index !== -1) {
          if (entry.isIntersecting) {
            visibleSections.value.add(index)
          }
        }
      })
    },
    { threshold: 0.15 }
  )

  sectionRefs.value.forEach((el) => {
    if (el) observer.observe(el)
  })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  if (observer) observer.disconnect()
})
</script>

<style lang="scss" scoped>
.themes-page {
  width: 100%;
  background: #0A0A0A;
  color: #fff;
  overflow-x: hidden;
}

.themes-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  height: 64px;
  background: transparent;
  transition: all 0.4s ease;

  &.scrolled {
    background: rgba(10, 10, 10, 0.9);
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
    padding: 0 40px;
  }

  .nav-back {
    display: flex;
    align-items: center;
    gap: 8px;
    color: rgba(255, 255, 255, 0.7);
    cursor: pointer;
    transition: color 0.3s;
    font-size: 14px;

    &:hover {
      color: #fff;
    }
  }

  .nav-indicators {
    display: flex;
    gap: 6px;
  }

  .indicator {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 6px 16px;
    border-radius: 100px;
    cursor: pointer;
    transition: all 0.3s;

    .indicator-dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.3);
      transition: all 0.3s;
    }

    .indicator-label {
      font-size: 13px;
      color: rgba(255, 255, 255, 0.4);
      transition: color 0.3s;
      max-width: 0;
      overflow: hidden;
      white-space: nowrap;
      transition: all 0.3s;
    }

    &.active {
      background: rgba(255, 255, 255, 0.08);

      .indicator-dot {
        background: var(--primary-color);
        box-shadow: 0 0 8px rgba(166, 27, 46, 0.5);
      }

      .indicator-label {
        color: rgba(255, 255, 255, 0.9);
        max-width: 80px;
      }
    }

    &:hover {
      background: rgba(255, 255, 255, 0.05);
    }
  }
}

.hero-banner {
  position: relative;
  width: 100%;
  height: 100vh;
  min-height: 700px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;

  .hero-bg-layers {
    position: absolute;
    inset: 0;

    .hero-gradient {
      position: absolute;
      inset: 0;
      background: linear-gradient(135deg, #0A0A0A 0%, #1A0A0E 30%, #2A1018 50%, #0A0A0A 100%);
    }

    .hero-particles {
      position: absolute;
      inset: 0;

      .particle {
        position: absolute;
        border-radius: 50%;
        background: rgba(166, 27, 46, 0.3);
        animation: particleFloat linear infinite;

        @keyframes particleFloat {
          0%, 100% {
            transform: translateY(0) scale(1);
            opacity: 0;
          }
          10% { opacity: 1; }
          90% { opacity: 1; }
          50% {
            transform: translateY(-100px) scale(1.5);
            opacity: 0.6;
          }
        }
      }
    }
  }

  .hero-content {
    position: relative;
    z-index: 2;
    text-align: center;

    .hero-eyebrow {
      font-size: 12px;
      font-weight: 600;
      letter-spacing: 8px;
      color: rgba(166, 27, 46, 0.8);
      margin-bottom: 32px;
    }

    .hero-title {
      font-family: var(--font-serif);
      font-size: clamp(56px, 10vw, 120px);
      font-weight: 700;
      letter-spacing: 16px;
      margin-bottom: 24px;
      line-height: 1.1;

      .title-char {
        display: inline-block;
        animation: charReveal 0.8s cubic-bezier(0.16, 1, 0.3, 1) both;

        @keyframes charReveal {
          from {
            opacity: 0;
            transform: translateY(60px) rotateX(40deg);
          }
          to {
            opacity: 1;
            transform: translateY(0) rotateX(0);
          }
        }
      }
    }

    .hero-subtitle {
      font-size: 20px;
      color: rgba(255, 255, 255, 0.4);
      letter-spacing: 8px;
      font-family: var(--font-serif);
      margin-bottom: 60px;
    }

    .hero-scroll {
      display: inline-flex;
      flex-direction: column;
      align-items: center;
      gap: 12px;
      cursor: pointer;
      color: rgba(255, 255, 255, 0.4);
      font-size: 13px;
      letter-spacing: 3px;
      transition: color 0.3s;

      &:hover {
        color: rgba(255, 255, 255, 0.8);
      }

      .scroll-arrow {
        animation: scrollBounce 2s ease-in-out infinite;

        @keyframes scrollBounce {
          0%, 100% { transform: translateY(0); }
          50% { transform: translateY(8px); }
        }
      }
    }
  }

  .hero-preview-strip {
    position: absolute;
    bottom: 60px;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    gap: 16px;
    z-index: 2;

    .preview-card {
      width: 140px;
      height: 80px;
      border-radius: 12px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 6px;
      cursor: pointer;
      transition: all 0.3s;
      border: 1px solid rgba(255, 255, 255, 0.08);
      backdrop-filter: blur(10px);

      .preview-icon {
        font-size: 24px;
      }

      .preview-name {
        font-size: 12px;
        color: rgba(255, 255, 255, 0.7);
        letter-spacing: 2px;
      }

      &:hover {
        transform: translateY(-4px);
        border-color: rgba(255, 255, 255, 0.2);
        box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
      }
    }
  }
}

.theme-section {
  position: relative;
  min-height: 100vh;
  padding: 120px 0;
  overflow: hidden;

  .section-bg {
    position: absolute;
    inset: 0;
    pointer-events: none;

    .bg-gradient {
      position: absolute;
      inset: 0;
    }

    .bg-pattern {
      position: absolute;
      inset: 0;
      opacity: 0.5;
    }

    .bg-glow {
      position: absolute;
      inset: 0;
    }
  }

  .section-content {
    position: relative;
    z-index: 2;
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 40px;
  }

  .section-header {
    text-align: center;
    margin-bottom: 80px;
    opacity: 0;
    transform: translateY(40px);
    transition: all 0.8s cubic-bezier(0.16, 1, 0.3, 1);

    &.from-left {
      transform: translateX(-40px) translateY(20px);
    }

    &.from-right {
      transform: translateX(40px) translateY(20px);
    }

    .theme-number {
      font-size: clamp(80px, 12vw, 160px);
      font-weight: 800;
      color: rgba(255, 255, 255, 0.03);
      line-height: 1;
      margin-bottom: -40px;
      font-family: var(--font-serif);
      letter-spacing: -4px;
    }

    .theme-badge {
      font-size: 11px;
      font-weight: 600;
      letter-spacing: 6px;
      color: rgba(255, 255, 255, 0.3);
      margin-bottom: 16px;
    }

    .theme-name {
      font-family: var(--font-serif);
      font-size: clamp(36px, 5vw, 56px);
      font-weight: 700;
      letter-spacing: 8px;
      margin-bottom: 16px;
      background: linear-gradient(135deg, #fff 0%, rgba(255, 255, 255, 0.7) 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .theme-slogan {
      font-size: 16px;
      color: rgba(255, 255, 255, 0.4);
      letter-spacing: 4px;
      font-family: var(--font-serif);
      margin-bottom: 24px;
    }

    .name-decoration {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 16px;

      .deco-line {
        width: 40px;
        height: 1px;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
      }

      .deco-icon {
        font-size: 20px;
      }
    }
  }

  &.in-view .section-header {
    opacity: 1;
    transform: translateY(0) translateX(0);
  }

  .section-body {
    display: flex;
    gap: 60px;
    align-items: flex-start;

    &.layout-reverse {
      flex-direction: row-reverse;
    }

    .theme-visual-area {
      flex-shrink: 0;
      width: 420px;

      .visual-main {
        width: 100%;
        height: 400px;
        border-radius: 24px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        position: relative;
        overflow: hidden;
        border: 1px solid rgba(255, 255, 255, 0.06);

        .visual-icon-large {
          font-size: 80px;
          margin-bottom: 16px;
          filter: drop-shadow(0 4px 20px rgba(0, 0, 0, 0.3));
          z-index: 2;
        }

        .visual-pattern {
          font-size: 24px;
          color: rgba(255, 255, 255, 0.4);
          letter-spacing: 8px;
          z-index: 2;
        }

        .visual-rings {
          position: absolute;
          inset: 0;
          display: flex;
          align-items: center;
          justify-content: center;

          .ring {
            position: absolute;
            border-radius: 50%;
            border: 1px solid rgba(255, 255, 255, 0.04);
          }

          .ring-1 {
            width: 200px;
            height: 200px;
            animation: ringPulse 6s ease-in-out infinite;
          }

          .ring-2 {
            width: 300px;
            height: 300px;
            animation: ringPulse 6s ease-in-out infinite 2s;
          }

          .ring-3 {
            width: 400px;
            height: 400px;
            animation: ringPulse 6s ease-in-out infinite 4s;
          }

          @keyframes ringPulse {
            0%, 100% { transform: scale(1); opacity: 0.3; }
            50% { transform: scale(1.1); opacity: 0.6; }
          }
        }
      }

      .visual-stat-row {
        display: flex;
        gap: 12px;
        margin-top: 16px;

        .stat-item {
          flex: 1;
          background: rgba(255, 255, 255, 0.03);
          border: 1px solid rgba(255, 255, 255, 0.06);
          border-radius: 16px;
          padding: 20px 16px;
          text-align: center;

          .stat-value {
            font-size: 28px;
            font-weight: 700;
            font-family: var(--font-serif);
            margin-bottom: 4px;
            background: linear-gradient(135deg, #fff, rgba(255, 255, 255, 0.6));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
          }

          .stat-label {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.35);
            letter-spacing: 1px;
          }
        }
      }
    }

    .theme-detail-area {
      flex: 1;

      .theme-description {
        font-size: 16px;
        color: rgba(255, 255, 255, 0.55);
        line-height: 2;
        margin-bottom: 40px;
        letter-spacing: 0.5px;
      }

      .highlights-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
        margin-bottom: 32px;

        .highlight-card {
          display: flex;
          gap: 16px;
          padding: 20px;
          background: rgba(255, 255, 255, 0.02);
          border: 1px solid rgba(255, 255, 255, 0.05);
          border-radius: 16px;
          transition: all 0.3s;

          &:hover {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
          }

          .hl-index {
            font-size: 24px;
            font-weight: 700;
            color: rgba(255, 255, 255, 0.08);
            font-family: var(--font-serif);
            flex-shrink: 0;
            line-height: 1;
          }

          .hl-content {
            .hl-title {
              font-size: 15px;
              font-weight: 600;
              color: rgba(255, 255, 255, 0.85);
              margin-bottom: 4px;
              letter-spacing: 1px;
            }

            .hl-desc {
              font-size: 13px;
              color: rgba(255, 255, 255, 0.35);
            }
          }
        }
      }

      .theme-tags {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
        margin-bottom: 32px;

        .theme-tag {
          padding: 6px 18px;
          border-radius: 100px;
          font-size: 13px;
          letter-spacing: 1px;
          border: 1px solid;
          background: transparent;
          transition: all 0.3s;

          &:hover {
            background: rgba(255, 255, 255, 0.05);
          }
        }
      }

      .theme-cta {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        padding: 14px 36px;
        border-radius: 100px;
        font-size: 15px;
        font-weight: 600;
        letter-spacing: 2px;
        cursor: pointer;
        transition: all 0.3s;
        color: #fff;

        &:hover {
          transform: translateY(-2px);
          box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
        }
      }
    }
  }

  &.in-view .section-body {
    .theme-visual-area {
      animation: slideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.2s both;
    }

    .theme-detail-area {
      animation: slideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.4s both;
    }
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(40px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.themes-epilogue {
  position: relative;
  padding: 160px 0;
  text-align: center;
  background: linear-gradient(180deg, #0A0A0A 0%, #120808 50%, #0A0A0A 100%);

  .epilogue-content {
    max-width: 600px;
    margin: 0 auto;

    .epilogue-icon {
      font-size: 48px;
      margin-bottom: 32px;
    }

    .epilogue-title {
      font-family: var(--font-serif);
      font-size: 40px;
      font-weight: 700;
      letter-spacing: 6px;
      margin-bottom: 20px;
      background: linear-gradient(135deg, #fff, rgba(255, 255, 255, 0.6));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .epilogue-desc {
      font-size: 16px;
      color: rgba(255, 255, 255, 0.4);
      line-height: 2;
      letter-spacing: 1px;
      margin-bottom: 48px;
    }

    .epilogue-cta {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 14px 36px;
      border-radius: 100px;
      font-size: 15px;
      font-weight: 600;
      letter-spacing: 2px;
      cursor: pointer;
      transition: all 0.3s;
      color: #fff;
      background: var(--primary-gradient);

      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 40px rgba(166, 27, 46, 0.4);
      }
    }
  }
}

@media (max-width: 1024px) {
  .themes-nav .nav-indicators {
    display: none;
  }

  .hero-banner .hero-preview-strip {
    flex-wrap: wrap;
    justify-content: center;
    bottom: 40px;
    padding: 0 20px;

    .preview-card {
      width: 100px;
      height: 60px;

      .preview-icon {
        font-size: 18px;
      }

      .preview-name {
        font-size: 10px;
      }
    }
  }

  .theme-section {
    padding: 80px 0;

    .section-content {
      padding: 0 24px;
    }

    .section-body,
    .section-body.layout-reverse {
      flex-direction: column;

      .theme-visual-area {
        width: 100%;

        .visual-main {
          height: 280px;
        }

        .visual-stat-row {
          .stat-item {
            padding: 16px 12px;

            .stat-value {
              font-size: 22px;
            }
          }
        }
      }

      .theme-detail-area .highlights-grid {
        grid-template-columns: 1fr;
      }
    }
  }

  .themes-epilogue {
    padding: 100px 24px;

    .epilogue-title {
      font-size: 28px;
    }
  }
}

@media (max-width: 768px) {
  .hero-banner {
    .hero-content {
      .hero-title {
        letter-spacing: 8px;
      }

      .hero-subtitle {
        font-size: 14px;
        letter-spacing: 3px;
      }
    }

    .hero-preview-strip {
      display: none;
    }
  }

  .theme-section .section-header {
    .theme-number {
      font-size: 80px;
    }

    .theme-name {
      letter-spacing: 4px;
    }
  }
}
</style>
