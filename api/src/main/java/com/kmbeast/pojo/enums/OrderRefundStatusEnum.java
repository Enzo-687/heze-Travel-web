package com.kmbeast.pojo.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 订单退款状态枚举类
 */
@Getter
@AllArgsConstructor
public enum OrderRefundStatusEnum {

    REFUNDING(1, "退款中"),
    REFUNDED(2, "已退款"),
    REJECT_REFUND(3, "拒绝退款");

    private final Integer status; // 状态
    private final String detail; // 描述
}
