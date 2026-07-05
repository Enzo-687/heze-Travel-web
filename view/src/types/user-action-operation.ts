// src/types/user-action-operation-ts 用户行为操作类型定义文件

// 用户行为操作类型定义
export interface UserActionOperation {
    id?: number
    userId?: number
    contentModule: string
    contentId: number
    type?: number
    stayTime?: number
    createTime?: Date
}

// 用户行为操作查询参数
export interface UserActionOperationQueryDTO {
    current?: number // 当前页
    size?: number // 页面大小
    contentModule: string // 内容模块
    contentId: number // 内容ID
    type: number // 行为类型
}

// API响应类型
export interface ApiResponse<T = any> {
    code: number
    message: string
    data: T
    total?: number
}