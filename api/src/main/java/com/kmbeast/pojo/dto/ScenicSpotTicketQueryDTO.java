package com.kmbeast.pojo.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 景点门票查询条件类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class ScenicSpotTicketQueryDTO extends QueryDTO{
    /**
     * 景点ID
     */
    private Integer scenicSpotId;
    /**
     * 最小价格查询参数
     */
    private BigDecimal minPrice;
    /**
     * 最大价格查询参数
     */
    private BigDecimal maxPrice;
    /**
     * 状态
     */
    private Integer status;
}
