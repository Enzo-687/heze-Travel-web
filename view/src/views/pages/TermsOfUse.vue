<template>
  <PageLayout title="使用条款" subtitle="使用本平台服务前请仔细阅读">
    <div class="legal-content">
      <section class="content-section">
        <h2>一、接受条款</h2>
        <p>欢迎使用菏你同游在线旅游平台。通过访问或使用本平台服务，您表示同意接受本使用条款的约束。如您不同意本条款的任何内容，请立即停止使用本平台服务。</p>
      </section>

      <section class="content-section">
        <h2>二、服务说明</h2>
        <p>菏你同游是一个专注于菏泽地区旅游服务的在线平台，提供以下服务：</p>
        <ul>
          <li>菏泽地区景点信息查询与展示</li>
          <li>旅游攻略分享与浏览</li>
          <li>特色美食推荐</li>
          <li>景区门票在线预订</li>
          <li>用户社区互动交流</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>三、用户账户</h2>
        <p>使用本平台部分功能需要注册账户。您同意：</p>
        <ul>
          <li>提供真实、准确、完整的注册信息</li>
          <li>妥善保管账户密码，对账户下的所有活动负责</li>
          <li>不得将账户转让、出借或授权他人使用</li>
          <li>发现账户异常时立即通知我们</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>四、用户行为规范</h2>
        <p>使用本平台时，您同意不会：</p>
        <ul>
          <li>发布违法、侵权、虚假或误导性内容</li>
          <li>侵犯他人的知识产权、隐私权或其他合法权益</li>
          <li>使用自动化程序或工具恶意访问本平台</li>
          <li>干扰或破坏本平台的正常运行</li>
          <li>从事任何形式的欺诈活动</li>
          <li>传播病毒、木马或其他恶意软件</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>五、知识产权</h2>
        <p>本平台的所有内容，包括但不限于文字、图片、音频、视频、软件、商标等，均受知识产权法律保护。未经我们书面许可，您不得：</p>
        <ul>
          <li>复制、修改、传播本平台内容</li>
          <li>将本平台内容用于商业目的</li>
          <li>反向工程、反编译或反汇编本平台软件</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>六、免责声明</h2>
        <p>本平台尽力确保信息的准确性和及时性，但不保证：</p>
        <ul>
          <li>服务不会中断或无错误</li>
          <li>所有信息完全准确无误</li>
          <li>第三方链接的内容安全性和可靠性</li>
        </ul>
        <p>用户使用本平台服务所产生的风险由用户自行承担。</p>
      </section>

      <section class="content-section">
        <h2>七、服务变更与终止</h2>
        <p>我们保留随时修改、暂停或终止部分或全部服务的权利，恕不另行通知。对于免费服务，我们不承担因服务变更或终止而产生的任何责任。</p>
      </section>

      <section class="content-section">
        <h2>八、争议解决</h2>
        <p>本条款的订立、执行和解释均适用中华人民共和国法律。如发生争议，双方应友好协商解决；协商不成的，任何一方均可向本平台所在地人民法院提起诉讼。</p>
      </section>

      <section class="content-section">
        <h2>九、条款更新</h2>
        <p>我们可能会不时更新本使用条款。更新后的条款将在本页面发布，继续使用本平台服务即表示您接受更新后的条款。</p>
      </section>

      <div class="effective-date">
        <p>本条款最后更新日期：2026年4月29日</p>
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
