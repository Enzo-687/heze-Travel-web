<template>
  <PageLayout title="加入我们" subtitle="与我们一起，讲好菏泽故事">
    <div class="join-content">
      <section class="join-intro">
        <p class="lead">
          菏你同游正处于快速发展阶段，我们期待充满激情、热爱旅游和文化的你加入团队。
          在这里，你不仅能获得有竞争力的薪酬福利，更能参与打造一座城市的旅游名片。
        </p>
      </section>

      <section class="join-section">
        <h3>为什么选择我们</h3>
        <div class="benefit-grid">
          <div class="benefit-card">
            <div class="benefit-icon">🚀</div>
            <h4>快速成长</h4>
            <p>处于行业上升期，个人发展空间广阔</p>
          </div>
          <div class="benefit-card">
            <div class="benefit-icon">💡</div>
            <h4>创新氛围</h4>
            <p>鼓励创新思维，支持技术探索</p>
          </div>
          <div class="benefit-card">
            <div class="benefit-icon">🌸</div>
            <h4>文化底蕴</h4>
            <p>深耕牡丹文化，工作充满意义</p>
          </div>
          <div class="benefit-card">
            <div class="benefit-icon">🤝</div>
            <h4>团队氛围</h4>
            <p>扁平化管理，开放协作文化</p>
          </div>
        </div>
      </section>

      <section class="join-section">
        <h3>热招职位</h3>
        <div class="job-list">
          <div class="job-card">
            <div class="job-header">
              <h4>前端开发工程师</h4>
              <span class="job-tag">技术部</span>
            </div>
            <div class="job-meta">
              <span>📍 菏泽</span>
              <span>💼 全职</span>
              <span>💰 8K-15K</span>
            </div>
            <p class="job-desc">
              负责平台前端架构设计与开发，优化用户体验，参与产品技术决策。
            </p>
            <div class="job-requirements">
              <span>Vue3</span>
              <span>TypeScript</span>
              <span>Element Plus</span>
            </div>
          </div>

          <div class="job-card">
            <div class="job-header">
              <h4>后端开发工程师</h4>
              <span class="job-tag">技术部</span>
            </div>
            <div class="job-meta">
              <span>📍 菏泽</span>
              <span>💼 全职</span>
              <span>💰 10K-18K</span>
            </div>
            <p class="job-desc">
              负责服务端架构设计与API开发，保障系统稳定性与性能优化。
            </p>
            <div class="job-requirements">
              <span>Java</span>
              <span>Spring Boot</span>
              <span>MySQL</span>
            </div>
          </div>

          <div class="job-card">
            <div class="job-header">
              <h4>内容运营专员</h4>
              <span class="job-tag">运营部</span>
            </div>
            <div class="job-meta">
              <span>📍 菏泽</span>
              <span>💼 全职</span>
              <span>💰 5K-8K</span>
            </div>
            <p class="job-desc">
              负责旅游攻略内容策划与审核，维护社区氛围，提升用户活跃度。
            </p>
            <div class="job-requirements">
              <span>文案写作</span>
              <span>内容策划</span>
              <span>数据分析</span>
            </div>
          </div>

          <div class="job-card">
            <div class="job-header">
              <h4>旅游产品经理</h4>
              <span class="job-tag">产品部</span>
            </div>
            <div class="job-meta">
              <span>📍 菏泽</span>
              <span>💼 全职</span>
              <span>💰 12K-20K</span>
            </div>
            <p class="job-desc">
              负责旅游产品线规划与设计，深入洞察用户需求，推动产品迭代。
            </p>
            <div class="job-requirements">
              <span>产品设计</span>
              <span>用户研究</span>
              <span>数据分析</span>
            </div>
          </div>
        </div>
      </section>

      <section class="join-section">
        <h3>应聘方式</h3>
        <div class="apply-card">
          <p>请将您的简历发送至招聘邮箱，邮件标题请注明应聘职位：</p>
          <div class="apply-email">
            <el-icon><Message /></el-icon>
            <span>hr@hetongyou.com</span>
          </div>
          <p class="apply-note">我们将在收到简历后的5个工作日内与您联系。</p>
        </div>
      </section>
    </div>
  </PageLayout>
</template>

<script setup lang="ts">
import PageLayout from '@/components/PageLayout.vue'
import { Message } from '@element-plus/icons-vue'
</script>

<style scoped lang="scss">
.join-content {
  color: #333;
}

.join-intro {
  margin-bottom: 48px;

  .lead {
    font-size: 17px;
    color: #555;
    line-height: 1.8;
    text-align: center;
    max-width: 700px;
    margin: 0 auto;
  }
}

.join-section {
  margin-bottom: 56px;

  h3 {
    font-family: 'Noto Serif SC', serif;
    font-size: 24px;
    font-weight: 600;
    color: #1a1a2e;
    margin-bottom: 28px;
    padding-bottom: 12px;
    border-bottom: 2px solid rgba(166, 27, 46, 0.1);
  }
}

.benefit-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;

  .benefit-card {
    background: white;
    padding: 32px 24px;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
    border: 1px solid rgba(166, 27, 46, 0.06);
    transition: all 0.3s ease;

    &:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 32px rgba(166, 27, 46, 0.1);
    }

    .benefit-icon {
      font-size: 36px;
      margin-bottom: 16px;
    }

    h4 {
      font-size: 17px;
      font-weight: 600;
      color: #1a1a2e;
      margin-bottom: 8px;
    }

    p {
      font-size: 13px;
      color: #888;
      line-height: 1.6;
      margin: 0;
    }
  }
}

.job-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.job-card {
  background: white;
  padding: 28px 32px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid rgba(166, 27, 46, 0.06);
  transition: all 0.3s ease;

  &:hover {
    box-shadow: 0 8px 32px rgba(166, 27, 46, 0.08);
  }

  .job-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 12px;

    h4 {
      font-size: 18px;
      font-weight: 600;
      color: #1a1a2e;
      margin: 0;
    }

    .job-tag {
      font-size: 12px;
      color: #a61b2e;
      background: rgba(166, 27, 46, 0.08);
      padding: 4px 12px;
      border-radius: 100px;
    }
  }

  .job-meta {
    display: flex;
    gap: 20px;
    margin-bottom: 12px;

    span {
      font-size: 13px;
      color: #888;
    }
  }

  .job-desc {
    font-size: 14px;
    color: #666;
    line-height: 1.6;
    margin-bottom: 16px;
  }

  .job-requirements {
    display: flex;
    gap: 8px;

    span {
      font-size: 12px;
      color: #a61b2e;
      background: rgba(166, 27, 46, 0.06);
      padding: 4px 10px;
      border-radius: 4px;
    }
  }
}

.apply-card {
  background: white;
  padding: 32px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid rgba(166, 27, 46, 0.06);
  text-align: center;

  p {
    font-size: 15px;
    color: #555;
    margin-bottom: 20px;
  }

  .apply-email {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    background: rgba(166, 27, 46, 0.06);
    padding: 14px 28px;
    border-radius: 8px;
    margin-bottom: 16px;

    .el-icon {
      font-size: 20px;
      color: #a61b2e;
    }

    span {
      font-size: 18px;
      font-weight: 600;
      color: #a61b2e;
    }
  }

  .apply-note {
    font-size: 13px;
    color: #999;
    margin-bottom: 0;
  }
}

@media (max-width: 768px) {
  .benefit-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;

    .benefit-card {
      padding: 24px 16px;
    }
  }

  .job-card {
    padding: 20px 24px;

    .job-meta {
      flex-wrap: wrap;
      gap: 12px;
    }
  }
}
</style>
