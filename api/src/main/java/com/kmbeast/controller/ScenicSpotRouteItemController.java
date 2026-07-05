package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.ScenicSpotRouteItemQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotRouteItem;
import com.kmbeast.service.ScenicSpotRouteItemService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 景点路线项控制器
 */
@RestController
@RequestMapping("/scenic-spot-route-item")
public class ScenicSpotRouteItemController {

    @Resource
    private ScenicSpotRouteItemService scenicSpotRouteItemService;

    /**
     * 景点路线项新增
     * POST /api/v1.0/online-travel-api/scenic-spot-route-item
     *
     * @param scenicSpotRouteItem 景点路线项实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping
    public Result<Void> addScenicSpotRouteItem(@RequestBody ScenicSpotRouteItem scenicSpotRouteItem) {
        scenicSpotRouteItemService.addScenicSpotRouteItem(scenicSpotRouteItem);
        return ApiResult.success();
    }

    /**
     * 景点路线项修改
     * POST /api/v1.0/online-travel-api/scenic-spot-route-item/update
     *
     * @param scenicSpotRouteItem 景点路线项实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping("/update")
    public Result<Void> updateScenicSpotRouteItem(@RequestBody ScenicSpotRouteItem scenicSpotRouteItem) {
        scenicSpotRouteItemService.updateScenicSpotRouteItem(scenicSpotRouteItem);
        return ApiResult.success();
    }

    /**
     * 景点路线项删除
     * DELETE /api/v1.0/online-travel-api/scenic-spot-route-item/{id}
     *
     * @param id 景点路线项主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delScenicSpotRouteItem(@PathVariable Integer id) {
        scenicSpotRouteItemService.delScenicSpotRouteItem(id);
        return ApiResult.success();
    }

    /**
     * 景点路线项查询
     * POST /api/v1.0/online-travel-api/scenic-spot-route-item/{id}/detail
     *
     * @param id 景点路线项主键ID
     * @return Result<List < ScenicSpotRouteItem>> 后台通用返回封装类
     */
    @GetMapping("/{id}/detail")
    public Result<ScenicSpotRouteItem> detail(@PathVariable Integer id) {
        ScenicSpotRouteItem scenicSpotRouteItem = scenicSpotRouteItemService.detail(id);
        return ApiResult.success(scenicSpotRouteItem);
    }

    /**
     * 景点路线项查询
     * POST /api/v1.0/online-travel-api/scenic-spot-route-item/query
     *
     * @param scenicSpotRouteItemQueryDTO 查询条件类
     * @return Result<List < ScenicSpotRouteItem>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/query")
    public Result<List<ScenicSpotRouteItem>> queryPage(@RequestBody ScenicSpotRouteItemQueryDTO scenicSpotRouteItemQueryDTO) {
        List<ScenicSpotRouteItem> carouselList = scenicSpotRouteItemService.queryPage(scenicSpotRouteItemQueryDTO);
        return ApiResult.success(carouselList);
    }

}