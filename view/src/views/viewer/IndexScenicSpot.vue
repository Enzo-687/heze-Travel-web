<template>
  <div class="scenic-spot-container">
    <ScenicSpotItem
      key="hot-scenic-spot"
      @search="goScenicSpotSearch"
      @view-detail="goDetail"
      title="热门推荐"
      subTitle="大家都在看的热门景点"
      badge="HOT"
      :scenic-spot-list="hotScenicSpotList"
    />
    <ScenicSpotItem
      key="last-scenic-spot"
      @search="goScenicSpotSearch"
      @view-detail="goDetail"
      title="最新发现"
      subTitle="新鲜出炉的景点推荐"
      badge="NEW"
      :scrollable="true"
      :scenic-spot-list="lastScenicSpotList"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted } from "vue"
import ScenicSpotItem from "@/components/ScenicSpotItem.vue"
import type { ScenicSpotListVO, ScenicSpotQueryDTO } from "@/types/scenic-spot"
import { queryScenicSpotByViewerApi } from "@/api/viewer-api"

const scenicSpotQueryDTO = reactive<ScenicSpotQueryDTO>({
  current: 1,
  size: 5,
  title: '',
  regionIds: [],
  startTime: null,
  endTime: null
})

const lastScenicSpotList = ref<ScenicSpotListVO[]>([])
const hotScenicSpotList = ref<ScenicSpotListVO[]>([])

let abortController: AbortController | null = null

const goDetail = (id: number) => {
  window.open(`/viewer-scenic-spot-info?scenicSpotId=${id}`)
}

const goScenicSpotSearch = () => {
  window.open(`/viewer-scenic-spot-search-list`)
}

const fetchLastScenicSpotList = async () => {
  abortController = new AbortController()
  try {
    const { data } = await queryScenicSpotByViewerApi(scenicSpotQueryDTO, {
      signal: abortController.signal
    })
    lastScenicSpotList.value = data
  } catch (error: any) {
    if (error?.message?.includes('canceled')) return
    console.error(`最新景点数据查询异常：${error}`)
  }
}

const fetchHotTopScenicSpotList = async () => {
  abortController = new AbortController()
  try {
    const scenicSpotQueryDTOHot = {
      size: 5,
      current: 1,
      hotRule: true
    }
    const { data } = await queryScenicSpotByViewerApi(scenicSpotQueryDTOHot as ScenicSpotQueryDTO, {
      signal: abortController.signal
    })
    hotScenicSpotList.value = data
  } catch (error: any) {
    if (error?.message?.includes('canceled')) return
    console.error(`最热景点数据查询异常：${error}`)
  }
}

onMounted(async () => {
  await fetchLastScenicSpotList()
  await fetchHotTopScenicSpotList()
})

onUnmounted(() => {
  abortController?.abort()
})
</script>

<style lang="scss" scoped>
.scenic-spot-container {
  display: flex;
  flex-direction: column;
  gap: 0;
}
</style>
