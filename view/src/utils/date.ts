// types/date.ts - 时间工具类
export const timeAgo = (time: string | Date): string => {
  const date = typeof time === 'string' ? new Date(time) : time
  const now = new Date()
  const diffInSeconds = Math.floor((now.getTime() - date.getTime()) / 1000)
  
  if (diffInSeconds < 60) {
    return '刚刚'
  }
  
  const diffInMinutes = Math.floor(diffInSeconds / 60)
  if (diffInMinutes < 60) {
    return `${diffInMinutes}分钟前`
  }
  
  const diffInHours = Math.floor(diffInMinutes / 60)
  if (diffInHours < 24) {
    return `${diffInHours}小时前`
  }
  
  const diffInDays = Math.floor(diffInHours / 24)
  if (diffInDays < 30) {
    return `${diffInDays}天前`
  }
  
  const diffInMonths = Math.floor(diffInDays / 30)
  if (diffInMonths < 12) {
    return `${diffInMonths}个月前`
  }
  
  const diffInYears = Math.floor(diffInMonths / 12)
  return `${diffInYears}年前`
}

/**
 * 处理日期范围选择器的时间格式，适配后端 LocalDateTime 类型
 * @param dateRange Date[] 日期范围数组
 * @returns { start: string, end: string } LocalDateTime 格式的字符串（YYYY-MM-DDTHH:mm:ss）
 */
export const handleDateRange = (dateRange: Date[] | null): { start: string, end: string } | null => {
    if (!dateRange || dateRange.length !== 2) {
        return null;
    }
    
    try {
        // 创建开始日期（设置为当天 00:00:00）
        const startDate = new Date(dateRange[0] as any);
        startDate.setHours(0, 0, 0, 0);
        
        // 创建结束日期（设置为当天 23:59:59）
        const endDate = new Date(dateRange[1] as any);
        endDate.setHours(23, 59, 59, 999);
        
        // 格式化为 LocalDateTime 格式（YYYY-MM-DDTHH:mm:ss）
        const formatLocalDateTime = (date: Date): string => {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');
            const seconds = String(date.getSeconds()).padStart(2, '0');
            
            return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}`;
        };
        
        return {
            start: formatLocalDateTime(startDate),
            end: formatLocalDateTime(endDate)
        };
    } catch (error) {
        console.error('处理日期范围错误:', error);
        return null;
    }
}
