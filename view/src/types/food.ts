export interface Food {
  id: number
  name: string
  coverUrl: string
  description: string
  tag: string
  detail: string
  longitude: number | null
  latitude: number | null
  address: string
  createTime?: string | null
}

export interface FoodQueryDTO {
  current?: number
  size?: number
  name?: string | null
  tag?: string | null
}

export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
  total?: number
}
