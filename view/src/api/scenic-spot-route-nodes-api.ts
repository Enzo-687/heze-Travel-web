// src/api/scenic-spot-route-nodes-api.ts 景点路线项节点API封装文件

import { post, get,del } from "@/utils/request"
import type { ScenicSpotRouteNodes, ApiResponse } from "@/types/scenic-spot-route-nodes"

// 景点路线项节点新增
export const addScenicSpotRouteNotesApi = (params: ScenicSpotRouteNodes): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-route-nodes', params)
}

/**
 * 景点路线项节点修改
 * @param id 景点路线ID
 * @returns  
 */
export const updateScenicSpotRouteNodesApi = (params: ScenicSpotRouteNodes): Promise<ApiResponse> => {
    return post<ApiResponse>(`/scenic-spot-route-nodes/update`,params)
}

/**
 * 景点路线项节点删除
 * @param id 景点路线ID
 * @returns  
 */
export const delScenicSpotRouteNodesApi = (id: number): Promise<ApiResponse> => {
    return del<ApiResponse>(`/scenic-spot-route-nodes/${id}`)
}

/**
 * 查询景点路线项节点
 * @param id 景点路线ID
 * @returns  
 */
export const queryScenicSpotRouteNodesApi = (id: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`/scenic-spot-route-nodes/${id}/list`)
}