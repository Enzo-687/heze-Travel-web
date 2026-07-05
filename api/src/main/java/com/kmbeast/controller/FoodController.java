package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.FoodQueryDTO;
import com.kmbeast.pojo.entity.Food;
import com.kmbeast.service.FoodService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/food")
public class FoodController {

    @Resource
    private FoodService foodService;

    @PostMapping
    public Result<Void> addFood(@RequestBody Food food) {
        foodService.addFood(food);
        return ApiResult.success();
    }

    @PostMapping("/update")
    public Result<Void> updateFood(@RequestBody Food food) {
        foodService.updateFood(food);
        return ApiResult.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delFood(@PathVariable Integer id) {
        foodService.delFood(id);
        return ApiResult.success();
    }

    @Pager
    @PostMapping("/query")
    public Result<List<Food>> queryPage(@RequestBody FoodQueryDTO foodQueryDTO) {
        List<Food> foodList = foodService.queryPage(foodQueryDTO);
        Integer count = foodService.queryPageCount(foodQueryDTO);
        return ApiResult.success(foodList, count);
    }

    @GetMapping("/{id}/detail")
    public Result<Food> getDetail(@PathVariable Integer id) {
        Food food = foodService.getDetail(id);
        return ApiResult.success(food);
    }
}
