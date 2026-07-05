package com.kmbeast.pojo.dto;

import lombok.*;

/**
 * 用户行为操作查询条件类
 */
@EqualsAndHashCode(callSuper = true)
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserActionOperationQueryDTO extends QueryDTO {

    /**
     * 用户ID，外键关联用户信息表
     */
    private Integer userId;

    /**
     * 内容模块（如"景点攻略、景点门票、景点信息"等）
     */
    private String contentModule;

    /**
     * 内容ID（关联对应模块的主键ID，如攻略ID/门票ID/景点ID）
     */
    private Integer contentId;

    /**
     * 行为类型（1-收藏；2-点赞；3-浏览；4-停留）
     * 注释：行为类型（1-收藏；2-点赞；3-浏览；4-停留）
     */
    private Integer type;


}
