// src/api/scenic-spot-strategy-api.ts 景点攻略API封装文件

import { post, get, del,put } from "@/utils/request"
import type {
    ScenicSpotStrategyListVO,
    ScenicSpotStrategy,
    ScenicSpotStrategyDetailVO,
    ApiResponse,
    ScenicSpotStrategyQueryDTO
} from "@/types/scenic-spot-strategy.ts"

// 新增景点攻略
export const addScenciSpotStrategyApi = (params: ScenicSpotStrategy): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-strategy', params)
}

// 查询用户发布的景点攻略列表
export const queryScenciSpotStrategyApi = (params: ScenicSpotStrategyQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-strategy/queryUserList', params)
}

// 查询景点攻略列表
export const queryAllScenciSpotStrategyApi = (params: ScenicSpotStrategyQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('/scenic-spot-strategy/queryList', params)
}

// 审核景点攻略
export const changeAuditStatusApi = (id: number, status: boolean): Promise<ApiResponse> => {
    return put<ApiResponse>(`scenic-spot-strategy/changeAuditStatus/${id}/${status}`)
}

// 查询景点攻略详情
export const queryScenciSpotStrategyDetailApi = (id: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`/scenic-spot-strategy/${id}/detail`)
}

// 修改景点攻略信息
export const updateScenciSpotStrategyApi = (params: ScenicSpotStrategy): Promise<ApiResponse> => {
    return post<ApiResponse>(`/scenic-spot-strategy/update`, params)
}

// 删除景点攻略信息
export const delScenciSpotStrategyApi = (id: number): Promise<ApiResponse> => {
    return del<ApiResponse>(`/scenic-spot-strategy/${id}`)
}

// 查询用户收藏的景点攻略信息
export const queryUserCollectionApi = (params: ScenicSpotStrategyQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>(`scenic-spot-strategy/collection`, params)
}

// 查询景点关联的景点攻略信息
export const queryStrategyByScenicSpotIdApi = (scenicSpotId: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`scenic-spot-strategy/${scenicSpotId}/all`)
}

// 查询推荐的景点攻略信息 - 协同过滤算法
export const queryRecomendStrategyApi = (count: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`scenic-spot-strategy/${count}/recommend`)
}