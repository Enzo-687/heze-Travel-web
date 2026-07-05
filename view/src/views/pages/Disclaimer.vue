<template>
  <PageLayout title="免责声明" subtitle="使用本平台服务前请知悉">
    <div class="legal-content">
      <section class="content-section">
        <h2>一、总则</h2>
        <p>本免责声明（以下简称"声明"）适用于菏你同游在线旅游平台（以下简称"本平台"）提供的所有服务。访问和使用本平台即表示您已阅读、理解并同意接受本声明的全部内容。</p>
      </section>

      <section class="content-section">
        <h2>二、信息准确性</h2>
        <p>本平台尽力确保所提供信息的准确性和完整性，包括但不限于：</p>
        <ul>
          <li>景点介绍、开放时间、门票价格</li>
          <li>旅游攻略、路线推荐</li>
          <li>美食推荐、商家信息</li>
          <li>交通信息、住宿推荐</li>
        </ul>
        <p>但由于信息来源多样且可能随时变化，我们无法保证所有信息始终完全准确。建议您在出行前通过官方渠道核实相关信息。</p>
      </section>

      <section class="content-section">
        <h2>三、第三方内容</h2>
        <p>本平台包含用户生成的内容（如攻略、评论、图片等），以及指向第三方网站的链接。对于此类内容和链接：</p>
        <ul>
          <li>不代表本平台的观点或立场</li>
          <li>其准确性和合法性由发布者或第三方负责</li>
          <li>访问第三方网站的风险由用户自行承担</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>四、服务中断</h2>
        <p>我们不保证服务不会中断或出现故障。对于因以下原因导致的服务中断，我们不承担责任：</p>
        <ul>
          <li>系统维护、升级或故障</li>
          <li>不可抗力因素（自然灾害、战争等）</li>
          <li>网络运营商或第三方服务故障</li>
          <li>黑客攻击、计算机病毒等安全事件</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>五、交易风险</h2>
        <p>通过本平台进行的门票预订等交易，我们仅提供平台技术服务。对于交易过程中产生的纠纷：</p>
        <ul>
          <li>因商家原因导致的退款、服务质量问题，由商家承担相应责任</li>
          <li>因用户自身原因导致的损失，由用户自行承担</li>
          <li>我们将尽力协助双方解决争议，但不承担连带责任</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>六、人身财产安全</h2>
        <p>本平台提供的旅游信息仅供参考，不构成专业旅行建议。用户在旅行过程中应注意：</p>
        <ul>
          <li>遵守当地法律法规和景区规定</li>
          <li>注意人身和财产安全</li>
          <li>购买适当的旅行保险</li>
          <li>根据自身健康状况选择合适的旅游项目</li>
        </ul>
        <p>对于用户在旅行过程中发生的任何人身伤害或财产损失，我们不承担责任。</p>
      </section>

      <section class="content-section">
        <h2>七、责任限制</h2>
        <p>在法律允许的最大范围内，我们对以下损失不承担责任：</p>
        <ul>
          <li>直接、间接、偶然、特殊或后果性损失</li>
          <li>利润损失、数据丢失或商誉损害</li>
          <li>因使用或无法使用本平台服务而产生的任何损失</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>八、声明更新</h2>
        <p>我们保留随时更新本声明的权利。更新后的声明将在本页面发布，继续使用本平台服务即表示您接受更新后的声明。</p>
      </section>

      <div class="effective-date">
        <p>本声明最后更新日期：2026年4月29日</p>
      </div>
    </div>
  </PageLayout>
</template>

<script setup lang="ts">
import PageLayout from '@/components/PageLayout.vue'
</script>

<style scoped lang="scss">
.legal-content {
  color: #333;
  line-height: 1.8;
}

.content-section {
  margin-bottom: 40px;

  h2 {
    font-family: 'Noto Serif SC', serif;
    font-size: 22px;
    font-weight: 600;
    color: #1a1a2e;
    margin-bottom: 16px;
    padding-bottom: 8px;
    border-bottom: 2px solid rgba(166, 27, 46, 0.1);
  }

  p {
    font-size: 15px;
    color: #555;
    margin-bottom: 12px;
  }

  ul {
    padding-left: 24px;
    margin-bottom: 16px;

    li {
      font-size: 15px;
      color: #555;
      margin-bottom: 8px;

      strong {
        color: #a61b2e;
        font-weight: 600;
      }
    }
  }
}

.effective-date {
  margin-top: 48px;
  padding-top: 24px;
  border-top: 1px solid #eee;
  text-align: center;

  p {
    font-size: 14px;
    color: #999;
  }
}

@media (max-width: 768px) {
  .content-section h2 {
    font-size: 18px;
  }

  .content-section p,
  .content-section ul li {
    font-size: 14px;
  }
}
</style>
