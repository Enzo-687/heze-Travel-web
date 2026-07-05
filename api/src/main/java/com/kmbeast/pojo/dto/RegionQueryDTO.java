package com.kmbeast.pojo.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 地区查询条件类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class RegionQueryDTO extends QueryDTO{

    /**
     * 地区名称
     */
    private String name;

    /**
     * 层级
     */
    private Integer level;

    /**
     * 父级ID
     */
    private Integer parentId;

}