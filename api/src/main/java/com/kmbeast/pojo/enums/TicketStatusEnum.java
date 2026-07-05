package com.kmbeast.pojo.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 门票状态枚举类
 */
@Getter
@AllArgsConstructor
public enum TicketStatusEnum {

    STOP(1, "暂停预约"),
    NORMAL(2, "正常");

    private final Integer status; // 状态
    private final String detail; // 描述
}
