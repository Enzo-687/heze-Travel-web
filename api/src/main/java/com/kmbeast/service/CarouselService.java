package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.dto.CarouselQueryDTO;
import com.kmbeast.pojo.entity.Carousel;

import java.util.List;

/**
 * 轮播图业务逻辑接口
 */
public interface CarouselService extends IService<Carousel> {

    void addCarousel(Carousel carousel);

    void updateCarousel(Carousel carousel);

    void delCarousel(Integer id);

    List<Carousel> queryPage(CarouselQueryDTO carouselQueryDTO);

    Integer queryPageCount(CarouselQueryDTO carouselQueryDTO);


}
