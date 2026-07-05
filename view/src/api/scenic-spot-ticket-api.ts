// src/api/scenic-spot-ticket-api.ts 景点门票API封装文件

import { post,del } from "@/utils/request"
import type {ScenicSpotTicket, ScenicSpotTicketQueryDTO, ApiResponse } from "@/types/scenic-spot-ticket"

// 景点门票新增
export const addScenicSpotTicketApi = (params: ScenicSpotTicket): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-ticket', params)
}

// 景点门票修改
export const updateScenicSpotTicketApi = (params: ScenicSpotTicket): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-ticket/update', params)
}

// 景点门票删除
export const delScenicSpotTicketApi = (id: number): Promise<ApiResponse> => {
    return del<ApiResponse>(`/scenic-spot-ticket/${id}`)
}

// 景点门票查询
export const queryScenicSpotTicketApi = (params: ScenicSpotTicketQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-ticket/query', params)
}
