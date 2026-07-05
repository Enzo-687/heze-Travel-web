package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.CarouselQueryDTO;
import com.kmbeast.pojo.entity.Carousel;
import com.kmbeast.service.CarouselService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 轮播图控制器
 */
@RestController
@RequestMapping("/carousel")
public class CarouselController {

    @Resource
    private CarouselService carouselService;

    /**
     * 轮播图新增
     * POST /api/v1.0/online-travel-api/carousel
     *
     * @param carousel 轮播图实体
     * @return Result<Category> 后台通用返回封装类
     */
    @PostMapping
    public Result<Void> addCarousel(@RequestBody Carousel carousel) {
        carouselService.addCarousel(carousel);
        return ApiResult.success();
    }

    /**
     * 轮播图修改
     * POST /api/v1.0/online-travel-api/carousel/update
     *
     * @param carousel 轮播图实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping("/update")
    public Result<Void> updateCarousel(@RequestBody Carousel carousel) {
        carouselService.updateCarousel(carousel);
        return ApiResult.success();
    }

    /**
     * 轮播图删除
     * DELETE /api/v1.0/online-travel-api/carousel/{id}
     *
     * @param id 轮播图主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delCarousel(@PathVariable Integer id) {
        carouselService.delCarousel(id);
        return ApiResult.success();
    }

    /**
     * 轮播图查询
     * POST /api/v1.0/online-travel-api/carousel/query
     *
     * @param carouselQueryDTO 查询条件类
     * @return Result<List < Carousel>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/query")
    public Result<List<Carousel>> queryPage(@RequestBody CarouselQueryDTO carouselQueryDTO) {
        List<Carousel> carouselList = carouselService.queryPage(carouselQueryDTO);
        Integer count = carouselService.queryPageCount(carouselQueryDTO);
        return ApiResult.success(carouselList,count);
    }

}