package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.ScenicSpotQueryDTO;
import com.kmbeast.pojo.dto.ScenicSpotSaveDTO;
import com.kmbeast.pojo.dto.ScenicSpotUpdateDTO;
import com.kmbeast.pojo.vo.ScenicSpotListVO;
import com.kmbeast.pojo.vo.ScenicSpotVO;
import com.kmbeast.service.ScenicSpotService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 景点控制器
 */
@RestController
@RequestMapping("/scenic-spot")
public class ScenicSpotController {

    @Autowired
    private ScenicSpotService scenicSpotService;

    /**
     * 景点新增
     * POST /api/v1.0/online-travel-api/scenic-spot
     *
     * @param scenicSpotSaveDTO 景点新增实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping
    public Result<Void> addScenicSpot(@RequestBody ScenicSpotSaveDTO scenicSpotSaveDTO) {
        scenicSpotService.addScenicSpot(scenicSpotSaveDTO);
        return ApiResult.success();
    }

    /**
     * 景点修改
     * POST /api/v1.0/online-travel-api/scenic-spot/update
     *
     * @param scenicSpotUpdateDTO 景点修改DTO
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping("/update")
    public Result<Void> updateScenicSpot(@RequestBody ScenicSpotUpdateDTO scenicSpotUpdateDTO) {
        scenicSpotService.updateScenicSpot(scenicSpotUpdateDTO);
        return ApiResult.success();
    }

    /**
     * 景点删除
     * DELETE /api/v1.0/online-travel-api/scenic-spot/{id}
     *
     * @param id 景点主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delScenicSpot(@PathVariable Integer id) {
        scenicSpotService.delScenicSpot(id);
        return ApiResult.success();
    }

    /**
     * 查询景点列表
     * POST /api/v1.0/online-travel-api/scenic-spot/listPage
     *
     * @param scenicSpotQueryDTO 查询条件类
     * @return Result<List < ScenicSpotListVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/listPage")
    public Result<List<ScenicSpotListVO>> listPage(@RequestBody ScenicSpotQueryDTO scenicSpotQueryDTO) {
        List<ScenicSpotListVO> scenicSpotListVOS = scenicSpotService.listPage(scenicSpotQueryDTO);
        Integer count = scenicSpotService.listPageCount(scenicSpotQueryDTO);
        return ApiResult.success(scenicSpotListVOS, count);
    }

    /**
     * 通过ID查询景点详情
     * GET /api/v1.0/online-travel-api/scenic-spot/{id}/detail
     *
     * @param id 景点主键ID
     * @return Result<ScenicSpotVO> 后台通用返回封装类
     */
    @GetMapping("/{id}/detail")
    public Result<ScenicSpotVO> detail(@PathVariable Integer id) {
        ScenicSpotVO scenicSpotVO = scenicSpotService.detail(id);
        return ApiResult.success(scenicSpotVO);
    }

    /**
     * 查询用户收藏的景点信息
     * POST /api/v1.0/online-travel-api/scenic-spot/collection
     *
     * @param scenicSpotQueryDTO 景点主键ID
     * @return Result<List < ScenicSpotListVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/collection")
    public Result<List<ScenicSpotListVO>> collection(@RequestBody ScenicSpotQueryDTO scenicSpotQueryDTO) {
        List<ScenicSpotListVO> scenicSpotListVOS = scenicSpotService.collection(scenicSpotQueryDTO);
        if (CollectionUtils.isEmpty(scenicSpotListVOS)) {
            return ApiResult.success(scenicSpotListVOS, 0);
        }
        Integer count = scenicSpotService.listPageCount(scenicSpotQueryDTO);
        return ApiResult.success(scenicSpotListVOS, count);
    }

    /**
     * 景点推荐（协同过滤算法）
     * GET /api/v1.0/online-travel-api/scenic-spot/{count}/recommend
     *
     * @param count 推荐的条数
     * @return Result<List < ScenicSpotListVO>> 后台通用返回封装类
     */
    @GetMapping("/{count}/recommend")
    public Result<List<ScenicSpotListVO>> recommend(@PathVariable Integer count) {
        List<ScenicSpotListVO> scenicSpotListVOS = scenicSpotService.recommend(count);
        return ApiResult.success(scenicSpotListVOS);
    }


}