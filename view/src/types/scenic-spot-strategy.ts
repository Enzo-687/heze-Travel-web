// src/types/scenic-spot-strategy.ts 景点攻略类型定义文件

// 景点攻略基础信息类型
export interface ScenicSpotStrategy {
  id?: number
  scenicSpotId?: number
  userId?: number
  title?: string
  cover?: string
  summary?: string
  content?: string
  auditStatus?: boolean
  createTime?: Date
}

// 景点攻略列表类型
export interface ScenicSpotStrategyListVO {
  id?: number
  title?: string
  cover?: string
  summary?: string
  createTime?: Date
  avatar?: string
  username?: string
  auditStatus?: boolean
}

// 景点攻略详情类型
export interface ScenicSpotStrategyDetailVO extends ScenicSpotStrategy {
  scenicSpotTitle?: string
  avatar?: string
  username?: string
  viewCount: number // 阅读量
  upvoteCount: number // 点赞量
  collectionCount: number // 收藏量
}

// 景点攻略查询参数类型
export interface ScenicSpotStrategyQueryDTO {
  current?: number // 当前页
  size?: number // 页面大小
  scenicSpotId?: number | null // 景点ID
  userId?: number | null // 用户ID
  title?: string | null // 标题
  auditStatus?: boolean | null // 审核状态
  startTime?: string | null // 开始时间
  endTime?: string | null // 结束时间
  hotRule?: boolean | null // 是否启用热度规则
}

// API响应类型
export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
  total?: number
}


