// src/types/scenic-spot-ticket-order.ts 景点门票订单类型定义文件

// 景点门票订单类型定义
export interface ScenicSpotTicketOrder {
    id: number | null
    userId: number | null
    scenicSpotTicketId: number | null
    status: number | null
    buyNumber: number | null
    price: number | null
    concatUsername: string | null
    concatPhone: string | null
    idcard: string | null
    createTime: Date | null
    payTime: Date | null
    useTime: Date | null
    cancelTime: Date | null
    orderRefundInfoList: OrderRefundInfo[]
}

// 景点门票订单VO类型定义
export interface ScenicSpotTicketOrderVO extends ScenicSpotTicketOrder {
    username: string | null // 用户名
    current: number // 当前页
    size: number // 页面大小
    avatar: string | null // 用户头像
    detail: string | null // 备注
    readonly startDate: Date | null // 门票有效期开始日期
    readonly endDate: Date | null // 门票有效期结束日期
}

export interface OrderRejectRefundDTO{
    ticketOrderId: number
    rejectReason: string
}

export interface OrderRefundInfo {
    id?: number | null
    ticketOrderId?: number | null
    status?: number | null
    rejectReason?: string | null
    refundTime?: Date | null
    rejectRefundTime?: Date | null
    createTime?: Date | null
}

// 景点门票订单查询参数
export interface ScenicSpotTicketOrderQueryDTO {
    current?: number // 当前页
    size?: number // 页面大小
    userId?: number | null // 用户ID
    scenicSpotTicketId?: number | null // 景点门票ID
    status?: number | null // 状态
    minPrice?: number | null // 最小查询价格
    maxPrice?: number | null // 最大查询价格
    startTime?: Date | string | null // 开始时间
    endTime?: Date | string | null // 结束时间
}

// API响应类型
export interface ApiResponse<T = any> {
    code: number
    message: string
    data: T
    total?: number
}