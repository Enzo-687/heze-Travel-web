// src/api/user-action-operation.ts 用户行为操作API封装文件

import { post,del } from "@/utils/request"
import type {UserActionOperation,UserActionOperationQueryDTO, ApiResponse } from "@/types/user-action-operation"

// 新增用户行为操作
export const saveOperationApi = (params: UserActionOperation): Promise<ApiResponse> => {
    return post<ApiResponse>('/user-action-operation', params)
}

// 查询用户行为操作
export const queryApi = (params: UserActionOperationQueryDTO): Promise<ApiResponse> => {
    return post<ApiResponse>('/user-action-operation/query', params)
}

// 收藏或取消收藏
export const collectionApi = (params: UserActionOperation): Promise<ApiResponse> => {
    return post<ApiResponse>('/user-action-operation/collection', params)
}

// 点赞与取消点赞
export const upvoteApi = (params: UserActionOperation): Promise<ApiResponse> => {
    return post<ApiResponse>('/user-action-operation/upvote', params)
}