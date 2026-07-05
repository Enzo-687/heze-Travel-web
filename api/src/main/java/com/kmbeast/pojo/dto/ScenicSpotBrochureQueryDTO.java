package com.kmbeast.pojo.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 景点图册查询条件类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class ScenicSpotBrochureQueryDTO extends QueryDTO {
    private Integer scenicSpotId; // 景点ID
}
