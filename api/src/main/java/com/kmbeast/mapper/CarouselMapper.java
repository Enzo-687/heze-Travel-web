package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.CarouselQueryDTO;
import com.kmbeast.pojo.entity.Carousel;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 轮播图持久化接口
 */
@Mapper
public interface CarouselMapper extends BaseMapper<Carousel> {

    List<Carousel> listPage(CarouselQueryDTO carouselQueryDTO);

    Integer queryPageCount(CarouselQueryDTO carouselQueryDTO);

}
