<template>
  <footer class="app-footer">
    <!-- 牡丹装饰背景 -->
    <div class="peony-decoration">
      <svg viewBox="0 0 400 400" class="peony-svg" preserveAspectRatio="xMidYMid slice">
        <defs>
          <radialGradient id="footerPeonyGrad" cx="50%" cy="40%" r="50%">
            <stop offset="0%" style="stop-color:#C4364A;stop-opacity:0.15" />
            <stop offset="100%" style="stop-color:#7A1220;stop-opacity:0.03" />
          </radialGradient>
        </defs>
        <g opacity="0.5">
          <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#footerPeonyGrad)" transform="rotate(0 200 200)" />
          <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#footerPeonyGrad)" transform="rotate(45 200 200)" />
          <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#footerPeonyGrad)" transform="rotate(90 200 200)" />
          <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#footerPeonyGrad)" transform="rotate(135 200 200)" />
          <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#footerPeonyGrad)" transform="rotate(22.5 200 200)" opacity="0.5" />
          <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#footerPeonyGrad)" transform="rotate(67.5 200 200)" opacity="0.5" />
        </g>
        <circle cx="200" cy="200" r="20" fill="#E38995" opacity="0.1" />
      </svg>
    </div>

    <div class="footer-container">
      <!-- 上部：品牌 + 链接网格 -->
      <div class="footer-top">
        <!-- 品牌区 -->
        <div class="footer-brand-section">
          <div class="brand-header" @click="goHome">
            <img src="/logo.png" alt="菏你同游" class="logo-img" />
            <div class="brand-text">
              <h3 class="brand-name">菏你同游</h3>
              <p class="brand-slogan">在线旅游平台</p>
            </div>
          </div>
          <p class="brand-desc">
            千年古韵 · 牡丹花城 · 红色热土 · 非遗传承<br />
            探索菏泽之美，从这里开始。
          </p>
          <div class="brand-contact">
            <div class="contact-item">
              <el-icon><Phone /></el-icon>
              <span>0530-12345678</span>
            </div>
            <div class="contact-item">
              <el-icon><Message /></el-icon>
              <span>contact@hetongyou.com</span>
            </div>
            <div class="contact-item">
              <el-icon><Location /></el-icon>
              <span>山东省菏泽市牡丹区</span>
            </div>
          </div>
        </div>

        <!-- 链接网格 -->
        <div class="footer-links-grid">
          <div class="link-group">
            <h4 class="link-title">探索发现</h4>
            <ul class="link-list">
              <li><a @click="navTo('/viewer')">首页推荐</a></li>
              <li><a @click="navExplore('/viewer-scenic-spot-search-list', '/user/home-scenic-spot-list')">景点大全</a></li>
              <li><a @click="navExplore('/viewer-scenic-spot-strategy-list', '/user/home-scenic-spot-strategy-list-top')">旅游攻略</a></li>
              <li><a @click="navExplore('/viewer-food', '/user/user-food')">特色美食</a></li>
            </ul>
          </div>
          <div class="link-group">
            <h4 class="link-title">用户服务</h4>
            <ul class="link-list">
              <li v-if="!isLoggedIn"><a @click="navTo('/login')">登录 / 注册</a></li>
              <li v-if="isLoggedIn"><a @click="handleProfile">个人中心</a></li>
              <li v-if="isLoggedIn"><a @click="navTo('/user/my-collection')">我的收藏</a></li>
              <li v-if="isLoggedIn"><a @click="navTo('/user/scenic-spot-order-ticket-list')">我的订单</a></li>
              <li v-if="!isLoggedIn"><a @click="handleAuthLink('/user')">个人中心</a></li>
              <li v-if="!isLoggedIn"><a @click="handleAuthLink('/user/my-collection')">我的收藏</a></li>
              <li v-if="!isLoggedIn"><a @click="handleAuthLink('/user/scenic-spot-order-ticket-list')">我的订单</a></li>
            </ul>
          </div>
          <div class="link-group">
            <h4 class="link-title">关于我们</h4>
            <ul class="link-list">
              <li><a @click="navTo('/about')">平台简介</a></li>
              <li><a @click="navTo('/contact')">联系我们</a></li>
              <li><a @click="navTo('/join')">加入我们</a></li>
              <li><a @click="navTo('/partners')">合作伙伴</a></li>
            </ul>
          </div>
          <div class="link-group">
            <h4 class="link-title">法律条款</h4>
            <ul class="link-list">
              <li><a @click="navTo('/privacy')">隐私政策</a></li>
              <li><a @click="navTo('/terms')">使用条款</a></li>
              <li><a @click="navTo('/disclaimer')">免责声明</a></li>
              <li><a @click="navTo('/copyright')">版权声明</a></li>
            </ul>
          </div>
        </div>
      </div>

      <!-- 分隔线 -->
      <div class="footer-divider">
        <span class="divider-peony">🌸</span>
      </div>

      <!-- 下部：版权 + 备案 -->
      <div class="footer-bottom">
        <div class="copyright-row">
          <p class="copyright-text">
            <span class="peony-icon">🌸</span>
            &copy; {{ currentYear }} 菏你同游 版权所有
          </p>
          <div class="legal-links">
            <a @click="navTo('/privacy')">隐私政策</a>
            <span class="divider">|</span>
            <a @click="navTo('/terms')">使用条款</a>
            <span class="divider">|</span>
            <a @click="navTo('/sitemap')">网站地图</a>
          </div>
        </div>
        <p class="beian-text">
          鲁ICP备xxxxxxxx号-1 | 增值电信业务经营许可证：鲁B2-xxxxxxxx
        </p>
      </div>
    </div>

    <!-- 个人资料弹窗 -->
    <el-dialog title="个人资料" v-model="profileVisible" width="480px" destroy-on-close>
      <div class="profile-card" v-if="userInfo">
        <div class="profile-avatar-section">
          <el-avatar :size="80" :src="userInfo.avatar" />
          <h4 class="profile-username">{{ userInfo.username }}</h4>
          <p class="profile-account">@{{ userInfo.account }}</p>
        </div>
        <div class="profile-info-section">
          <div class="info-row">
            <span class="info-label">性别</span>
            <span class="info-value">{{ userInfo.gender === 1 ? '女' : userInfo.gender === 2 ? '男' : '未设置' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">邮箱</span>
            <span class="info-value">{{ userInfo.email || '未设置' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">手机号</span>
            <span class="info-value">{{ userInfo.phone || '未设置' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">生日</span>
            <span class="info-value">{{ userInfo.birthday || '未设置' }}</span>
          </div>
        </div>
      </div>
    </el-dialog>
  </footer>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Phone, Message, Location } from '@element-plus/icons-vue'
import { getToken } from '@/utils/storage'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const currentYear = ref(new Date().getFullYear())
const profileVisible = ref(false)

const isLoggedIn = computed(() => !!getToken())
const userInfo = computed(() => userStore.userInfo)

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const goHome = () => {
  scrollToTop()
  router.push('/viewer')
}

/**
 * 通用导航：跳转后滚动到页面顶部
 */
const navTo = (path: string) => {
  scrollToTop()
  router.push(path)
}

/**
 * 根据登录状态选择不同路径的导航
 * @param guestPath 游客路径
 * @param userPath 已登录用户路径
 */
const navExplore = (guestPath: string, userPath: string) => {
  scrollToTop()
  router.push(isLoggedIn.value ? userPath : guestPath)
}

/**
 * 需要登录才能访问的链接
 * - 已登录：正常跳转
 * - 未登录：保存当前路径，跳转登录页，登录后返回
 */
const handleAuthLink = (path: string) => {
  if (isLoggedIn.value) {
    scrollToTop()
    router.push(path)
  } else {
    const currentPath = route.fullPath
    if (currentPath !== '/login') {
      localStorage.setItem('redirectAfterLogin', currentPath)
    }
    ElMessage.warning('请先登录')
    router.push('/login')
  }
}

/**
 * 个人中心：先滚动到页面顶部，再弹出个人资料卡片
 */
const handleProfile = () => {
  scrollToTop()
  profileVisible.value = true
}
</script>

<style scoped lang="scss">
.app-footer {
  position: relative;
  background: linear-gradient(135deg, #0A0A0A 0%, #1A0A0E 30%, #2A1018 60%, #0A0A0A 100%);
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
  line-height: 1.6;
  overflow: hidden;
}

.peony-decoration {
  position: absolute;
  right: -5%;
  top: 50%;
  transform: translateY(-50%);
  width: 500px;
  height: 500px;
  opacity: 0.6;
  pointer-events: none;

  .peony-svg {
    width: 100%;
    height: 100%;
  }
}

.footer-container {
  position: relative;
  z-index: 1;
  max-width: 1280px;
  margin: 0 auto;
  padding: 60px 40px 30px;
}

.footer-top {
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: 60px;
  margin-bottom: 40px;
}

.footer-brand-section {
  .brand-header {
    display: flex;
    align-items: center;
    gap: 14px;
    cursor: pointer;
    margin-bottom: 20px;
    transition: opacity 0.3s;

    &:hover {
      opacity: 0.85;
    }
  }

  .logo-img {
    width: 44px;
    height: 44px;
    object-fit: contain;
    border-radius: 10px;
    flex-shrink: 0;
    box-shadow: 0 4px 20px rgba(166, 27, 46, 0.4);
  }

  .brand-text {
    .brand-name {
      font-family: var(--font-serif, 'Noto Serif SC', serif);
      font-size: 20px;
      font-weight: 600;
      color: white;
      margin: 0;
      letter-spacing: 2px;
    }

    .brand-slogan {
      font-size: 13px;
      color: rgba(227, 137, 149, 0.6);
      margin: 4px 0 0;
    }
  }

  .brand-desc {
    font-size: 13px;
    color: rgba(255, 255, 255, 0.5);
    line-height: 1.8;
    margin-bottom: 24px;
  }

  .brand-contact {
    display: flex;
    flex-direction: column;
    gap: 10px;

    .contact-item {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 13px;
      color: rgba(255, 255, 255, 0.6);
      transition: color 0.25s;

      &:hover {
        color: rgba(255, 255, 255, 0.85);
      }

      .el-icon {
        font-size: 15px;
        color: #C4364A;
      }
    }
  }
}

.footer-links-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 30px;
}

.link-group {
  .link-title {
    font-size: 15px;
    font-weight: 600;
    color: white;
    margin: 0 0 18px;
    letter-spacing: 1px;
    position: relative;
    padding-bottom: 10px;

    &::after {
      content: '';
      position: absolute;
      left: 0;
      bottom: 0;
      width: 24px;
      height: 2px;
      background: linear-gradient(90deg, #A61B2E, #C4364A);
      border-radius: 1px;
    }
  }

  .link-list {
    list-style: none;
    padding: 0;
    margin: 0;

    li {
      margin-bottom: 10px;

      a {
        color: rgba(255, 255, 255, 0.55);
        text-decoration: none;
        font-size: 13px;
        cursor: pointer;
        transition: all 0.25s ease;
        display: inline-flex;
        align-items: center;
        gap: 6px;

        &::before {
          content: '';
          width: 0;
          height: 0;
          border-style: solid;
          border-width: 3px 0 3px 4px;
          border-color: transparent transparent transparent rgba(196, 54, 74, 0.7);
          transition: all 0.25s;
          opacity: 0;
        }

        &:hover {
          color: #E38995;
          transform: translateX(4px);

          &::before {
            opacity: 1;
          }
        }
      }
    }
  }
}

.footer-divider {
  position: relative;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(166, 27, 46, 0.2), rgba(196, 54, 74, 0.3), rgba(166, 27, 46, 0.2), transparent);
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  justify-content: center;

  .divider-peony {
    position: absolute;
    background: #1A0A0E;
    padding: 0 16px;
    font-size: 14px;
    opacity: 0.6;
  }
}

.footer-bottom {
  .copyright-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 8px;
  }

  .copyright-text {
    font-size: 13px;
    color: rgba(255, 255, 255, 0.4);
    margin: 0;
    display: flex;
    align-items: center;
    gap: 6px;

    .peony-icon {
      font-size: 12px;
      opacity: 0.6;
    }
  }

  .legal-links {
    display: flex;
    align-items: center;
    gap: 12px;

    a {
      font-size: 13px;
      color: rgba(255, 255, 255, 0.4);
      text-decoration: none;
      cursor: pointer;
      transition: color 0.25s;

      &:hover {
        color: #E38995;
      }
    }

    .divider {
      color: rgba(166, 27, 46, 0.3);
      font-size: 12px;
    }
  }

  .beian-text {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.25);
    margin: 0;
    text-align: center;
  }
}

// 个人资料弹窗
.profile-card {
  .profile-avatar-section {
    text-align: center;
    padding: 16px 0 24px;
    border-bottom: 1px solid #f0f0f0;
    margin-bottom: 20px;

    .profile-username {
      font-size: 18px;
      font-weight: 600;
      color: #1a1a2e;
      margin: 12px 0 4px;
    }

    .profile-account {
      font-size: 13px;
      color: #999;
      margin: 0;
    }
  }

  .profile-info-section {
    .info-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 0;
      border-bottom: 1px solid #f8f8f8;

      &:last-child {
        border-bottom: none;
      }

      .info-label {
        font-size: 14px;
        color: #999;
      }

      .info-value {
        font-size: 14px;
        color: #333;
        font-weight: 500;
      }
    }
  }
}

@media (max-width: 1024px) {
  .peony-decoration {
    width: 350px;
    height: 350px;
    opacity: 0.3;
  }

  .footer-container {
    padding: 50px 30px 25px;
  }

  .footer-top {
    grid-template-columns: 1fr;
    gap: 40px;
  }

  .footer-brand-section {
    text-align: center;

    .brand-header {
      justify-content: center;
    }

    .brand-contact {
      align-items: center;
    }
  }

  .footer-links-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 30px 20px;
  }
}

@media (max-width: 640px) {
  .peony-decoration {
    width: 250px;
    height: 250px;
    opacity: 0.2;
  }

  .footer-container {
    padding: 40px 20px 20px;
  }

  .footer-top {
    gap: 30px;
    margin-bottom: 30px;
  }

  .footer-brand-section {
    .brand-desc {
      font-size: 12px;
    }

    .brand-contact .contact-item {
      font-size: 12px;
    }
  }

  .footer-links-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 24px 16px;
  }

  .link-group {
    .link-title {
      font-size: 14px;
      margin-bottom: 14px;

      &::after {
        width: 18px;
      }
    }

    .link-list li {
      margin-bottom: 8px;

      a {
        font-size: 12px;
      }
    }
  }

  .footer-bottom {
    .copyright-row {
      flex-direction: column;
      text-align: center;
      gap: 10px;
    }

    .beian-text {
      font-size: 11px;
    }
  }
}
</style>
