package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.RegionQueryDTO;
import com.kmbeast.pojo.entity.Region;
import com.kmbeast.pojo.vo.RegionVO;
import com.kmbeast.service.RegionService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 地区控制器
 */
@RestController
@RequestMapping("/region")
public class RegionController {

    @Resource
    private RegionService regionService;

    /**
     * 地区新增
     * POST /api/v1.0/travel-platform-api/region
     *
     * @param region 地区实体
     * @return Result<Category> 后台通用返回封装类
     */
    @PostMapping
    public Result<Region> addRegion(@RequestBody Region region) {
        Region regionSaveDTO = regionService.addRegion(region);
        return ApiResult.success(regionSaveDTO);
    }

    /**
     * 地区修改
     * POST /api/v1.0/travel-platform-api/region/update
     *
     * @param region 地区实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping("/update")
    public Result<Void> updateRegion(@RequestBody Region region) {
        regionService.updateRegion(region);
        return ApiResult.success();
    }

    /**
     * 地区删除
     * DELETE /api/v1.0/travel-platform-api/region/{id}
     *
     * @param id 地区主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delRegion(@PathVariable Integer id) {
        regionService.delRegion(id);
        return ApiResult.success();
    }

    /**
     * 地区查询
     * POST /api/v1.0/travel-platform-api/region/query
     *
     * @param regionQueryDTO 查询条件类
     * @return Result<List < RegionVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/pageList")
    public Result<List<RegionVO>> pageList(@RequestBody RegionQueryDTO regionQueryDTO) {
        List<RegionVO> regionVOS = regionService.pageList(regionQueryDTO);
        Integer count = regionService.pageListCount(regionQueryDTO);
        return ApiResult.success(regionVOS, count);
    }

}
