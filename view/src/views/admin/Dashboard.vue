<template>
  <div class="container">
    <div class="top-container">
      <div class="static-value-container">
        <div class="item-value" v-for="(item, index) in staticValueList" :key="`static-value-${index}`">
          <div class="value">{{ item.value }}</div>
          <div class="name">{{ getDisplayName(item.name) }}</div>
        </div>
      </div>
      <div class="pie-container">
        <EchartsPie :data="pieValueList" title="男女比例" height="300px" />
      </div>
      <div class="right-container">
        <div class="pointer">
          <div class="text">
            用户发布的攻略
          </div>
          <div class="more" @click="seeMore">
            查看更多
          </div>
        </div>
        <div v-if="!scenicSpotStrategyList.length">
          <el-empty description="暂无景点攻略"></el-empty>
        </div>
        <div class="item-strategy" v-for="strategy in scenicSpotStrategyList" :key="`${strategy.id}-${strategy.title}`">
          <div class="pic-container">
            <img class="cover" :src="strategy.cover" alt="" srcset="">
            <div class="status" :style="{ backgroundColor: !strategy.auditStatus ? 'rgb(229, 62, 49)' : '' }">
              <el-icon v-if="strategy.auditStatus">
                <circle-check />
              </el-icon>

              <el-icon v-else>
                <circle-close />
              </el-icon>

              {{ strategy.auditStatus ? '已审核' : '未审核' }}
            </div>
          </div>
          <div style="min-width: 200px;">
            <div class="title">{{ strategy.title }}</div>
            <div class="info">
              <div style="display: flex;justify-content: left;gap: 4px;align-items: center;">
                <img class="avatar" :src="strategy.avatar" alt="" srcset="">
                <div class="username">{{ strategy.username }}</div>
              </div>
              <div class="detail" @click="goDetail(strategy.id as any)">
                查看详情
              </div>
            </div>
            <div>
              发布于{{ strategy.createTime }}
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- 订单销售额 - 折线图 -->
    <div>
      <div style="margin-block: 20px;display: flex;justify-content: center;">
        <Tab key="order-linechart-tab" :buttons="[
          { label: '10年内', value: '3650' },
          { label: '1年内', value: '365' },
          { label: '3个月内', value: '90' }
        ]" :initialActive="'3650'" @change="handleChange" />
      </div>
      <div>
        <EchartsLine key="order-linechart" :data="yDatas" :xAxisData="xDatas" seriesName="订单销售情况"
          :tooltipFormatter="customFormatter" />
      </div>
    </div>
    <!-- 订单退款额 - 折线图 -->
    <div style="margin-top: 20px;">
      <div style="margin-block: 20px;display: flex;justify-content: center;">
        <Tab key="refund-linechart-tab" :buttons="[
          { label: '10年内', value: '3650' },
          { label: '1年内', value: '365' },
          { label: '3个月内', value: '90' }
        ]" :initialActive="'3650'" @change="handleRefundChange" />
      </div>
      <div>
        <EchartsLine key="refund-linechart" :data="yRefundDatas" :xAxisData="xRefundDatas" seriesName="订单退款情况"
          :tooltipFormatter="customRefundFormatter" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ElMessage } from "element-plus"
import { ref, onMounted, reactive } from "vue"
import EchartsPie from '@/components/EchartsPie.vue'
import EchartsLine from '@/components/EchartsLine.vue'
import Tab from "@/components/Tab.vue"
import { useRouter } from "vue-router"
import type { ValuesVO } from "@/types/dashboard-main"
import type { ScenicSpotStrategyListVO, ScenicSpotStrategyQueryDTO } from "@/types/scenic-spot-strategy"
import {
  staticValuesApi,
  pieValuesApi,
  ordersMoneyApi,
  ordersRefundMoneyApi
} from "@/api/dashboard-api"
import {
  queryAllScenciSpotStrategyApi
} from "@/api/scenic-spot-strategy-api"


// 响应式数据
const staticValueList = ref<ValuesVO[]>([])
const pieValueList = ref<ValuesVO[]>([])
const scenicSpotStrategyList = ref<ScenicSpotStrategyListVO[]>([])
const scenicSpotStrategyQueryDTO = reactive<ScenicSpotStrategyQueryDTO>({
  current: 1,
  size: 3
})
const days = ref(3650) // 订单销售额查询天数 - 数据较少，查10年
const refundOrdersQueryDays = ref(3650) // 订单退款额查询天数 - 数据较少，查10年
const xDatas = ref<string[]>([])
const yDatas = ref<string[]>([])

const xRefundDatas = ref<string[]>([])
const yRefundDatas = ref<string[]>([])

const router = useRouter()

// 定义映射关系
const nameMap = new Map([
  ['users', '用户数'],
  ['scenic_spots', '景点数'],
  ['strategies', '攻略数'],
  ['tickets', '门票数'],
  ['ticket_orders', '门票订单'],
  ['routes', '景点路线']
]);

// 父组件自定义 formatter 函数
const customFormatter = (params: any) => {
  const date = params[0].axisValue
  const value = params[0].value
  // 自定义格式：10月20日，销售3200元
  return `${date}，销售${value}元`
}

const customRefundFormatter = (params: any) => {
  const date = params[0].axisValue
  const value = params[0].value
  // 自定义格式：10月20日，销售3200元
  return `${date}，退款${value}元`
}

const getDisplayName = (name: string) => {
  return nameMap.get(name) || name;
}

// 跳转详情页
const goDetail = (id: number) => {
  router.push(`/admin/scenic-spot-strategy-detail-admin?scenicSpotStrategyId=${id}`);
}

const seeMore = () => {
  router.push('/admin/scenic-spot-strategy-manage');
}

// 查询静态数据
const fetchStaticValues = async () => {
  try {
    const { data } = await staticValuesApi();
    staticValueList.value = data
  } catch (error) {
    console.log("仪表盘查询静态数据异常：", error);
  }
}

// 查男女比例
const fetchPieValues = async () => {
  try {
    const { data } = await pieValuesApi();
    pieValueList.value = data
  } catch (error) {
    console.log("仪表盘查询男女比例异常：", error);
  }
}

const handleChange = async (obj: { value: string }) => {
  days.value = Number(obj.value)
  await fetchOrdersMoney()
}


const handleRefundChange = async (obj: { value: string }) => {
  refundOrdersQueryDays.value = Number(obj.value)
  await fetchOrdersRefundMoney()
}

// 查景点忽略
const fetchScenciSpotStrategyApi = async () => {
  try {
    const { data } = await queryAllScenciSpotStrategyApi(scenicSpotStrategyQueryDTO);
    scenicSpotStrategyList.value = data
  } catch (error) {
    console.log("仪表盘查询景点攻略异常：", error);
  }
}

// 查询指定时间内订单销售额
const fetchOrdersMoney = async () => {
  try {
    const { data } = await ordersMoneyApi(days.value)
    if (!data.length) {
      ElMessage.info('该时间期限之内，无订单销售数据')
      return
    }
    xDatas.value = data.map((data: ValuesVO) => data.name)
    yDatas.value = data.map((data: ValuesVO) => data.value)
  } catch (error) {
    console.log("查询指定时间内订单销售额异常：", error);
  }
}

// 查询指定时间内订单退款额
const fetchOrdersRefundMoney = async () => {
  try {
    const { data } = await ordersRefundMoneyApi(days.value)
    if (!data.length) {
      ElMessage.info('该时间期限之内，无订单退款数据')
      return
    }
    xRefundDatas.value = data.map((data: ValuesVO) => data.name)
    yRefundDatas.value = data.map((data: ValuesVO) => data.value)
  } catch (error) {
    console.log("查询指定时间内订单退款额异常：", error);
  }
}

onMounted(async () => {
  await fetchStaticValues()
  await fetchPieValues()
  await fetchScenciSpotStrategyApi()
  await fetchOrdersMoney()
  await fetchOrdersRefundMoney()
})

</script>

<style scoped lang="scss">
.pointer {
  display: flex;
  padding: 0 10px;
  justify-content: space-between;
  align-items: self-end;

  .text {
    font-size: 22px;
  }

  .more {
    font-size: 14px;
    cursor: pointer;
    color: rgb(105, 128, 239);

    &:hover {
      text-decoration: underline;
    }
  }
}

.pic-container {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.status {
  position: absolute;
  top: 4px;
  right: 4px;
  display: flex;
  justify-content: left;
  align-items: center;
  gap: 2px;

  background-color: rgb(121, 107, 241);
  color: rgb(255, 255, 255);
  font-size: 10px;
  padding: 1px 6px;
  border-radius: 10px;
}

.item-strategy {
  display: flex;
  justify-content: left;
  align-items: center;
  padding: 10px;
  box-sizing: border-box;
  gap: 6px;

  .cover {
    width: 120px;
    height: 70px;
    border-radius: 10px;
  }

  .title {
    max-width: 200px;
    font-size: 20px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  .info {
    display: flex;
    justify-content: space-between;
    gap: 4px;
    align-items: center;

    .detail {
      background-color: rgb(35, 167, 242);
      border-radius: 10px;
      font-size: 12px;
      padding: 2px 6px;
      cursor: pointer;
      color: rgb(255, 255, 255);

      &:hover {
        background-color: rgb(51, 155, 216);
      }
    }

    .avatar {
      width: 20px;
      aspect-ratio: 1;
      border-radius: 50%;
    }


    .username {
      max-width: 100px;
      font-size: 14px;
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
    }
  }
}



.top-container {
  display: flex;
  justify-content: space-evenly;
  gap: 30px;
}

.pie-container {
  display: flex;
  justify-content: cebter;
  align-items: center;
  width: 33%;
}

.right-container {
  padding: 10px;
  box-sizing: border-box;
  width: 33%;
  box-shadow: 0 6px 12px rgb(240, 240, 240);
  border-radius: 12px;
}

.static-value-container {
  box-shadow: 0 6px 12px rgb(240, 240, 240);
  border-radius: 12px;
  padding: 10px;
  box-sizing: border-box;
  width: 33%;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;

  .item-value {
    width: calc(50% - 5px);
    background-color: rgb(242, 242, 242);
    padding: 10px;
    border-radius: 6px;
    box-sizing: border-box;

    .value,
    .name {
      text-align: center;
    }

    .value {
      font-size: 28px;
      font-weight: 600;
      color: rgb(51, 51, 51);
    }

    .name {
      font-size: 18px;
      color: rgb(31, 31, 31);
    }
  }
}
</style>