<template>
  <PageLayout title="平台简介" subtitle="了解菏你同游的故事与使命">
    <div class="about-content">
      <section class="about-hero">
        <div class="hero-text">
          <h2>千年古韵 · 牡丹花城</h2>
          <p class="lead">
            菏你同游是专注于菏泽地区旅游服务的在线平台，致力于向世界展示菏泽的独特魅力，
            让每一位游客都能深入体验这座千年古城的文化底蕴与自然风光。
          </p>
        </div>
        <div class="hero-stats">
          <div class="stat-item">
            <span class="stat-number">100+</span>
            <span class="stat-label">精选景点</span>
          </div>
          <div class="stat-item">
            <span class="stat-number">50+</span>
            <span class="stat-label">特色美食</span>
          </div>
          <div class="stat-item">
            <span class="stat-number">1000+</span>
            <span class="stat-label">旅游攻略</span>
          </div>
          <div class="stat-item">
            <span class="stat-number">10万+</span>
            <span class="stat-label">服务用户</span>
          </div>
        </div>
      </section>

      <section class="about-section">
        <h3>我们的使命</h3>
        <p>
          菏你同游诞生于对家乡菏泽的深厚情感。我们希望借助互联网技术，
          打破信息壁垒，让更多人了解菏泽、走进菏泽、爱上菏泽。
          从牡丹花海的绚烂到红色热土的庄严，从非遗传承的匠心到美食文化的醇厚，
          我们用心记录菏泽的每一处精彩。
        </p>
      </section>

      <section class="about-section">
        <h3>平台特色</h3>
        <div class="feature-grid">
          <div class="feature-card">
            <div class="feature-icon">🌸</div>
            <h4>牡丹文化</h4>
            <p>深度挖掘菏泽牡丹文化，提供最佳赏花路线和花期预报</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">🏛️</div>
            <h4>红色旅游</h4>
            <p>整合革命老区资源，打造沉浸式红色教育体验</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">🎨</div>
            <h4>非遗传承</h4>
            <p>展示面塑、剪纸等传统工艺，连接匠人与游客</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">🍜</div>
            <h4>美食探索</h4>
            <p>汇聚地道菏泽美食，从街头小吃到特色宴席</p>
          </div>
        </div>
      </section>

      <section class="about-section">
        <h3>发展历程</h3>
        <div class="timeline">
          <div class="timeline-item">
            <div class="timeline-dot"></div>
            <div class="timeline-content">
              <span class="timeline-date">2024年</span>
              <h4>平台创立</h4>
              <p>菏你同游正式上线，开启菏泽智慧旅游新篇章</p>
            </div>
          </div>
          <div class="timeline-item">
            <div class="timeline-dot"></div>
            <div class="timeline-content">
              <span class="timeline-date">2025年</span>
              <h4>服务升级</h4>
              <p>接入在线预订、AI导游等创新功能，服务用户突破5万</p>
            </div>
          </div>
          <div class="timeline-item">
            <div class="timeline-dot"></div>
            <div class="timeline-content">
              <span class="timeline-date">2026年</span>
              <h4>生态完善</h4>
              <p>构建完整旅游生态，成为菏泽地区领先的旅游服务平台</p>
            </div>
          </div>
        </div>
      </section>

      <section class="about-section">
        <h3>联系我们</h3>
        <div class="contact-grid">
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
      </section>
    </div>
  </PageLayout>
</template>

<script setup lang="ts">
import PageLayout from '@/components/PageLayout.vue'
import { Phone, Message, Location } from '@element-plus/icons-vue'
</script>

<style scoped lang="scss">
.about-content {
  color: #333;
}

.about-hero {
  text-align: center;
  margin-bottom: 60px;

  .hero-text {
    h2 {
      font-family: 'Noto Serif SC', serif;
      font-size: 32px;
      font-weight: 600;
      color: #1a1a2e;
      margin-bottom: 20px;
    }

    .lead {
      font-size: 17px;
      color: #666;
      line-height: 1.8;
      max-width: 700px;
      margin: 0 auto;
    }
  }

  .hero-stats {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 24px;
    margin-top: 48px;

    .stat-item {
      background: white;
      padding: 28px 20px;
      border-radius: 12px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
      border: 1px solid rgba(166, 27, 46, 0.06);

      .stat-number {
        display: block;
        font-family: 'Noto Serif SC', serif;
        font-size: 32px;
        font-weight: 700;
        color: #a61b2e;
        margin-bottom: 8px;
      }

      .stat-label {
        font-size: 14px;
        color: #888;
      }
    }
  }
}

.about-section {
  margin-bottom: 56px;

  h3 {
    font-family: 'Noto Serif SC', serif;
    font-size: 24px;
    font-weight: 600;
    color: #1a1a2e;
    margin-bottom: 24px;
    padding-bottom: 12px;
    border-bottom: 2px solid rgba(166, 27, 46, 0.1);
  }

  p {
    font-size: 15px;
    color: #555;
    line-height: 1.8;
  }
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;

  .feature-card {
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

    .feature-icon {
      font-size: 40px;
      margin-bottom: 16px;
    }

    h4 {
      font-size: 17px;
      font-weight: 600;
      color: #1a1a2e;
      margin-bottom: 10px;
    }

    p {
      font-size: 13px;
      color: #888;
      line-height: 1.6;
      margin: 0;
    }
  }
}

.timeline {
  position: relative;
  padding-left: 32px;

  &::before {
    content: '';
    position: absolute;
    left: 6px;
    top: 8px;
    bottom: 8px;
    width: 2px;
    background: rgba(166, 27, 46, 0.15);
  }

  .timeline-item {
    position: relative;
    margin-bottom: 36px;

    &:last-child {
      margin-bottom: 0;
    }

    .timeline-dot {
      position: absolute;
      left: -32px;
      top: 6px;
      width: 14px;
      height: 14px;
      border-radius: 50%;
      background: #a61b2e;
      border: 3px solid #f8f5f0;
      box-shadow: 0 0 0 2px rgba(166, 27, 46, 0.2);
    }

    .timeline-content {
      .timeline-date {
        display: inline-block;
        font-size: 13px;
        font-weight: 600;
        color: #a61b2e;
        background: rgba(166, 27, 46, 0.08);
        padding: 4px 12px;
        border-radius: 100px;
        margin-bottom: 8px;
      }

      h4 {
        font-size: 18px;
        font-weight: 600;
        color: #1a1a2e;
        margin-bottom: 6px;
      }

      p {
        font-size: 14px;
        color: #888;
        margin: 0;
      }
    }
  }
}

.contact-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;

  .contact-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 20px 24px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
    border: 1px solid rgba(166, 27, 46, 0.06);

    .el-icon {
      font-size: 22px;
      color: #a61b2e;
    }

    span {
      font-size: 15px;
      color: #555;
    }
  }
}

@media (max-width: 768px) {
  .about-hero {
    .hero-stats {
      grid-template-columns: repeat(2, 1fr);
      gap: 16px;

      .stat-item {
        padding: 20px 16px;

        .stat-number {
          font-size: 24px;
        }
      }
    }
  }

  .feature-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;

    .feature-card {
      padding: 24px 16px;
    }
  }

  .contact-grid {
    grid-template-columns: 1fr;
  }
}
</style>
