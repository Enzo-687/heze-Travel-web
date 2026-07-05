package com.kmbeast.pojo.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 景点攻略查询条件类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class ScenicSpotStrategyQueryDTO extends QueryDTO {

    /**
     * 景点ID，外键关联景点信息表
     */
    private Integer scenicSpotId;

    /**
     * 用户ID，外键关联用户信息表
     */
    private Integer userId;

    /**
     * 攻略标题
     */
    private String title;

    /**
     * 审核状态（0=未审核/1=审核通过）
     */
    private Boolean auditStatus;

    /**
     * 热度排序规则 - true：启用
     */
    private Boolean hotRule;

}
