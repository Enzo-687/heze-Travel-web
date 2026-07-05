// src/types/carousel-ts 轮播图类型定义文件

// 轮播图类型定义
export interface Carousel {
    id: number
    scenicSpotId: number
    coverUrl: string
    title: string,
    recommendDetail: string,
    scenicSpotTitle: '',
    createTime?: Date
}

// 轮播图查询参数
export interface CarouselQueryDto {
    current?: number // 当前页
    size?: number // 页面大小
    scenicSpotId?: number | null
    title: string | null
}

// API响应类型
export interface ApiResponse<T = any> {
    code: number
    message: string
    data: T
    total?: number
}