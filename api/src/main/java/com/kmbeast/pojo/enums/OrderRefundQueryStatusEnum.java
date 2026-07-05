package com.kmbeast.pojo.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 订单退款状态状态枚举类
 */
@Getter
@AllArgsConstructor
public enum OrderRefundQueryStatusEnum {

    REFUNDING(5, "退款中"),
    REFUNDED(6, "已退款"),
    REJECT_REFUND(7, "拒绝退款");

    private final Integer status; // 状态
    private final String detail; // 描述
}
