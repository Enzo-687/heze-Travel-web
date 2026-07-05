package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.ScenicSpotBrochureQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotBrochure;
import com.kmbeast.service.ScenicSpotBrochureService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 景点图册控制器
 */
@RestController
@RequestMapping("/scenic-spot-brochure")
public class ScenicSpotBrochureController {

    @Resource
    private ScenicSpotBrochureService scenicSpotBrochureService;

    /**
     * 景点图册新增
     * POST /api/v1.0/travel-platform-api/scenic-spot-brochure
     *
     * @param scenicSpotBrochureList 景点图册实体集合
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping
    public Result<Void> addScenicSpotBrochure(@RequestBody List<ScenicSpotBrochure> scenicSpotBrochureList) {
        scenicSpotBrochureService.addScenicSpotBrochure(scenicSpotBrochureList);
        return ApiResult.success();
    }

    /**
     * 景点图册修改
     * POST /api/v1.0/travel-platform-api/scenic-spot-brochure/update
     *
     * @param scenicSpotBrochure 景点图册实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping("/update")
    public Result<Void> updateScenicSpotBrochure(@RequestBody ScenicSpotBrochure scenicSpotBrochure) {
        scenicSpotBrochureService.updateScenicSpotBrochure(scenicSpotBrochure);
        return ApiResult.success();
    }

    /**
     * 景点图册删除
     * DELETE /api/v1.0/travel-platform-api/scenic-spot-brochure/{id}
     *
     * @param id 景点图册主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delScenicSpotBrochure(@PathVariable Integer id) {
        scenicSpotBrochureService.delScenicSpotBrochure(id);
        return ApiResult.success();
    }

    /**
     * 景点图册查询
     * POST /api/v1.0/travel-platform-api/scenic-spot-brochure/query
     *
     * @param queryDTO 查询条件类
     * @return Result<List < ScenicSpotBrochure>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/pageList")
    public Result<List<ScenicSpotBrochure>> pageList(@RequestBody ScenicSpotBrochureQueryDTO queryDTO) {
        List<ScenicSpotBrochure> scenicSpotBrochures = scenicSpotBrochureService.pageList(queryDTO);
        Integer count = scenicSpotBrochureService.pageListCount(queryDTO);
        return ApiResult.success(scenicSpotBrochures, count);
    }

}
