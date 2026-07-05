import { post, get, del } from '@/utils/request'
import type { FoodQueryDTO, ApiResponse } from '@/types/food'

export const queryFoodApi = (params: FoodQueryDTO): Promise<ApiResponse> => {
  return post<ApiResponse>('/food/query', params)
}

export const getFoodDetailApi = (id: number): Promise<ApiResponse> => {
  return get<ApiResponse>(`/food/${id}/detail`)
}

export const saveFoodApi = (data: any): Promise<ApiResponse> => {
  return post<ApiResponse>('/food', data)
}

export const updateFoodApi = (data: any): Promise<ApiResponse> => {
  return post<ApiResponse>('/food/update', data)
}

export const delFoodApi = (id: number): Promise<ApiResponse> => {
  return del<ApiResponse>(`/food/${id}`)
}
