<template>
  <PageLayout title="隐私政策" subtitle="保护您的个人信息安全">
    <div class="legal-content">
      <section class="content-section">
        <h2>一、引言</h2>
        <p>菏你同游（以下简称"我们"或"本平台"）非常重视用户的隐私保护。本隐私政策旨在向您说明我们如何收集、使用、存储和保护您的个人信息。请您在使用我们的服务前仔细阅读本政策。</p>
      </section>

      <section class="content-section">
        <h2>二、信息收集</h2>
        <p>我们可能收集以下类型的信息：</p>
        <ul>
          <li><strong>账户信息</strong>：用户名、密码、邮箱地址、手机号码等注册信息</li>
          <li><strong>个人资料</strong>：头像、性别、生日等可选填写的个人信息</li>
          <li><strong>使用数据</strong>：浏览记录、搜索历史、收藏内容、订单记录等</li>
          <li><strong>设备信息</strong>：IP地址、浏览器类型、操作系统等技术信息</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>三、信息使用</h2>
        <p>我们使用您的个人信息用于以下目的：</p>
        <ul>
          <li>提供、维护和改进我们的服务</li>
          <li>处理您的订单和支付</li>
          <li>发送服务通知和营销信息（您可随时退订）</li>
          <li>个性化推荐和内容定制</li>
          <li>防止欺诈和保障账户安全</li>
          <li>遵守法律法规要求</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>四、信息共享</h2>
        <p>我们不会将您的个人信息出售给第三方。仅在以下情况下可能共享信息：</p>
        <ul>
          <li>经您明确同意</li>
          <li>与可信赖的合作伙伴共享（仅限于提供服务所必需）</li>
          <li>应法律法规要求或政府机关的合法要求</li>
          <li>保护我们的合法权益或用户安全</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>五、信息保护</h2>
        <p>我们采取多种安全措施保护您的个人信息：</p>
        <ul>
          <li>使用加密技术传输敏感数据</li>
          <li>实施严格的访问控制机制</li>
          <li>定期进行安全审计和漏洞扫描</li>
          <li>对员工进行数据安全培训</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>六、您的权利</h2>
        <p>您对自己的个人信息拥有以下权利：</p>
        <ul>
          <li>访问和查看您的个人信息</li>
          <li>更正不准确的个人信息</li>
          <li>删除您的个人信息（法律法规另有规定的除外）</li>
          <li>撤回同意授权</li>
          <li>注销账户</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>七、Cookie使用</h2>
        <p>我们使用Cookie和类似技术来改善用户体验、分析网站流量和个性化内容。您可以通过浏览器设置管理Cookie偏好。</p>
      </section>

      <section class="content-section">
        <h2>八、政策更新</h2>
        <p>我们可能会不时更新本隐私政策。更新后的政策将在本页面发布，重大变更将通过站内信或邮件通知您。</p>
      </section>

      <section class="content-section">
        <h2>九、联系我们</h2>
        <p>如您对本隐私政策有任何疑问，请通过以下方式联系我们：</p>
        <div class="contact-info">
          <p>邮箱：contact@hetongyou.com</p>
          <p>电话：0530-12345678</p>
          <p>地址：山东省菏泽市牡丹区</p>
        </div>
      </section>

      <div class="effective-date">
        <p>本政策最后更新日期：2026年4月29日</p>
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

.contact-info {
  background: #f8f5f0;
  padding: 20px 24px;
  border-radius: 8px;
  border-left: 3px solid #a61b2e;

  p {
    margin-bottom: 6px;
    font-size: 14px;

    &:last-child {
      margin-bottom: 0;
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
