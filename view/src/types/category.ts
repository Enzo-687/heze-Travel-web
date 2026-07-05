// src/types/category
// 类别类型定义
export interface Category {
    id?: number
    name: string
    level: number
    parentId: number,
    hasChildren?: boolean,
    children?: Category[]
}

// 类别查询参数
export interface CategoryQueryDto {
    current?: number // 当前页
    size?: number // 页面大小
    name?: string | null
    level?: number | null
    parentId?: number
}

// API响应类型
export interface ApiResponse<T = any> {
    code: number
    message: string
    data: T
    total?: number
}

// 类别列表响应
export interface CategoryList extends ApiResponse<Category[]> {
    total: number
}