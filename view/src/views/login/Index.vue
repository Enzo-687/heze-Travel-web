<template>
  <div class="login-page">
    <div class="login-bg">
      <div class="bg-gradient"></div>
      <div class="bg-peony">
        <svg viewBox="0 0 400 400" class="peony-bg-svg">
          <defs>
            <radialGradient id="loginGrad" cx="50%" cy="40%" r="50%">
              <stop offset="0%" style="stop-color:#C4364A;stop-opacity:0.3" />
              <stop offset="100%" style="stop-color:#7A1220;stop-opacity:0.05" />
            </radialGradient>
          </defs>
          <g opacity="0.4">
            <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#loginGrad)" transform="rotate(0 200 200)"/>
            <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#loginGrad)" transform="rotate(45 200 200)"/>
            <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#loginGrad)" transform="rotate(90 200 200)"/>
            <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#loginGrad)" transform="rotate(135 200 200)"/>
            <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#loginGrad)" transform="rotate(22.5 200 200)" opacity="0.5"/>
            <ellipse cx="200" cy="160" rx="55" ry="80" fill="url(#loginGrad)" transform="rotate(67.5 200 200)" opacity="0.5"/>
          </g>
          <circle cx="200" cy="200" r="20" fill="#E38995" opacity="0.3"/>
        </svg>
      </div>
    </div>

    <div class="login-container">
      <div class="login-card animate-card">
        <div class="login-header animate-header">
          <div class="login-logo">
            <img src="/logo.png" alt="菏你同游" class="logo-img" />
          </div>
          <h1 class="login-title">菏你同游</h1>
          <p class="login-subtitle">在线旅游平台</p>
        </div>

        <div class="login-form">
          <div class="form-group animate-form" style="--delay: 0">
            <label class="form-label">账号</label>
            <input
              v-model="account"
              class="form-input"
              placeholder="请输入登录账号"
              @keyup.enter="login"
            />
          </div>
          <div class="form-group animate-form" style="--delay: 1">
            <label class="form-label">密码</label>
            <input
              v-model="password"
              class="form-input"
              type="password"
              placeholder="请输入密码"
              @keyup.enter="login"
            />
          </div>

          <button class="login-btn animate-btn" @click="login">
            <span>登 录</span>
          </button>
        </div>

        <div class="login-footer animate-footer">
          <span class="footer-text">还没有账号？</span>
          <span class="footer-link" @click="toDoRegister">立即注册</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { post } from '@/utils/request.js'
import { setToken, setRole } from '@/utils/storage.js'
import md5 from 'js-md5'

const DELAY_TIME: number = 500

interface LoginResponse {
  code: number
  data: {
    token: string
    role: number
  }
  message?: string
}

interface UserLoginDTO {
  account: string
  password: string
}

const router = useRouter()
const account = ref<string>('')
const password = ref<string>('')

const toDoRegister = (): void => {
  router.push('/register')
}

const login = async (): Promise<void> => {
  if (!account.value.trim() || !password.value.trim()) {
    ElMessage.info({
      message: '账号或密码不能为空',
      duration: 1500,
    })
    return
  }

  const hashedPwd: string = md5(md5(password.value))

  const userLoginDTO: UserLoginDTO = {
    account: account.value,
    password: hashedPwd,
  }

  try {
    const data: LoginResponse = await post('user/login', userLoginDTO)
    setToken(data.data.token)

    setTimeout((): void => {
      const { role } = data.data
      setRole(role)
      navigateToRole(role)
    }, DELAY_TIME)

    ElMessage.success('登录成功')
  } catch (error: any) {
    ElMessage.warning({
      message: error.message || '登录失败',
      duration: 1500,
    })
  }
}

const navigateToRole = (role: number): void => {
  // 检查是否有登录前保存的跳转路径
  const redirectPath = localStorage.getItem('redirectAfterLogin')
  if (redirectPath) {
    localStorage.removeItem('redirectAfterLogin')
    router.push(redirectPath)
    return
  }

  switch (role) {
    case 1:
      router.push('/admin')
      break
    case 2:
      router.push('/user')
      break
    default:
      ElMessage.warning('未知的用户角色')
      break
  }
}
</script>

<style scoped lang="scss">
.login-page {
  width: 100%;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.login-bg {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, #0A0A0A 0%, #1A0A0E 40%, #0A0A0A 100%);
  z-index: 0;

  .bg-gradient {
    position: absolute;
    inset: 0;
    background: radial-gradient(ellipse 70% 50% at 70% 50%, rgba(166, 27, 46, 0.15) 0%, transparent 70%);
  }

  .bg-peony {
    position: absolute;
    right: -5%;
    top: 50%;
    transform: translateY(-50%);
    width: 600px;
    height: 600px;
    opacity: 0.3;

    .peony-bg-svg {
      width: 100%;
      height: 100%;
    }
  }
}

.login-container {
  position: relative;
  z-index: 10;
  width: 100%;
  display: flex;
  justify-content: center;
  padding: 20px;
}

.login-card {
  width: 420px;
  background: rgba(20, 20, 20, 0.8);
  backdrop-filter: blur(40px);
  -webkit-backdrop-filter: blur(40px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: var(--radius-xl);
  padding: 56px 44px;
  box-shadow:
    0 40px 80px rgba(0, 0, 0, 0.4),
    inset 0 1px 0 rgba(255, 255, 255, 0.05);
}

.login-header {
  text-align: center;
  margin-bottom: 48px;

  .login-logo {
    margin-bottom: 24px;

    .logo-img {
      width: 64px;
      height: 64px;
      object-fit: contain;
      border-radius: 18px;
      box-shadow: 0 8px 32px rgba(166, 27, 46, 0.4);
    }
  }

  .login-title {
    font-family: var(--font-serif);
    font-size: 32px;
    font-weight: 700;
    color: white;
    letter-spacing: 6px;
    margin-bottom: 8px;
  }

  .login-subtitle {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.4);
    letter-spacing: 4px;
  }
}

.login-form {
  .form-group {
    margin-bottom: 24px;

    .form-label {
      display: block;
      font-size: 13px;
      font-weight: 500;
      color: rgba(255, 255, 255, 0.5);
      margin-bottom: 10px;
      letter-spacing: 2px;
    }

    .form-input {
      width: 100%;
      height: 52px;
      background: rgba(255, 255, 255, 0.06);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: var(--radius-md);
      padding: 0 20px;
      font-size: 16px;
      color: white;
      outline: none;
      transition: var(--transition-fast);
      font-family: var(--font-sans);

      &::placeholder {
        color: rgba(255, 255, 255, 0.25);
      }

      &:hover {
        border-color: rgba(166, 27, 46, 0.4);
        background: rgba(255, 255, 255, 0.08);
      }

      &:focus {
        border-color: var(--primary-color);
        background: rgba(255, 255, 255, 0.1);
        box-shadow: 0 0 0 3px rgba(166, 27, 46, 0.15);
      }
    }
  }

  .login-btn {
    width: 100%;
    height: 52px;
    background: var(--primary-color);
    color: white;
    border: none;
    border-radius: var(--radius-md);
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: var(--transition-normal);
    letter-spacing: 8px;
    margin-top: 8px;
    position: relative;
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent);
      transition: left 0.5s;
    }

    &:hover {
      background: var(--primary-light);
      transform: translateY(-2px);
      box-shadow: 0 8px 30px rgba(166, 27, 46, 0.4);

      &::before {
        left: 100%;
      }
    }

    &:active {
      transform: translateY(0);
    }
  }
}

.login-footer {
  text-align: center;
  margin-top: 36px;
  padding-top: 28px;
  border-top: 1px solid rgba(255, 255, 255, 0.06);

  .footer-text {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.35);
  }

  .footer-link {
    font-size: 14px;
    color: var(--primary-light);
    font-weight: 600;
    cursor: pointer;
    transition: var(--transition-fast);
    letter-spacing: 1px;

    &:hover {
      color: #E38995;
    }
  }
}

.animate-card {
  animation: cardIn 0.8s cubic-bezier(0.16, 1, 0.3, 1) both;
}

.animate-header {
  animation: headerIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) 0.2s both;
}

.animate-form {
  animation: formIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) calc(0.3s + var(--delay) * 0.1s) both;
}

.animate-btn {
  animation: btnIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) 0.5s both;
}

.animate-footer {
  animation: footerIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) 0.6s both;
}

@keyframes cardIn {
  from { opacity: 0; transform: translateY(40px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes headerIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes formIn {
  from { opacity: 0; transform: translateX(-20px); }
  to { opacity: 1; transform: translateX(0); }
}

@keyframes btnIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes footerIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@media (max-width: 480px) {
  .login-card {
    width: 100%;
    padding: 40px 28px;
    border-radius: var(--radius-lg);
  }

  .login-header {
    .login-title {
      font-size: 26px;
    }
  }
}
</style>
