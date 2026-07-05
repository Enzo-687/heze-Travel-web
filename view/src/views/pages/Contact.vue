<template>
  <PageLayout title="联系我们" subtitle="我们期待听到您的声音">
    <div class="contact-content">
      <div class="contact-grid">
        <div class="contact-info-card">
          <h3>联系方式</h3>
          <div class="info-list">
            <div class="info-item">
              <div class="info-icon">
                <el-icon><Phone /></el-icon>
              </div>
              <div class="info-text">
                <span class="label">客服电话</span>
                <span class="value">0530-12345678</span>
                <span class="note">工作日 9:00-18:00</span>
              </div>
            </div>
            <div class="info-item">
              <div class="info-icon">
                <el-icon><Message /></el-icon>
              </div>
              <div class="info-text">
                <span class="label">电子邮箱</span>
                <span class="value">contact@hetongyou.com</span>
                <span class="note">24小时内回复</span>
              </div>
            </div>
            <div class="info-item">
              <div class="info-icon">
                <el-icon><Location /></el-icon>
              </div>
              <div class="info-text">
                <span class="label">公司地址</span>
                <span class="value">山东省菏泽市牡丹区中华路888号</span>
                <span class="note">菏你同游总部</span>
              </div>
            </div>
          </div>
        </div>

        <div class="contact-form-card">
          <h3>在线留言</h3>
          <el-form :model="form" label-position="top" class="contact-form">
            <el-form-item label="您的姓名">
              <el-input v-model="form.name" placeholder="请输入您的姓名" />
            </el-form-item>
            <el-form-item label="联系邮箱">
              <el-input v-model="form.email" placeholder="请输入您的邮箱" />
            </el-form-item>
            <el-form-item label="留言类型">
              <el-select v-model="form.type" placeholder="请选择留言类型" style="width: 100%">
                <el-option label="业务合作" value="cooperation" />
                <el-option label="意见反馈" value="feedback" />
                <el-option label="投诉建议" value="complaint" />
                <el-option label="其他" value="other" />
              </el-select>
            </el-form-item>
            <el-form-item label="留言内容">
              <el-input
                v-model="form.content"
                type="textarea"
                :rows="4"
                placeholder="请输入您的留言内容"
              />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" class="submit-btn" @click="submitForm">
                提交留言
              </el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </div>
  </PageLayout>
</template>

<script setup lang="ts">
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'
import PageLayout from '@/components/PageLayout.vue'
import { Phone, Message, Location } from '@element-plus/icons-vue'

const form = reactive({
  name: '',
  email: '',
  type: '',
  content: ''
})

const submitForm = () => {
  if (!form.name || !form.email || !form.content) {
    ElMessage.warning('请填写完整信息')
    return
  }
  ElMessage.success('留言提交成功，我们会尽快与您联系')
  form.name = ''
  form.email = ''
  form.type = ''
  form.content = ''
}
</script>

<style scoped lang="scss">
.contact-content {
  padding: 20px 0;
}

.contact-grid {
  display: grid;
  grid-template-columns: 380px 1fr;
  gap: 40px;
}

.contact-info-card,
.contact-form-card {
  background: white;
  border-radius: 12px;
  padding: 36px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid rgba(166, 27, 46, 0.06);

  h3 {
    font-family: 'Noto Serif SC', serif;
    font-size: 20px;
    font-weight: 600;
    color: #1a1a2e;
    margin-bottom: 28px;
    padding-bottom: 16px;
    border-bottom: 2px solid rgba(166, 27, 46, 0.08);
  }
}

.info-list {
  display: flex;
  flex-direction: column;
  gap: 28px;
}

.info-item {
  display: flex;
  gap: 16px;

  .info-icon {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    background: rgba(166, 27, 46, 0.06);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;

    .el-icon {
      font-size: 22px;
      color: #a61b2e;
    }
  }

  .info-text {
    display: flex;
    flex-direction: column;
    gap: 4px;

    .label {
      font-size: 13px;
      color: #999;
    }

    .value {
      font-size: 15px;
      font-weight: 500;
      color: #1a1a2e;
    }

    .note {
      font-size: 12px;
      color: #bbb;
    }
  }
}

.contact-form {
  .submit-btn {
    width: 100%;
    height: 44px;
    font-size: 15px;
    background: #a61b2e;
    border-color: #a61b2e;

    &:hover {
      background: #8a1626;
      border-color: #8a1626;
    }
  }
}

@media (max-width: 768px) {
  .contact-grid {
    grid-template-columns: 1fr;
    gap: 24px;
  }

  .contact-info-card,
  .contact-form-card {
    padding: 24px;
  }
}
</style>
