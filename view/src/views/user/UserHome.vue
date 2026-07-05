<template>
  <div class="user-layout">
    <nav class="user-nav" :class="{ scrolled: isScrolled }">
      <div class="nav-inner">
        <div class="nav-logo" @click="scrollToTop">
          <img src="/logo.png" alt="菏你同游" class="logo-img" />
          <span class="logo-text">菏你同游</span>
        </div>
        <ul class="nav-links">
          <li
            v-for="route in menuRoutes"
            :key="route.path"
            :class="{ active: currentRoute === route.path }"
            @click="$router.push(route.path)"
          >
            <el-icon v-if="route.meta?.icon" style="margin-right: 4px;">
              <component :is="route.meta.icon" />
            </el-icon>
            <span>{{ route.name }}</span>
          </li>
        </ul>
        <div class="nav-actions">
          <div class="ai-btn" @click="aiShow">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 2a4 4 0 0 1 4 4v2a4 4 0 0 1-8 0V6a4 4 0 0 1 4-4z"/>
              <path d="M16 14H8a6 6 0 0 0-6 6v2h20v-2a6 6 0 0 0-6-6z"/>
            </svg>
            AI客服
          </div>
          <el-dropdown @command="handleCommand" class="user-dropdown">
            <span class="user-info">
              <el-avatar :size="32" :src="userInfo?.avatar" />
              <span class="username">{{ userInfo?.username || '用户' }}</span>
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item icon="Connection" command="strategy">发布攻略</el-dropdown-item>
                <el-dropdown-item icon="ScaleToOriginal" command="myStrategy">内容中心</el-dropdown-item>
                <el-dropdown-item icon="Document" command="profile">个人资料</el-dropdown-item>
                <el-dropdown-item icon="Setting" command="updatePasswordShowBlock">修改密码</el-dropdown-item>
                <el-dropdown-item icon="Right" command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </nav>

    <section class="user-hero">
      <div class="hero-canvas">
        <div class="hero-gradient"></div>
        <div class="hero-mesh"></div>
        <div class="hero-particles">
          <span v-for="n in 12" :key="n" class="particle" :style="particleStyle(n)"></span>
        </div>
      </div>
      <div class="hero-layout">
        <div class="hero-left">
          <div class="hero-greeting">
            <span class="greeting-dot"></span>
            <span>{{ greetingText }}，{{ userInfo?.username || '旅行者' }}</span>
          </div>
          <h1 class="hero-heading">
            <span class="heading-line">探索菏泽之美</span>
          </h1>
          <p class="hero-desc">千年古韵 · 牡丹花城 · 红色热土 · 非遗传承</p>
          <div class="hero-actions">
            <div class="cta-primary" @click="$router.push('/user/user-main')">
              <span>开始探索</span>
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M5 12h14M12 5l7 7-7 7"/>
              </svg>
            </div>
            <div class="cta-secondary" @click="aiShow">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 2a4 4 0 0 1 4 4v2a4 4 0 0 1-8 0V6a4 4 0 0 1 4-4z"/>
                <path d="M16 14H8a6 6 0 0 0-6 6v2h20v-2a6 6 0 0 0-6-6z"/>
              </svg>
              <span>AI 推荐</span>
            </div>
          </div>
        </div>
        <div class="hero-right">
          <div class="user-card">
            <div class="card-glow"></div>
            <div class="card-inner">
              <div class="card-avatar">
                <el-avatar :size="72" :src="userInfo?.avatar" />
              </div>
              <div class="card-name">{{ userInfo?.username || '旅行者' }}</div>
              <div class="card-account">@{{ userInfo?.account || 'user' }}</div>
              <div class="card-stats">
                <div class="stat">
                  <span class="stat-value">{{ ticketCount }}</span>
                  <span class="stat-label">待使用门票</span>
                </div>
                <div class="stat-divider"></div>
                <div class="stat">
                  <span class="stat-value">{{ strategyCount }}</span>
                  <span class="stat-label">发布攻略</span>
                </div>
                <div class="stat-divider"></div>
                <div class="stat">
                  <span class="stat-value">{{ collectionCount }}</span>
                  <span class="stat-label">收藏</span>
                </div>
              </div>
              <div class="card-menu">
                <div class="menu-item" @click="handleCommand('strategy')">
                  <span>📝</span>
                  <span>发布攻略</span>
                </div>
                <div class="menu-item" @click="handleCommand('myStrategy')">
                  <span>📋</span>
                  <span>内容中心</span>
                </div>
                <div class="menu-item" @click="handleCommand('profile')">
                  <span>👤</span>
                  <span>个人资料</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="user-content">
      <div class="content-inner">
        <router-view />
      </div>
    </section>

    <AppFooter />

    <el-dialog title="修改信息" v-model="dialogProfileVisible" width="500px" :close-on-click-modal="false">
      <el-form :model="updateUserInfo" label-width="80px" ref="formRef">
        <el-form-item label="头像">
          <div class="avatar-upload-container">
            <el-avatar :size="80" :src="updateUserInfo.avatar" />
            <el-upload class="avatar-uploader" action="http://localhost:21090/api/v1.0/online-travel-api/file/upload"
              :show-file-list="false" :on-success="handleImageSuccess">
              <el-button type="primary" size="small">
                <el-icon><Upload /></el-icon>
                上传头像
              </el-button>
            </el-upload>
          </div>
        </el-form-item>
        <el-form-item label="账号" prop="account">
          <el-input style="width: 90%;" v-model="updateUserInfo.account" placeholder="请输入账号" :disabled="true" />
          <div class="tip-text">账号一经注册，不可修改</div>
        </el-form-item>
        <el-form-item label="昵称" prop="username">
          <el-input style="width: 90%;" v-model="updateUserInfo.username" placeholder="请输入昵称" />
        </el-form-item>
        <el-form-item label="性别">
          <el-radio-group v-model="updateUserInfo.gender">
            <el-radio :value="1">女</el-radio>
            <el-radio :value="2">男</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input style="width: 90%;" v-model="updateUserInfo.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input style="width: 90%;" v-model="updateUserInfo.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="生日">
          <el-date-picker :value-format="'YYYY-MM-DD'" v-model="updateUserInfo.birthday" type="date" placeholder="选择生日"
            style="width: 90%;" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div style="display: flex;justify-content: center;align-items: center;margin-bottom: 20px;">
          <el-button round @click="dialogProfileVisible = false">取消</el-button>
          <el-button icon="CircleCheckFilled" round type="primary" @click="handleConfirm">确定修改</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog title="修改密码" v-model="dialogPasswordVisible" width="450px" :close-on-click-modal="false">
      <el-form :model="updatePasswordInfo" label-width="100px" ref="formRef">
        <el-form-item label="原始密码" prop="oldPassword">
          <el-input style="width: 90%;" placeholder="请输入密码" v-model="updatePasswordInfo.oldPassword" show-password></el-input>
        </el-form-item>
        <el-form-item label="新密码" prop="account">
          <el-input style="width: 90%;" placeholder="请输入密码" v-model="updatePasswordInfo.newPassword" show-password></el-input>
        </el-form-item>
        <el-form-item label="重复密码" prop="account">
          <el-input style="width: 90%;" placeholder="请输入密码" v-model="updatePasswordInfo.againPassword" show-password></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div style="display: flex;justify-content: center;align-items: center;margin-bottom: 20px;">
          <el-button round @click="updatePasswordCannel">取消</el-button>
          <el-button icon="CircleCheckFilled" round type="primary" @click="handleConfirmPassword">确定修改</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog title="您的AI客服" v-model="aiBlockFlag" width="700px" :close-on-click-modal="false">
      <Deepseek :user-avatar="userAvatar" />
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import Deepseek from "@/components/Deepseek.vue"
import AppFooter from "@/components/AppFooter.vue"
import { useUserStore } from '@/stores/user'
import { get, put } from '@/utils/request'
import { updatePasswordApi } from '@/api/user-api'
import type { UserUpdatePasswordDTO } from '@/types/user'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ArrowDown, Upload } from '@element-plus/icons-vue'
import md5 from 'js-md5'
import {
  getLastVisitedPath,
  clearLastVisitedPath,
  clearToken,
  clearRole,
  clearUserInfo,
  setUserInfo
} from '@/utils/storage'
import { queryCarouselApi } from "@/api/carousel-api"
import type { Carousel, CarouselQueryDto } from "@/types/carousel"
import { queryUserScenicSpotTicketOrdersApi } from "@/api/scenic-spot-ticket-orders-api"
import { queryScenciSpotStrategyApi, queryUserCollectionApi as queryStrategyCollectionApi } from "@/api/scenic-spot-strategy-api"
import { queryUserCollectionApi as querySpotCollectionApi } from "@/api/scenic-spot-api"
import type { ScenicSpotTicketOrderQueryDTO } from "@/types/scenic-spot-ticket-order"
import type { ScenicSpotStrategyQueryDTO } from "@/types/scenic-spot-strategy"
import type { ScenicSpotQueryDTO } from "@/types/scenic-spot"

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const isScrolled = ref(false)
const aiBlockFlag = ref(false)
const userAvatar = ref('')
const dialogProfileVisible = ref(false)
const dialogPasswordVisible = ref(false)
const ticketCount = ref(0)
const strategyCount = ref(0)
const collectionCount = ref(0)
const updateUserInfo = reactive({
  avatar: '',
  account: '',
  username: '',
  gender: null as number | null,
  email: '',
  phone: '',
  birthday: null as string | null
})

const greetingText = computed(() => {
  const h = new Date().getHours()
  if (h < 6) return '夜深了'
  if (h < 12) return '早上好'
  if (h < 14) return '中午好'
  if (h < 18) return '下午好'
  return '晚上好'
})

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

const aiShow = () => {
  aiBlockFlag.value = true
  userAvatar.value = useUserStore()?.userInfo?.avatar ?? ''
}

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const handleScroll = () => {
  isScrolled.value = window.scrollY > 60
}

const carouselList = ref<Carousel[]>([])
const carouselQueryDTO = reactive<Partial<CarouselQueryDto>>({})
const updatePasswordInfo = reactive<UserUpdatePasswordDTO>({
  oldPassword: '',
  newPassword: '',
  againPassword: ''
})

const handleImageSuccess = (response: any) => {
  if (response.code === 200) {
    updateUserInfo.avatar = response.data
    ElMessage.success('头像上传成功')
  } else {
    ElMessage.error(response.message || '头像上传失败')
  }
}

const handleConfirmPassword = async () => {
  try {
    if (!updatePasswordInfo.oldPassword) { ElMessage.warning('旧密码不为空'); return }
    if (!updatePasswordInfo.newPassword) { ElMessage.warning('新密码不为空'); return }
    if (!updatePasswordInfo.againPassword) { ElMessage.warning('重复密码不为空'); return }
    if (updatePasswordInfo.againPassword !== updatePasswordInfo.newPassword) { ElMessage.warning('前后新密码输入不一致'); return }
    updatePasswordInfo.oldPassword = md5(md5(updatePasswordInfo.oldPassword))
    updatePasswordInfo.newPassword = md5(md5(updatePasswordInfo.newPassword))
    updatePasswordInfo.againPassword = md5(md5(updatePasswordInfo.againPassword))
    await updatePasswordApi(updatePasswordInfo)
    ElMessage.success('密码修改成功')
    clearToken(); clearRole(); clearUserInfo(); clearLastVisitedPath()
    router.push('/')
  } catch (error: any) {
    Object.assign(updatePasswordInfo, { oldPassword: '', newPassword: '', againPassword: '' })
    ElMessage.warning(error.message)
  }
}

const fetchCarouselData = async () => {
  try {
    const response = await queryCarouselApi(carouselQueryDTO as any)
    carouselList.value = response.data
  } catch (error: any) {
    ElMessage.error(error.message || '获取轮播图数据失败')
  }
}

const handleConfirm = async () => {
  try {
    await put('/user', updateUserInfo)
    userStore.setUserInfo(updateUserInfo)
    dialogProfileVisible.value = false
    ElMessage.success('个人信息修改成功')
  } catch (error: any) {
    ElMessage.error(error.message || '认证失败')
  }
}

const userInfo = computed(() => userStore.userInfo)

const profile = () => {
  Object.assign(updateUserInfo, { ...userStore.userInfo })
  dialogProfileVisible.value = true
}

const updatePasswordCannel = () => {
  dialogPasswordVisible.value = false
  Object.assign(updatePasswordInfo, { oldPassword: '', newPassword: '', againPassword: '' })
}

const updatePasswordShowBlock = () => {
  dialogPasswordVisible.value = true
}

const fetchUserAuth = async () => {
  try {
    const response = await get('/user/auth')
    if (response.code === 200) {
      userStore.setUserInfo(response.data)
      setUserInfo(response.data)
    } else {
      ElMessage.error(response.message || '认证失败')
      router.push('/login')
    }
  } catch (error: any) {
    ElMessage.error(error.message || '认证请求失败')
    router.push('/login')
  }
}

const fetchUserStats = async () => {
  try {
    const ticketRes = await queryUserScenicSpotTicketOrdersApi({ current: 1, size: 1, status: 1 } as ScenicSpotTicketOrderQueryDTO)
    ticketCount.value = ticketRes.total ?? ticketRes.data?.length ?? 0
  } catch (e) { ticketCount.value = 0 }

  try {
    const strategyRes = await queryScenciSpotStrategyApi({ current: 1, size: 1 } as ScenicSpotStrategyQueryDTO)
    strategyCount.value = strategyRes.total ?? strategyRes.data?.length ?? 0
  } catch (e) { strategyCount.value = 0 }

  try {
    const collectionRes = await querySpotCollectionApi({ current: 1, size: 1 } as ScenicSpotQueryDTO)
    const spotCount = collectionRes.total ?? collectionRes.data?.length ?? 0
    const strategyCollectionRes = await queryStrategyCollectionApi({ current: 1, size: 1 } as ScenicSpotStrategyQueryDTO)
    const strategyCount2 = strategyCollectionRes.total ?? strategyCollectionRes.data?.length ?? 0
    collectionCount.value = spotCount + strategyCount2
  } catch (e) { collectionCount.value = 0 }
}

const menuRoutes = computed(() => {
  const routes = router.getRoutes()
  return routes
    .filter(route => {
      const hasMenu = route.meta?.showInMenu
      const hasRole = route.meta?.roles?.includes(2)
      const isAdminRoute = route.path.startsWith('/user/') && route.path !== '/user'
      return hasMenu && hasRole && isAdminRoute
    })
    .sort((a, b) => (a.meta.menuOrder || 99) - (b.meta.menuOrder || 99))
})

const currentRoute = computed(() => route.path)

const handleCommand = async (command: string) => {
  switch (command) {
    case 'strategy': window.open('/scenic-spot-strategy-save'); break
    case 'myStrategy': window.open('/scenic-spot-strategy'); break
    case 'profile': profile(); break
    case 'updatePasswordShowBlock': updatePasswordShowBlock(); break
    case 'logout': await handleLogout(); break
  }
}

const handleLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning'
    })
    clearToken(); clearRole(); clearUserInfo(); clearLastVisitedPath()
    router.push('/')
    ElMessage.success('已退出登录')
  } catch { }
}

onMounted(async () => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  await fetchUserAuth()
  await fetchUserStats()
  const lastPath = getLastVisitedPath()
  if (route.path === '/user') {
    const validLastPath = lastPath && lastPath !== '/' && lastPath !== '/login' && lastPath !== '/register' && lastPath.startsWith('/user/')
    router.push(validLastPath ? lastPath : '/user/user-main')
  }
  await fetchCarouselData()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped lang="scss">
.user-layout {
  width: 100%;
  min-height: 100vh;
  background: var(--bg-color);
}

.user-nav {
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
      display: flex;
      align-items: center;

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

  .nav-actions {
    display: flex;
    align-items: center;
    gap: 12px;
  }

  .ai-btn {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 8px 18px;
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid rgba(255, 255, 255, 0.12);
    border-radius: 100px;
    color: rgba(255, 255, 255, 0.8);
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s;

    &:hover {
      background: rgba(166, 27, 46, 0.2);
      border-color: rgba(166, 27, 46, 0.4);
      color: white;
    }
  }

  .user-info {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    padding: 4px 12px 4px 4px;
    border-radius: 100px;
    background: rgba(255, 255, 255, 0.08);
    transition: all 0.3s;

    &:hover {
      background: rgba(255, 255, 255, 0.15);
    }

    .username {
      font-size: 13px;
      font-weight: 600;
      color: rgba(255, 255, 255, 0.85);
      max-width: 80px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }
}

.user-hero {
  position: relative;
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
    gap: 60px;
  }

  .hero-left {
    flex: 1;
    min-width: 0;

    .hero-greeting {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 6px 16px 6px 10px;
      background: rgba(166, 27, 46, 0.12);
      border: 1px solid rgba(166, 27, 46, 0.25);
      border-radius: 100px;
      margin-bottom: 28px;

      .greeting-dot {
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
        font-size: clamp(42px, 6vw, 72px);
        font-weight: 700;
        color: white;
        letter-spacing: 8px;
        line-height: 1.15;
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
    width: 360px;

    .user-card {
      position: relative;
      border-radius: 24px;
      overflow: hidden;

      .card-glow {
        position: absolute;
        inset: -1px;
        border-radius: 24px;
        padding: 1px;
        background: linear-gradient(135deg, rgba(166, 27, 46, 0.4), transparent 50%, rgba(166, 27, 46, 0.15));
        -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
        -webkit-mask-composite: xor;
        mask-composite: exclude;
        pointer-events: none;
      }

      .card-inner {
        background: rgba(255, 255, 255, 0.05);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-radius: 24px;
        padding: 36px 28px;
        text-align: center;
      }

      .card-avatar {
        margin-bottom: 16px;

        :deep(.el-avatar) {
          border: 2px solid rgba(166, 27, 46, 0.3);
          box-shadow: 0 0 24px rgba(166, 27, 46, 0.2);
        }
      }

      .card-name {
        font-family: var(--font-serif);
        font-size: 22px;
        font-weight: 700;
        color: white;
        letter-spacing: 2px;
        margin-bottom: 4px;
      }

      .card-account {
        font-size: 13px;
        color: rgba(255, 255, 255, 0.35);
        letter-spacing: 1px;
        margin-bottom: 24px;
      }

      .card-stats {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0;
        margin-bottom: 28px;
        padding: 16px 0;
        border-top: 1px solid rgba(255, 255, 255, 0.06);
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);

        .stat {
          flex: 1;
          text-align: center;

          .stat-value {
            display: block;
            font-size: 22px;
            font-weight: 700;
            font-family: var(--font-serif);
            color: white;
            letter-spacing: 1px;
          }

          .stat-label {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.35);
            letter-spacing: 1px;
          }
        }

        .stat-divider {
          width: 1px;
          height: 30px;
          background: rgba(255, 255, 255, 0.08);
        }
      }

      .card-menu {
        display: flex;
        flex-direction: column;
        gap: 8px;

        .menu-item {
          display: flex;
          align-items: center;
          gap: 12px;
          padding: 12px 16px;
          border-radius: 12px;
          cursor: pointer;
          transition: all 0.3s;
          font-size: 14px;
          color: rgba(255, 255, 255, 0.6);
          letter-spacing: 1px;

          &:hover {
            background: rgba(255, 255, 255, 0.06);
            color: white;
          }
        }
      }
    }
  }
}

.user-content {
  padding: 80px 0 100px;
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
}

.avatar-upload-container {
  display: flex;
  align-items: center;
  gap: 20px;
}

.tip-text {
  font-size: 12px;
  color: var(--text-light);
  margin-top: 4px;
}

@media (max-width: 1024px) {
  .user-hero .hero-layout {
    flex-direction: column;
    text-align: center;
    padding: 100px 32px 0;

    .hero-left {
      .hero-greeting { margin-left: auto; margin-right: auto; }
      .hero-actions { justify-content: center; }
    }

    .hero-right {
      width: 100%;
      max-width: 360px;
    }
  }
}

@media (max-width: 768px) {
  .user-nav {
    .nav-inner { padding: 0 20px; }
    .nav-links { display: none; }
  }

  .user-hero {
    .hero-layout {
      padding: 90px 20px 0;

      .hero-left {
        .hero-heading .heading-line { letter-spacing: 4px; }
        .hero-desc { font-size: 13px; letter-spacing: 3px; }
        .hero-actions {
          flex-direction: column;
          gap: 12px;
          .cta-primary, .cta-secondary { width: 100%; justify-content: center; }
        }
      }

      .hero-right { width: 100%; max-width: 320px; }
    }
  }

  .user-content {
    padding: 60px 0 80px;
    border-radius: 24px 24px 0 0;
    margin-top: -24px;

    .content-inner { padding: 0 20px; }
  }
}
</style>
