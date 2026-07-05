// src/api/scenic-spot-ticket-order-api.ts 景点门票订单API封装文件

import { post, del, put } from "@/utils/request"
import type { ScenicSpotTicketOrder, OrderRejectRefundDTO,ScenicSpotTicketOrderQueryDTO, ApiResponse } from "@/types/scenic-spot-ticket-order"

// 创建景点门票订单
export const addScenicSpotTicketOrdersApi = (params: ScenicSpotTicketOrder): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-ticket-order', params)
}

// 查询订单列表
export const queryScenicSpotTicketOrdersApi = (params: ScenicSpotTicketOrderQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-ticket-order/query', params)
}


// 查询用户名下的订单列表
export const queryUserScenicSpotTicketOrdersApi = (params: ScenicSpotTicketOrderQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-ticket-order/queryUser', params)
}

// 订单状态变更
export const updateOrderStatusApi = (id: number, methodType: string): Promise<ApiResponse> => {
    return put<ApiResponse>(`/scenic-spot-ticket-order/${id}/status/${methodType}`)
}

// 订单拒绝退款
export const orderRejectRefundApi = (params: OrderRejectRefundDTO): Promise<ApiResponse> => {
    return post<ApiResponse>(`/scenic-spot-ticket-order/rejectRefund`,params)
}


