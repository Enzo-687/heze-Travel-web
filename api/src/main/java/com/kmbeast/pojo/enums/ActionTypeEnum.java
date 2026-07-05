package com.kmbeast.pojo.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 用户行为类型枚举类
 * 行为类型（1-收藏；2-点赞；3-浏览；4-停留）
 */
@Getter
@AllArgsConstructor
public enum ActionTypeEnum {

    TYPE_1(1, "收藏"),
    TYPE_2(2, "点赞"),
    TYPE_3(3, "浏览"),
    TYPE_4(4, "停留");

    private final Integer type; // 类型
    private final String detail; // 描述
}
