// src/types/scenic-spot-route-nodes-ts 景点路线项节点类型定义文件

// 景点路线项节点类型定义
export interface ScenicSpotRouteNodes {
    id?: number | null
    scenicSpotRouteId: number | null
    type: string
    times: string,
    focusDesc: string | null,
    orderNumber: number
}

// API响应类型
export interface ApiResponse<T = any> {
    code: number
    message: string
    data: T
    total?: number
}