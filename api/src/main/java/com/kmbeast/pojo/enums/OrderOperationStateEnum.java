package com.kmbeast.pojo.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 订单行为类型枚举类
 */
@Getter
@AllArgsConstructor
public enum OrderOperationStateEnum {

    // 支付行为
    PAY("pay"),
    // 退款行为
    REFUND("refund"),
    // 取消订单行为
    CANCEL("cancel"),
    // 删除订单行为
    REMOVE("remove"),
    // 核验订单行为
    USE("use"),
    // 同意订单退款行为
    AGREE("agree");

    private final String description;
}
