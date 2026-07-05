<template>
  <div class="admin-layout">
    <div class="sidebar" :style="{ width: sidebarWidth + 'px' }" :class="{ collapsed: isCollapsed }">
      <div class="sidebar-header">
        <div class="sidebar-logo">
          <img src="/logo.png" alt="菏你同游" class="logo-img" />
          <span v-if="!isCollapsed" class="logo-text">菏你同游</span>
        </div>
      </div>
      <div class="sidebar-menu">
        <ul class="nav-list">
          <li
            v-for="route in menuRoutes"
            :key="route.path"
            :class="{ active: currentRoute === route.path }"
            @click="$router.push(route.path)"
            :title="isCollapsed ? (route.name as string) : undefined"
          >
            <el-icon v-if="route.meta?.icon">
              <component :is="route.meta.icon" />
            </el-icon>
            <span v-if="!isCollapsed">{{ route.name }}</span>
          </li>
        </ul>
      </div>
      <div class="sidebar-footer" v-if="!isCollapsed">
        <div class="version-info">v1.0.0</div>
      </div>
    </div>

    <div class="drag-bar" @mousedown="startDrag" @dblclick="toggleCollapse"></div>

    <div class="main-content">
      <div class="header">
        <div class="header-left">
          <el-breadcrumb separator="">
            <el-breadcrumb-item v-for="(item, index) in breadcrumbList" :key="item.path">
              <span class="path-name" v-if="index === breadcrumbList.length - 1">
                {{ item.meta?.title || item.name }}
              </span>
              <router-link v-else :to="item.path">
                {{ item.meta?.title || item.name }}
              </router-link>
            </el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand" class="custom-dropdown">
            <span class="user-info">
              <el-avatar :size="32" :src="userInfo?.avatar" />
              <span class="username">{{ userInfo?.username || '管理员' }}</span>
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人资料</el-dropdown-item>
                <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>

      <div class="content">
        <router-view />
      </div>
    </div>

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
          <el-input style="width: 90%" v-model="updateUserInfo.account" placeholder="请输入账号" :disabled="true" />
          <div class="tip-text">账号一经注册，不可修改</div>
        </el-form-item>
        <el-form-item label="昵称" prop="username">
          <el-input style="width: 90%" v-model="updateUserInfo.username" placeholder="请输入昵称" />
        </el-form-item>
        <el-form-item label="性别">
          <el-radio-group v-model="updateUserInfo.gender">
            <el-radio :value="1">女</el-radio>
            <el-radio :value="2">男</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input style="width: 90%" v-model="updateUserInfo.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input style="width: 90%" v-model="updateUserInfo.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="生日">
          <el-date-picker :value-format="'YYYY-MM-DD'" v-model="updateUserInfo.birthday" type="date" placeholder="选择生日"
            style="width: 90%" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div style="display: flex;justify-content: center;align-items: center;margin-bottom: 20px;">
          <el-button round @click="dialogProfileVisible = false">取消</el-button>
          <el-button icon="CircleCheckFilled" round type="primary" @click="handleConfirm">确定修改</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { setUserInfo } from '@/utils/storage'
import { get, put } from '@/utils/request'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ArrowDown, Upload } from '@element-plus/icons-vue'
import {
  getLastVisitedPath,
  clearLastVisitedPath,
  clearToken,
  clearRole,
  clearUserInfo,
  getSidebarWidth,
  setSidebarWidth,
  getSidebarCollapsed,
  setSidebarCollapsed
} from '@/utils/storage'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const DEFAULT_WIDTH = 220
const COLLAPSED_WIDTH = 72
const MIN_WIDTH = 72
const MAX_WIDTH = 220

const sidebarWidth = ref(getSidebarWidth() || DEFAULT_WIDTH)
const isCollapsed = ref(getSidebarCollapsed() || false)
const isDragging = ref(false)
const dialogProfileVisible = ref(false)
const updateUserInfo = reactive({
  avatar: '',
  account: '',
  username: '',
  gender: null,
  email: '',
  phone: '',
  birthday: null
})

watch(isCollapsed, (newVal) => {
  if (newVal) {
    sidebarWidth.value = COLLAPSED_WIDTH
  } else {
    sidebarWidth.value = DEFAULT_WIDTH
  }
  setSidebarCollapsed(newVal)
  setSidebarWidth(sidebarWidth.value)
})

const handleImageSuccess = (response: any) => {
  if (response.code === 200) {
    updateUserInfo.avatar = response.data
    ElMessage.success('头像上传成功')
  } else {
    ElMessage.error(response.message || '头像上传失败')
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

const menuRoutes = computed(() => {
  const routes = router.getRoutes()
  return routes
    .filter(route => {
      const hasMenu = route.meta?.showInMenu
      const hasRole = route.meta?.roles?.includes(1)
      const isAdminRoute = route.path.startsWith('/admin/') && route.path !== '/admin'
      return hasMenu && hasRole && isAdminRoute
    })
    .sort((a, b) => (a.meta.menuOrder || 99) - (b.meta.menuOrder || 99))
})

const currentRoute = computed(() => route.path)

const breadcrumbList = computed(() => {
  const matched = route.matched.filter(item => item.meta?.breadcrumb !== false)
  return matched.map(item => ({
    path: item.path,
    name: item.name as string,
    meta: item.meta
  }))
})

const toggleCollapse = () => {
  isCollapsed.value = !isCollapsed.value
}

const startDrag = (e: MouseEvent) => {
  e.preventDefault()
  isDragging.value = true
  document.body.style.userSelect = 'none'
  document.body.style.cursor = 'col-resize'

  const startX = e.clientX
  const startWidth = sidebarWidth.value

  const doDrag = (moveEvent: MouseEvent) => {
    if (!isDragging.value) return
    const deltaX = moveEvent.clientX - startX
    let newWidth = startWidth + deltaX
    if (newWidth < MIN_WIDTH) newWidth = MIN_WIDTH
    if (newWidth > MAX_WIDTH) newWidth = MAX_WIDTH
    sidebarWidth.value = newWidth
    if (newWidth <= MIN_WIDTH) {
      isCollapsed.value = true
    } else if (newWidth > MIN_WIDTH + 20) {
      isCollapsed.value = false
    }
  }

  const stopDrag = () => {
    if (!isDragging.value) return
    isDragging.value = false
    document.body.style.userSelect = ''
    document.body.style.cursor = ''
    setSidebarWidth(sidebarWidth.value)
    document.removeEventListener('mousemove', doDrag)
    document.removeEventListener('mouseup', stopDrag)
  }

  document.addEventListener('mousemove', doDrag)
  document.addEventListener('mouseup', stopDrag)
}

const handleCommand = async (command: string) => {
  switch (command) {
    case 'profile':
      profile()
      break
    case 'logout':
      await handleLogout()
      break
  }
}

const handleLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    clearToken()
    clearRole()
    clearUserInfo()
    clearLastVisitedPath()
    router.push('/')
    ElMessage.success('已退出登录')
  } catch { }
}

onMounted(async () => {
  const savedWidth = getSidebarWidth()
  if (savedWidth && savedWidth <= MIN_WIDTH) {
    isCollapsed.value = true
  }
  await fetchUserAuth()
  const lastPath = getLastVisitedPath()
  if (route.path === '/admin') {
    const validLastPath = lastPath && lastPath !== '/' && lastPath !== '/login' && lastPath !== '/register' && lastPath.startsWith('/admin/')
    router.push(validLastPath ? lastPath : '/admin/dashboard')
  }
})

onUnmounted(() => {
  document.removeEventListener('mousemove', () => { })
  document.removeEventListener('mouseup', () => { })
  document.body.style.userSelect = ''
  document.body.style.cursor = ''
})
</script>

<style scoped lang="scss">
.admin-layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
  background: #0F0F14;
}

.sidebar {
  background: #141418;
  color: white;
  transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  flex-shrink: 0;
  border-right: 1px solid rgba(255, 255, 255, 0.06);
  overflow: hidden;

  .sidebar-header {
    padding: 20px;
    display: flex;
    justify-content: flex-start;
    align-items: center;
    border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    transition: all 0.3s ease;

    .sidebar-logo {
      display: flex;
      align-items: center;
      gap: 12px;

      .logo-img {
        width: 40px;
        height: 40px;
        min-width: 40px;
        object-fit: contain;
        border-radius: 10px;
      }

      .logo-text {
        font-family: var(--font-serif);
        font-size: 20px;
        font-weight: 600;
        color: white;
        letter-spacing: 2px;
        white-space: nowrap;
      }
    }
  }

  .sidebar-menu {
    flex: 1;
    overflow-y: auto;
    padding: 12px 8px;

    &::-webkit-scrollbar {
      width: 4px;
    }

    &::-webkit-scrollbar-thumb {
      background: rgba(255, 255, 255, 0.1);
      border-radius: 2px;
    }
  }

  .sidebar-footer {
    padding: 16px 20px;
    border-top: 1px solid rgba(255, 255, 255, 0.06);

    .version-info {
      font-size: 12px;
      color: rgba(255, 255, 255, 0.25);
      text-align: center;
      letter-spacing: 1px;
    }
  }
}

.sidebar.collapsed {
  .sidebar-header {
    justify-content: center;
    padding: 20px 10px;

    .logo-text {
      display: none;
    }
  }

  .sidebar-footer {
    display: none;
  }
}

.nav-list {
  margin: 0;
  padding: 0;
  list-style: none;

  li {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 0 16px;
    height: 48px;
    font-size: 14px;
    line-height: 48px;
    cursor: pointer;
    color: rgba(255, 255, 255, 0.55);
    transition: all 0.2s ease;
    white-space: nowrap;
    overflow: hidden;
    border-radius: 10px;
    margin-bottom: 4px;

    &:hover {
      background-color: rgba(255, 255, 255, 0.06);
      color: rgba(255, 255, 255, 0.9);
    }

    &.active {
      background: linear-gradient(135deg, rgba(166, 27, 46, 0.2), rgba(166, 27, 46, 0.1));
      color: #E38995;
      font-weight: 600;

      .el-icon {
        color: var(--primary-color);
      }
    }

    .el-icon {
      font-size: 20px;
      flex-shrink: 0;
      transition: margin 0.2s ease;
    }

    span {
      transition: opacity 0.2s ease;
    }
  }
}

.sidebar.collapsed .nav-list li {
  justify-content: center;
  padding: 0 10px;

  .el-icon {
    margin: 0;
  }

  span {
    opacity: 0;
    width: 0;
  }
}

.drag-bar {
  width: 4px;
  background-color: transparent;
  cursor: col-resize;
  transition: background-color 0.2s;
  flex-shrink: 0;
  position: relative;
  z-index: 1000;

  &:hover {
    background-color: var(--primary-color);
  }

  &:active {
    background-color: var(--primary-color);
  }
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
  background: #0F0F14;

  .header {
    height: 64px;
    padding: 0 28px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-shrink: 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    background: #141418;

    .header-left {
      :deep(.el-breadcrumb) {
        font-size: 16px;
      }

      :deep(.el-breadcrumb__inner) {
        color: rgba(255, 255, 255, 0.5) !important;

        &.is-link:hover {
          color: var(--primary-light) !important;
        }
      }

      :deep(.el-breadcrumb__separator) {
        color: rgba(255, 255, 255, 0.2) !important;
      }
    }

    .header-right {
      :deep(.custom-dropdown .el-dropdown-selfdefine) {
        outline: none !important;
        border: none !important;
      }

      :deep(.custom-dropdown:focus .el-dropdown-selfdefine) {
        outline: none !important;
        border: none !important;
      }

      .user-info {
        display: flex;
        align-items: center;
        cursor: pointer;
        padding: 6px 14px;
        border-radius: 100px;
        transition: background-color 0.2s;

        &:hover {
          background-color: rgba(255, 255, 255, 0.06);
        }

        .username {
          margin: 0 8px;
          font-size: 14px;
          font-weight: 500;
          color: rgba(255, 255, 255, 0.8);
        }

        .el-icon {
          color: rgba(255, 255, 255, 0.4);
        }
      }
    }
  }

  .content {
    flex: 1;
    padding: 24px 28px;
    overflow-y: auto;
    background: #0F0F14;

    &::-webkit-scrollbar {
      width: 6px;
    }

    &::-webkit-scrollbar-thumb {
      background: rgba(255, 255, 255, 0.1);
      border-radius: 3px;
    }
  }
}

.path-name {
  font-size: 18px;
  padding-inline: 4px;
  color: rgba(255, 255, 255, 0.9) !important;
  font-weight: 600;
}

.avatar-upload-container {
  display: flex;
  align-items: center;
  gap: 16px;
}

.tip-text {
  font-size: 12px;
  color: var(--text-light);
  margin-top: 4px;
}
</style>
