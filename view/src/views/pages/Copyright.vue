<template>
  <PageLayout title="版权声明" subtitle="保护知识产权，尊重原创">
    <div class="legal-content">
      <section class="content-section">
        <h2>一、版权声明</h2>
        <p>菏你同游在线旅游平台（以下简称"本平台"）的所有内容，包括但不限于文字、图片、音频、视频、图表、标识、软件、代码等，均受中华人民共和国著作权法、商标法、专利法等相关法律法规保护。</p>
        <p>未经本平台书面许可，任何单位或个人不得以任何形式复制、转载、摘编、传播或用于商业用途。</p>
      </section>

      <section class="content-section">
        <h2>二、平台内容权属</h2>
        <p>本平台内容的知识产权归属如下：</p>
        <ul>
          <li><strong>平台原创内容</strong>：版权归本平台所有</li>
          <li><strong>用户生成内容</strong>：版权归原作者所有，用户授权本平台在平台范围内使用</li>
          <li><strong>合作方内容</strong>：版权归合作方所有，本平台获得合法授权</li>
          <li><strong>第三方内容</strong>：版权归原作者所有，本平台仅提供展示</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>三、商标声明</h2>
        <p>"菏你同游"、平台Logo及相关标识均为本平台的注册商标或商标。未经本平台书面许可，任何单位或个人不得：</p>
        <ul>
          <li>使用、复制、修改本平台商标</li>
          <li>将本平台商标用于商业推广</li>
          <li>注册与本平台商标相似的标识</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>四、用户内容授权</h2>
        <p>用户在本平台发布的内容（如攻略、评论、图片等），即表示您：</p>
        <ul>
          <li>保证拥有该内容的合法权利或已获得必要授权</li>
          <li>授予本平台非独占、可转让、可再许可的使用权</li>
          <li>同意本平台在平台范围内展示、传播您的内容</li>
          <li>同意本平台为推广目的使用您的内容（会注明作者）</li>
        </ul>
      </section>

      <section class="content-section">
        <h2>五、侵权处理</h2>
        <p>如您认为本平台的内容侵犯了您的知识产权，请通过以下方式联系我们：</p>
        <div class="contact-info">
          <p>邮箱：contact@hetongyou.com</p>
          <p>电话：0530-12345678</p>
        </div>
        <p>投诉时请提供以下材料：</p>
        <ul>
          <li>您的身份证明和联系方式</li>
          <li>被侵权作品的权属证明</li>
          <li>侵权内容的具体位置和链接</li>
          <li>侵权事实的详细说明</li>
        </ul>
        <p>我们将在收到完整材料后的7个工作日内进行处理。</p>
      </section>

      <section class="content-section">
        <h2>六、免责条款</h2>
        <p>本平台尽力确保所有内容的合法性，但无法对所有内容的版权状况进行逐一核实。如您发现侵权内容，请及时通知我们，我们将依法处理。</p>
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

.contact-info {
  background: #f8f5f0;
  padding: 20px 24px;
  border-radius: 8px;
  border-left: 3px solid #a61b2e;
  margin: 16px 0;

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
