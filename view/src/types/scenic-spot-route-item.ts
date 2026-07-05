// src/types/scenic-spot-route-item-ts 景点路线项类型定义文件

// 景点路线项类型定义
export interface ScenicSpotRouteItem {
    id?: number | null
    scenicSpotId: number | null
    positionDesc: string
    times: string,
    intensity: number | null,
    focusDesc: string
}

// 景点路线项查询参数
export interface ScenicSpotRouteItemQueryDTO {
    current?: number // 当前页
    size?: number // 页面大小
    scenicSpotId?: number | null
}

// API响应类型
export interface ApiResponse<T = any> {
    code: number
    message: string
    data: T
    total?: number
}