package com.kmbeast.pojo.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

/**
 * 景点信息查询条件类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class ScenicSpotQueryDTO extends QueryDTO{

    /**
     * 地区ID
     */
    private List<Integer> regionIds;
    private Integer regionId;
    /**
     * 标题
     */
    private String title;
    /**
     * 是否按热度排序
     */
    private Boolean hotRule;
    /**
     * 类别查询模糊词
     */
    private String categoryKey;

}
