<template>
  <PageLayout title="网站地图" subtitle="快速导航至平台各功能页面">
    <div class="sitemap-content">
      <div class="sitemap-grid">
        <div class="sitemap-group">
          <div class="group-header">
            <el-icon><Compass /></el-icon>
            <h3>探索发现</h3>
          </div>
          <ul class="group-links">
            <li><router-link to="/viewer">首页推荐</router-link></li>
            <li><router-link to="/viewer/scenic-spot">景点大全</router-link></li>
            <li><router-link to="/viewer/strategy">旅游攻略</router-link></li>
            <li><router-link to="/viewer/food">特色美食</router-link></li>
            <li><router-link to="/viewer-themes">主题旅游</router-link></li>
          </ul>
        </div>

        <div class="sitemap-group">
          <div class="group-header">
            <el-icon><User /></el-icon>
            <h3>用户服务</h3>
          </div>
          <ul class="group-links">
            <li><router-link to="/login">登录 / 注册</router-link></li>
            <li><router-link to="/user">个人中心</router-link></li>
            <li><router-link to="/user/user-collection">我的收藏</router-link></li>
            <li><router-link to="/user/user-order">我的订单</router-link></li>
            <li><router-link to="/user/user-strategy">我的攻略</router-link></li>
          </ul>
        </div>

        <div class="sitemap-group">
          <div class="group-header">
            <el-icon><InfoFilled /></el-icon>
            <h3>关于我们</h3>
          </div>
          <ul class="group-links">
            <li><router-link to="/about">平台简介</router-link></li>
            <li><router-link to="/contact">联系我们</router-link></li>
            <li><router-link to="/join">加入我们</router-link></li>
            <li><router-link to="/partners">合作伙伴</router-link></li>
          </ul>
        </div>

        <div class="sitemap-group">
          <div class="group-header">
            <el-icon><Document /></el-icon>
            <h3>法律条款</h3>
          </div>
          <ul class="group-links">
            <li><router-link to="/privacy">隐私政策</router-link></li>
            <li><router-link to="/terms">使用条款</router-link></li>
            <li><router-link to="/disclaimer">免责声明</router-link></li>
            <li><router-link to="/copyright">版权声明</router-link></li>
          </ul>
        </div>
      </div>

      <div class="sitemap-footer-note">
        <p>如您在浏览过程中遇到任何问题，欢迎通过 <router-link to="/contact">联系我们</router-link> 页面与我们取得联系。</p>
      </div>
    </div>
  </PageLayout>
</template>

<script setup lang="ts">
import PageLayout from '@/components/PageLayout.vue'
import { Compass, User, InfoFilled, Document } from '@element-plus/icons-vue'
</script>

<style scoped lang="scss">
.sitemap-content {
  padding: 20px 0;
}

.sitemap-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 40px;
  margin-bottom: 48px;
}

.sitemap-group {
  background: white;
  border-radius: 12px;
  padding: 32px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 1px solid rgba(166, 27, 46, 0.06);
  transition: all 0.3s ease;

  &:hover {
    box-shadow: 0 8px 32px rgba(166, 27, 46, 0.08);
    transform: translateY(-2px);
  }

  .group-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 2px solid rgba(166, 27, 46, 0.08);

    .el-icon {
      font-size: 24px;
      color: #a61b2e;
    }

    h3 {
      font-family: 'Noto Serif SC', serif;
      font-size: 20px;
      font-weight: 600;
      color: #1a1a2e;
      margin: 0;
    }
  }

  .group-links {
    list-style: none;
    padding: 0;
    margin: 0;

    li {
      margin-bottom: 12px;

      a {
        color: #555;
        text-decoration: none;
        font-size: 15px;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all 0.25s;
        padding: 6px 0;

        &::before {
          content: '';
          width: 6px;
          height: 6px;
          border-radius: 50%;
          background: #ddd;
          transition: all 0.25s;
        }

        &:hover {
          color: #a61b2e;
          padding-left: 8px;

          &::before {
            background: #a61b2e;
          }
        }
      }
    }
  }
}

.sitemap-footer-note {
  text-align: center;
  padding: 24px;
  background: #f8f5f0;
  border-radius: 8px;

  p {
    font-size: 14px;
    color: #666;
    margin: 0;

    a {
      color: #a61b2e;
      text-decoration: none;
      font-weight: 500;

      &:hover {
        text-decoration: underline;
      }
    }
  }
}

@media (max-width: 768px) {
  .sitemap-grid {
    grid-template-columns: 1fr;
    gap: 24px;
  }

  .sitemap-group {
    padding: 24px;

    .group-header h3 {
      font-size: 18px;
    }

    .group-links li a {
      font-size: 14px;
    }
  }
}
</style>
