<script setup lang="ts">
import { RouterView } from 'vue-router'

const themeOverrides = {
  '--el-color-primary': '#A61B2E',
  '--el-color-primary-light-3': '#C4364A',
  '--el-color-primary-light-5': '#D45D6E',
  '--el-color-primary-light-7': '#E38995',
  '--el-color-primary-light-8': '#EAA0AA',
  '--el-color-primary-light-9': '#F1B7BE',
  '--el-color-primary-dark-2': '#7A1220',
  '--el-border-radius-base': '8px',
  '--el-border-radius-small': '6px',
  '--el-border-radius-round': '20px',
  '--el-font-family': "'Inter', 'PingFang SC', 'Microsoft YaHei', sans-serif",
}
</script>

<template>
  <el-config-provider :namespace="undefined" :theme-overrides="themeOverrides">
    <router-view />
  </el-config-provider>
</template>

<style>
#app {
  width: 100%;
}
</style>
