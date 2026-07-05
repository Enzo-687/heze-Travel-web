<template>
  <div class="strategy-container">
    <ScenicSpotStrategyItem
      key="hot-scenic-spot-strategy"
      @view="viewStrategy"
      @search="goScenicSpotStrategySearch"
      title="热门攻略"
      subTitle="旅行者都在看的精选攻略"
      badge="HOT"
      :scenic-spot-strategy-list="hotScenicSpotStrategyList"
    />
    <ScenicSpotStrategyItem
      key="last-scenic-spot-strategy"
      @view="viewStrategy"
      @search="goScenicSpotStrategySearch"
      title="最新攻略"
      subTitle="新鲜出炉的旅行心得"
      badge="NEW"
      :scrollable="true"
      :scenic-spot-strategy-list="lastScenicSpotStrategyList"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from "vue"
import ScenicSpotStrategyItem from "@/components/ScenicSpotStrategyItem.vue"
import { useRouter } from "vue-router"
import type { ScenicSpotStrategyListVO, ScenicSpotStrategyQueryDTO } from "@/types/scenic-spot-strategy"
import { queryAllScenciSpotStrategyByViewerApi } from "@/api/viewer-api"

const scenicSpotStrategyQueryDTO = reactive<ScenicSpotStrategyQueryDTO>({
  current: 1,
  size: 8,
})

const lastScenicSpotStrategyList = ref<ScenicSpotStrategyListVO[]>([])
const hotScenicSpotStrategyList = ref<ScenicSpotStrategyListVO[]>([])

const router = useRouter()

const viewStrategy = (id: number) => {
  window.open(`/viewer-scenic-spot-strategy-detail?scenicSpotStrategyId=${id}`)
}

const goScenicSpotStrategySearch = () => {
  window.open(`/viewer-scenic-spot-strategy-list`)
}

const fetchLastScenicStrategySpotList = async () => {
  try {
    const { data } = await queryAllScenciSpotStrategyByViewerApi(scenicSpotStrategyQueryDTO)
    lastScenicSpotStrategyList.value = data
  } catch (error: any) {
    throw new Error(`最新景点攻略数据查询异常：${error}`)
  }
}

const fetchHotTopScenicSpotStrategyList = async () => {
  try {
    const scenicSpotStrategyQueryDTOHot = {
      size: 8,
      current: 1,
      hotRule: true
    }
    const { data } = await queryAllScenciSpotStrategyByViewerApi(scenicSpotStrategyQueryDTOHot)
    hotScenicSpotStrategyList.value = data
  } catch (error: any) {
    throw new Error(`最热景点攻略数据查询异常：${error}`)
  }
}

onMounted(async () => {
  await fetchLastScenicStrategySpotList()
  await fetchHotTopScenicSpotStrategyList()
})
</script>

<style lang="scss" scoped>
.strategy-container {
  display: flex;
  flex-direction: column;
  gap: 0;
}
</style>
