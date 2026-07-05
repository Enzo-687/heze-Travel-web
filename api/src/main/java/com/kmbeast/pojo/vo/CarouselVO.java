package com.kmbeast.pojo.vo;

import com.kmbeast.pojo.entity.Carousel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 轮播图VO类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class CarouselVO extends Carousel {
    private String scenicSpotTitle;
}
