// src/api/scenic-spot-route-item-api.ts 景点路线项API封装文件

import { post, get,del } from "@/utils/request"
import type { ScenicSpotRouteItem, ScenicSpotRouteItemQueryDTO, ApiResponse } from "@/types/scenic-spot-route-item"

// 景点路线项新增
export const addScenicSpotRouteItemApi = (params: ScenicSpotRouteItem): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-route-item', params)
}

// 景点路线项修改
export const updateScenicSpotRouteItemApi = (params: ScenicSpotRouteItem): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-route-item/update', params)
}

// 景点路线项删除
export const deleteScenicSpotRouteItemApi = (id: number): Promise<ApiResponse> => {
    return del<ApiResponse>(`/scenic-spot-route-item/${id}`)
}

// 查询景点路线项
export const queryScenicSpotRouteItemApi = (params: ScenicSpotRouteItemQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-route-item/query', params)
}


/**
 * 通过景点路线项主键ID查询详情
 * @param id 主键 
 * @returns 
 */
export const getScenicSpotRouteItemDetailApi = (id: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`/scenic-spot-route-item/${id}/detail`)
}