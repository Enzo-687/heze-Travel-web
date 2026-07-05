// src/types/scenic-spot.ts 景点类型定义文件
import type { ScenicSpotBrochure } from "@/types/scenic-spot-brochure"

// 景点基础信息
export interface ScenicSpot {
  id: number
  regionId: number
  title: string
  cover: string
  content: string
  summary: string
  createTime?: Date | null
}

// 景点列表VO基础信息
export interface ScenicSpotListVO {
  id: number
  title: string
  cover: string
  summary: string
  countyName: string
  townName: string
  villageName: string
  categoryNames: string
}

// 景点查询参数类型
export interface ScenicSpotQueryDTO {
  current?: number
  size?: number
  title?: string | null
  regionIds?: number[]
  regionId?: number | null
  startTime?: string | null
  endTime?: string | null
  hotRule?: boolean | null
  categoryKey?: string | null
}

// 景点新增参数类型
export interface ScenicSpotSaveDTO extends ScenicSpot {
  scenicSpotBrochureList: ScenicSpotBrochure[]
  categoryIds: number[]
}

// 景点修改参数类型
export interface ScenicSpotEditDTO extends ScenicSpot {
  scenicSpotBrochureList: ScenicSpotBrochure[]
  categoryIds: number[]
  scenicSpotCategoryList: []
}

// 景点详情VO
export interface ScenicSpotVO extends ScenicSpot {
  countyName: string
  townName: string
  villageName: string
  brochureList: ScenicSpotBrochure[]
  viewCount: number // 阅读量
  upvoteCount: number // 点赞量
  collectionCount: number // 收藏量
}

// API响应类型
export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
  total?: number
}