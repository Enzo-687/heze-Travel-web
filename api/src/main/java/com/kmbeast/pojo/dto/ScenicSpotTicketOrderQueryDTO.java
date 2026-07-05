package com.kmbeast.pojo.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.util.List;

/**
 * 景点门票订单查询条件类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class ScenicSpotTicketOrderQueryDTO extends QueryDTO {

    /**
     * 用户ID
     */
    private Integer userId;

    /**
     * 景点门票ID
     */
    private Integer scenicSpotTicketId;

    /**
     * 订单状态（1-待付款；2-已核销；3-待使用；4-已取消）
     */
    private Integer status;

    /**
     * 订单状态集合
     */
    private List<Integer> statusList;

    /**
     * 退款状态
     */
    private Integer refundStatus;

    /**
     * 订单最小查询价格
     */
    private BigDecimal minPrice;

    /**
     * 订单最大查询价格
     */
    private BigDecimal maxPrice;

}
