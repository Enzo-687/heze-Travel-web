<template>
  <PageLayout title="合作伙伴" subtitle="携手共进，共创未来">
    <div class="partners-content">
      <section class="partners-intro">
        <p class="lead">
          菏你同游的发展离不开众多合作伙伴的支持。我们与景区、酒店、餐饮、交通等行业的优质企业建立了深度合作关系，
          共同为用户提供更优质的旅游体验。
        </p>
      </section>

      <section class="partners-section">
        <h3>合作类型</h3>
        <div class="partner-type-grid">
          <div class="type-card">
            <div class="type-icon">🏞️</div>
            <h4>景区合作</h4>
            <p>与菏泽及周边地区知名景区建立战略合作，为用户提供门票预订、专属优惠等服务</p>
          </div>
          <div class="type-card">
            <div class="type-icon">🏨</div>
            <h4>酒店合作</h4>
            <p>整合优质住宿资源，从精品民宿到星级酒店，满足不同用户需求</p>
          </div>
          <div class="type-card">
            <div class="type-icon">🍽️</div>
            <h4>餐饮合作</h4>
            <p>挖掘地道菏泽美食，与特色餐厅合作推出专属优惠和套餐</p>
          </div>
          <div class="type-card">
            <div class="type-icon">🚌</div>
            <h4>交通合作</h4>
            <p>与交通运营商合作，提供便捷的出行方案和接驳服务</p>
          </div>
        </div>
      </section>

      <section class="partners-section">
        <h3>合作优势</h3>
        <div class="advantage-list">
          <div class="advantage-item">
            <div class="advantage-number">01</div>
            <div class="advantage-text">
              <h4>精准流量</h4>
              <p>平台拥有大量精准的旅游用户群体，为合作伙伴带来高质量客流</p>
            </div>
          </div>
          <div class="advantage-item">
            <div class="advantage-number">02</div>
            <div class="advantage-text">
              <h4>品牌曝光</h4>
              <p>通过平台多渠道推广，提升合作伙伴的品牌知名度和影响力</p>
            </div>
          </div>
          <div class="advantage-item">
            <div class="advantage-number">03</div>
            <div class="advantage-text">
              <h4>数据支持</h4>
              <p>提供用户行为数据分析，帮助合作伙伴优化产品和服务</p>
            </div>
          </div>
          <div class="advantage-item">
            <div class="advantage-number">04</div>
            <div class="advantage-text">
              <h4>技术赋能</h4>
              <p>提供在线预订、电子票务等技术解决方案，提升运营效率</p>
            </div>
          </div>
        </div>
      </section>

      <section class="partners-section">
        <h3>合作联系</h3>
        <div class="cooperation-card">
          <p>如果您希望与菏你同游建立合作关系，欢迎通过以下方式联系我们：</p>
          <div class="cooperation-info">
            <div class="coop-item">
              <el-icon><User /></el-icon>
              <span>商务合作：张先生</span>
            </div>
            <div class="coop-item">
              <el-icon><Phone /></el-icon>
              <span>电话：0530-87654321</span>
            </div>
            <div class="coop-item">
              <el-icon><Message /></el-icon>
              <span>邮箱：business@hetongyou.com</span>
            </div>
          </div>
          <p class="coop-note">我们期待与您携手，共同推动菏泽旅游产业的发展。</p>
        </div>
      </section>
    </div>
  </PageLayout>
</template>

<script setup lang="ts">
import PageLayout from '@/components/PageLayout.vue'
import { User, Phone, Message } from '@element-plus/icons-vue'
</script>

<style scoped lang="scss">
.partners-content {
  color: #333;
}

.partners-intro {
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

.partners-section {
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

.partner-type-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;

  .type-card {
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

    .type-icon {
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

.advantage-list {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.advantage-item {
  display: flex;
  gap: 24px;
  background: white;
  padding: 28px 32px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid rgba(166, 27, 46, 0.06);
  transition: all 0.3s ease;

  &:hover {
    box-shadow: 0 8px 32px rgba(166, 27, 46, 0.08);
  }

  .advantage-number {
    font-family: 'Noto Serif SC', serif;
    font-size: 36px;
    font-weight: 700;
    color: rgba(166, 27, 46, 0.15);
    line-height: 1;
    flex-shrink: 0;
    width: 60px;
  }

  .advantage-text {
    h4 {
      font-size: 18px;
      font-weight: 600;
      color: #1a1a2e;
      margin-bottom: 8px;
    }

    p {
      font-size: 14px;
      color: #888;
      line-height: 1.6;
      margin: 0;
    }
  }
}

.cooperation-card {
  background: white;
  padding: 36px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid rgba(166, 27, 46, 0.06);
  text-align: center;

  p {
    font-size: 15px;
    color: #555;
    margin-bottom: 24px;
  }

  .cooperation-info {
    display: flex;
    justify-content: center;
    gap: 40px;
    margin-bottom: 24px;

    .coop-item {
      display: flex;
      align-items: center;
      gap: 8px;

      .el-icon {
        font-size: 18px;
        color: #a61b2e;
      }

      span {
        font-size: 15px;
        color: #1a1a2e;
        font-weight: 500;
      }
    }
  }

  .coop-note {
    font-size: 13px;
    color: #999;
    margin-bottom: 0;
  }
}

@media (max-width: 768px) {
  .partner-type-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;

    .type-card {
      padding: 24px 16px;
    }
  }

  .advantage-item {
    flex-direction: column;
    gap: 12px;
    padding: 24px;

    .advantage-number {
      font-size: 28px;
      width: auto;
    }
  }

  .cooperation-card {
    padding: 24px;

    .cooperation-info {
      flex-direction: column;
      gap: 16px;
    }
  }
}
</style>
