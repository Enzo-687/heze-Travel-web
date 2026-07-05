// src/types/region.ts
// 地区类型定义
export interface Region {
    id?: number | null
    name?: string
    level?: number
    parentId?: number,
    hasChildren?: boolean,
    children?: Region[]
}

// 地区查询参数
export interface RegionQueryDTO {
    current?: number // 当前页
    size?: number // 页面大小
    name?: string | null
    level?: number | null
    parentId?: number | null
}

// API响应类型
export interface ApiResponse<T = any> {
    code: number
    message: string
    data: T
    total?: number
}

// 地区列表响应
export interface RegionList extends ApiResponse<Region[]> {
    total: number
}