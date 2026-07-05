// src/api/viewer-api.ts 游客API封装文件

import { post, get } from "@/utils/request"
import type { CarouselQueryDto, ApiResponse } from "@/types/carousel"
import type { ScenicSpotRouteItemQueryDTO } from "@/types/scenic-spot-route-item"
import type { ScenicSpotTicketQueryDTO } from "@/types/scenic-spot-ticket"
import type { ScenicSpotStrategyQueryDTO } from "@/types/scenic-spot-strategy"
import type { ScenicSpotQueryDTO } from "@/types/scenic-spot"
import type { RegionQueryDTO,RegionList } from  "@/types/region"

// 轮播图查询
export const queryViewerCarouselApi = (params: CarouselQueryDto): Promise<ApiResponse> => {
    return post<ApiResponse>('viewer/carousel/query', params)
}

// 查询景点详情信息
export const getScenicSpotDetailByViewerApi = (id: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`viewer/scenic-spot/${id}/detail`)
}

// 查询景点路线项
export const queryScenicSpotRouteItemByViewerApi = (params: ScenicSpotRouteItemQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('viewer/scenic-spot-route-item/query', params)
}

/**
 * 通过景点路线项主键ID查询景点路线详情
 * @param id 主键 
 * @returns 
 */
export const getScenicSpotRouteItemDetailByViewerApi = (id: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`viewer/scenic-spot-route-item/${id}/detail`)
}

/**
 * 查询景点路线项节点
 * @param id 景点路线ID
 * @returns  
 */
export const queryScenicSpotRouteNodesByViewerApi = (id: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`viewer/scenic-spot-route-nodes/${id}/list`)
}

// 查询景点关联的景点攻略信息
export const queryStrategyByScenicSpotIdByViewerApi = (scenicSpotId: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`viewer/scenic-spot-strategy/${scenicSpotId}/all`)
}

// 查询景点攻略详情
export const queryScenciSpotStrategyDetailByViewerApi = (id: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`viewer/scenic-spot-strategy/${id}/detail`)
}

// 景点门票查询
export const queryScenicSpotTicketByViewerApi = (params: ScenicSpotTicketQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('viewer/scenic-spot-ticket/query', params)
}

// 查询指定模块下的评论列表
export const queryCommentListByViewerApi = (contentId: number, contentType: string): Promise<ApiResponse> => {
    return get<ApiResponse>(`viewer/comment/list/${contentId}/${contentType}`)
}

// 查询景点攻略列表
export const queryAllScenciSpotStrategyByViewerApi = (params: ScenicSpotStrategyQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('viewer/scenic-spot-strategy/queryList', params)
}

// 查询景点列表
export const queryScenicSpotByViewerApi = (params: ScenicSpotQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('viewer/scenic-spot/listPage', params)
}

// 查询地区列表
export const queryRegionListByViewerApi = (params: RegionQueryDTO): Promise<RegionList> => {
    return post<RegionList>('viewer/region/pageList', params)
}

// 通过景点ID查询其关联的类别列表
export const queryCategoryListByScenicSpotIdByViewerApi = (scenicSpotId: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`viewer/category/${scenicSpotId}/query`)
}
