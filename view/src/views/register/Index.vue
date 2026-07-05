<template>
  <div class="register-page">
    <div class="register-bg">
      <div class="bg-gradient"></div>
    </div>

    <div class="register-container">
      <div class="register-card animate-card">
        <div class="register-header animate-header">
          <div class="register-logo">
            <img src="/logo.png" alt="菏你同游" class="logo-img" />
          </div>
          <h1 class="register-title">加入菏你同游</h1>
          <p class="register-subtitle">开启您的菏泽之旅</p>
        </div>

        <div class="register-form">
          <div class="form-group animate-form" style="--delay: 0">
            <label class="form-label">注册账号</label>
            <input v-model="formData.account" class="form-input" placeholder="请输入注册账号" />
          </div>
          <div class="form-group animate-form" style="--delay: 1">
            <label class="form-label">用户名</label>
            <input v-model="formData.username" class="form-input" placeholder="请输入用户名" />
          </div>
          <div class="form-group animate-form" style="--delay: 2">
            <label class="form-label">密码</label>
            <input v-model="formData.password" class="form-input" type="password" placeholder="请输入密码" />
          </div>
          <div class="form-group animate-form" style="--delay: 3">
            <label class="form-label">确认密码</label>
            <input v-model="formData.pwdConfirm" class="form-input" type="password" placeholder="请再次输入密码" />
          </div>

          <button class="register-btn animate-btn" @click="handleRegister">
            <span>{{ loading ? '注册中...' : '立即注册' }}</span>
          </button>
        </div>

        <div class="register-footer animate-footer">
          <span class="footer-text">已有账户？</span>
          <span class="footer-link" @click="toDoLogin">返回登录</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { post } from '@/utils/request.js'
import md5 from 'js-md5'

const DELAY_TIME: number = 800

interface RegisterForm {
  account: string
  username: string
  password: string
  pwdConfirm: string
}

const router = useRouter()
const loading = ref<boolean>(false)

const formData = reactive<RegisterForm>({
  account: '',
  username: '',
  password: '',
  pwdConfirm: '',
})

const validateForm = (): boolean => {
  if (!formData.account.trim()) {
    ElMessage.info('请输入注册账号')
    return false
  }
  if (formData.account.length < 3 || formData.account.length > 20) {
    ElMessage.info('账号长度在 3 到 20 个字符')
    return false
  }
  if (!formData.username.trim()) {
    ElMessage.info('请输入用户名')
    return false
  }
  if (formData.username.length < 2 || formData.username.length > 20) {
    ElMessage.info('用户名长度在 2 到 20 个字符')
    return false
  }
  if (!formData.password.trim()) {
    ElMessage.info('请输入密码')
    return false
  }
  if (formData.password.length < 6 || formData.password.length > 20) {
    ElMessage.info('密码长度在 6 到 20 个字符')
    return false
  }
  if (formData.password !== formData.pwdConfirm) {
    ElMessage.info('两次输入密码不一致')
    return false
  }
  return true
}

const toDoLogin = (): void => {
  router.push('/login')
}

const handleRegister = async (): Promise<void> => {
  if (!validateForm()) return

  loading.value = true

  try {
    const hashedPwd: string = md5(md5(formData.password))
    const userRegisterDTO = {
      account: formData.account,
      password: hashedPwd,
      username: formData.username,
    }

    await post('user/register', userRegisterDTO)

    ElMessage.success({
      message: '恭喜你，注册成功！',
      duration: 2500,
    })

    setTimeout(() => {
      router.push('/login')
    }, DELAY_TIME)
  } catch (error: any) {
    ElMessage.warning({
      message: error.message || '注册失败',
      duration: 1500,
    })
  } finally {
    loading.value = false
  }
}
</script>

<style scoped lang="scss">
.register-page {
  width: 100%;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.register-bg {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, #0A0A0A 0%, #1A0A0E 40%, #0A0A0A 100%);
  z-index: 0;

  .bg-gradient {
    position: absolute;
    inset: 0;
    background: radial-gradient(ellipse 70% 50% at 30% 50%, rgba(166, 27, 46, 0.12) 0%, transparent 70%);
  }
}

.register-container {
  position: relative;
  z-index: 10;
  width: 100%;
  display: flex;
  justify-content: center;
  padding: 20px;
}

.register-card {
  width: 420px;
  background: rgba(20, 20, 20, 0.8);
  backdrop-filter: blur(40px);
  -webkit-backdrop-filter: blur(40px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: var(--radius-xl);
  padding: 48px 44px;
  box-shadow:
    0 40px 80px rgba(0, 0, 0, 0.4),
    inset 0 1px 0 rgba(255, 255, 255, 0.05);
}

.register-header {
  text-align: center;
  margin-bottom: 40px;

  .register-logo {
    margin-bottom: 20px;

    .logo-img {
      width: 56px;
      height: 56px;
      object-fit: contain;
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(166, 27, 46, 0.4);
    }
  }

  .register-title {
    font-family: var(--font-serif);
    font-size: 28px;
    font-weight: 700;
    color: white;
    letter-spacing: 4px;
    margin-bottom: 8px;
  }

  .register-subtitle {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.4);
    letter-spacing: 3px;
  }
}

.register-form {
  .form-group {
    margin-bottom: 20px;

    .form-label {
      display: block;
      font-size: 13px;
      font-weight: 500;
      color: rgba(255, 255, 255, 0.5);
      margin-bottom: 8px;
      letter-spacing: 2px;
    }

    .form-input {
      width: 100%;
      height: 48px;
      background: rgba(255, 255, 255, 0.06);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: var(--radius-md);
      padding: 0 20px;
      font-size: 15px;
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

  .register-btn {
    width: 100%;
    height: 48px;
    background: var(--primary-color);
    color: white;
    border: none;
    border-radius: var(--radius-md);
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: var(--transition-normal);
    letter-spacing: 6px;
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

.register-footer {
  text-align: center;
  margin-top: 32px;
  padding-top: 24px;
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
  animation: formIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) calc(0.3s + var(--delay) * 0.08s) both;
}

.animate-btn {
  animation: btnIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) 0.6s both;
}

.animate-footer {
  animation: footerIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) 0.7s both;
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
  .register-card {
    width: 100%;
    padding: 36px 24px;
    border-radius: var(--radius-lg);
  }

  .register-header .register-title {
    font-size: 24px;
  }
}
</style>
