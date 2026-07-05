// src/api/dashboard-api.ts 仪表盘API封装文件

import {  get } from "@/utils/request"
import type { ApiResponse } from "@/types/dashboard-main"

// 统计静态数据
export const staticValuesApi = (): Promise<ApiResponse> => {
    return get<ApiResponse>('/dashboard/staticValues')
}

// 饼状图 - 统计男女比例
export const pieValuesApi = (): Promise<ApiResponse> => {
    return get<ApiResponse>('/dashboard/pieValues')
}

// 折线图 - 统计指定时间内订单销售额
export const ordersMoneyApi = (days: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`/dashboard/${days}/ordersMoney`)
}

// 折线图 - 统计指定时间内订单退款额
export const ordersRefundMoneyApi = (days: number): Promise<ApiResponse> => {
    return get<ApiResponse>(`/dashboard/${days}/ordersRefundMoney`)
}