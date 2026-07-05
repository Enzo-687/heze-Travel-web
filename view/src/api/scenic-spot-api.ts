// src/api/scenic-spot-api.ts - 景点API封装文件

import { post, get, del } from "@/utils/request"
import type { ScenicSpotQueryDTO, ScenicSpotSaveDTO, ScenicSpotEditDTO, ApiResponse } from "@/types/scenic-spot"

// 查询景点列表
export const queryScenicSpotApi = (params: ScenicSpotQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot/listPage', params)
}

// 新增景点信息
export const saveScenicSpotApi = (params: ScenicSpotSaveDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot', params)
}

// 查询景点详情信息
export const getDetailApi = (id: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`/scenic-spot/${id}/detail`)
}

// 修改景点信息
export const updateScenicSpotApi = (params: ScenicSpotEditDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('scenic-spot/update', params)
}

// 删除景点信息
export const delScenicSpotApi = (id: number): Promise<ApiResponse> => {
    return del<ApiResponse>(`scenic-spot/${id}`)
}

// 查询用户收藏的景点信息
export const queryUserCollectionApi = (params: ScenicSpotQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>(`scenic-spot/collection`, params)
}

// 查询推荐的景点信息 - 协同过滤算法推荐
export const queryRecommendApi = (count: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`scenic-spot/${count}/recommend`)
}