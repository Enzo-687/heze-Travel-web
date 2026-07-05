package com.kmbeast.pojo.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 门票订单状态枚举类
 */
@Getter
@AllArgsConstructor
public enum TicketOrderStatusEnum {

    AWAITING_PAYMENT(1, "待付款"),
    VERIFIED(2, "已核销"),
    AWAITING_USE(3, "待使用"),
    CANCEL(4, "已取消");

    private final Integer status; // 状态
    private final String detail; // 描述
}
