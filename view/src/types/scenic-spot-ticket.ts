// src/types/scenic-spot-ticket.ts 景点门票类型定义文件

// 景点门票类型定义
export interface ScenicSpotTicket {
    id: number | null
    scenicId: number | null
    title: string
    totalNumber: number | null
    price: number | null
    discountDesc: string
    purchaseDesc: string
    detail: string
    startDate: Date | null
    endDate: Date | null
    status: number | null
    createTime?: Date | null
    switchStatus?: boolean
}

// 景点门票查询参数类型
export interface ScenicSpotTicketQueryDTO {
    current?: number // 当前页
    size?: number // 页面大小
    scenicSpotId?: number | null // 景点ID
    minPrice?: string | null // 最小查询价格参数
    maxPrice?: string | null // 最大查价格参数
    status?: number | null // 状态
}

// API响应类型
export interface ApiResponse<T = any> {
    code: number
    message: string
    data: T
    total?: number
}