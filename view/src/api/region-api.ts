// src/api/region.api.ts
// 地区API封装文件
import { post,del } from "@/utils/request"
import type { Region, RegionQueryDTO, ApiResponse, RegionList } from "@/types/region"

// 查询地区列表
export const queryListApi = (params: RegionQueryDTO): Promise<RegionList> => {
    return post<RegionList>('/region/pageList', params)
}

// 新增地区
export const addRegionApi = (params: Region): Promise<ApiResponse> => {
    return post<ApiResponse>('/region', params)
}

// 修改地区
export const updateRegionApi = (params: Region): Promise<ApiResponse> => {
    return post<ApiResponse>('/region/update', params)
}

// 删除地区
export const delRegionApi = (id: number): Promise<ApiResponse> => {
    return del<ApiResponse>(`/region/${id}`)
}