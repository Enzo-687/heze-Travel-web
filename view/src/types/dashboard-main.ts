// src/types/dashboard-ts 仪表盘相关类型定义文件

// 轮播图类型定义
export interface ValuesVO {
    name: string
    value: any
}

// API响应类型
export interface ApiResponse<T = any> {
    code: number
    message: string
    data: T
    total?: number
}