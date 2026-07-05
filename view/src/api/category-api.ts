import { post,del,get } from "@/utils/request"
import type { Category, CategoryQueryDto, ApiResponse, CategoryList } from "@/types/category"

// 查询类别列表
export const queryCategory = (params: CategoryQueryDto): Promise<CategoryList> => {
    return post<CategoryList>('/category/query', params)
}

// 新增类别
export const addCategory = (params: Category): Promise<ApiResponse> => {
    return post<ApiResponse>('/category', params)
}

// 修改类别
export const updateCategory = (params: Category): Promise<ApiResponse> => {
    return post<ApiResponse>('/category/update', params)
}

// 删除类别
export const delCategory = (id: number): Promise<ApiResponse> => {
    return del<ApiResponse>(`/category/${id}`)
}

// 通过景点ID查询其关联的类别列表
export const queryCategoryListByScenicSpotIdApi = (scenicSpotId: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`/category/${scenicSpotId}/query`)
}