// src/api/carousel-api.ts 轮播图API封装文件

import { post,del } from "@/utils/request"
import type {Carousel, CarouselQueryDto, ApiResponse } from "@/types/carousel"

// 轮播图新增
export const addCarouselApi = (params: Carousel): Promise<ApiResponse> => {
    return post<ApiResponse>('/carousel', params)
}

// 轮播图修改
export const updateCarouselApi = (params: Carousel): Promise<ApiResponse> => {
    return post<ApiResponse>('/carousel/update', params)
}

// 轮播图删除
export const delCarouselApi = (id: number): Promise<ApiResponse> => {
    return del<ApiResponse>(`/carousel/${id}`)
}

// 轮播图查询
export const queryCarouselApi = (params: CarouselQueryDto): Promise<ApiResponse> => {
    return post<ApiResponse>('/carousel/query', params)
}
