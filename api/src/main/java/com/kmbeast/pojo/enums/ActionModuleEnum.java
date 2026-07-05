package com.kmbeast.pojo.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 内容模块枚举类
 */
@Getter
@AllArgsConstructor
public enum ActionModuleEnum {

    SCENIC_SPOT("SCENIC_SPOT"),
    SCENIC_SPOT_STRATEGY("SCENIC_SPOT_STRATEGY");

    private final String module; // 模块
}
