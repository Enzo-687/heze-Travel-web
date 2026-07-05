package com.kmbeast.pojo.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 轮播图查询条件类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class CarouselQueryDTO extends QueryDTO {
    /**
     * 景点ID
     */
    private Integer scenicSpotId;
    /**
     * 标题
     */
    private String title;
}
