package com.kmbeast.pojo.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 景点路线项查询条件DTO类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class ScenicSpotRouteItemQueryDTO extends QueryDTO {
    /**
     * 景点ID
     */
    private Integer scenicSpotId;
}
