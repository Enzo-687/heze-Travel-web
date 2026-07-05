package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.dto.FoodQueryDTO;
import com.kmbeast.pojo.entity.Food;

import java.util.List;

public interface FoodService extends IService<Food> {

    void addFood(Food food);

    void updateFood(Food food);

    void delFood(Integer id);

    List<Food> queryPage(FoodQueryDTO foodQueryDTO);

    Integer queryPageCount(FoodQueryDTO foodQueryDTO);

    Food getDetail(Integer id);
}
