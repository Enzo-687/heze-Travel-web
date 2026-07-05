package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.FoodQueryDTO;
import com.kmbeast.pojo.entity.Food;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface FoodMapper extends BaseMapper<Food> {

    List<Food> listPage(FoodQueryDTO foodQueryDTO);

    Integer queryPageCount(FoodQueryDTO foodQueryDTO);
}
