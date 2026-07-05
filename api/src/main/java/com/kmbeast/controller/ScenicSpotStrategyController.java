package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.ScenicSpotStrategyQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotStrategy;
import com.kmbeast.pojo.vo.ScenicSpotStrategyDetailVO;
import com.kmbeast.pojo.vo.ScenicSpotStrategyListVO;
import com.kmbeast.service.ScenicSpotStrategyService;
import jakarta.annotation.Resource;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 景点攻略控制器
 */
@RestController
@RequestMapping("/scenic-spot-strategy")
public class ScenicSpotStrategyController {

    @Resource
    private ScenicSpotStrategyService scenicSpotStrategyService;

    /**
     * 景点攻略新增
     * POST /api/v1.0/online-travel-api/scenic-spot-strategy
     *
     * @param scenicSpotStrategy 景点攻略实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping
    public Result<Void> addScenicSpotStrategy(@RequestBody ScenicSpotStrategy scenicSpotStrategy) {
        scenicSpotStrategyService.addScenicSpotStrategy(scenicSpotStrategy);
        return ApiResult.success();
    }

    /**
     * 景点攻略修改
     * POST /api/v1.0/online-travel-api/scenic-spot-strategy/update
     *
     * @param scenicSpotStrategy 景点攻略实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping("/update")
    public Result<Void> updateScenicSpotStrategy(@RequestBody ScenicSpotStrategy scenicSpotStrategy) {
        scenicSpotStrategyService.updateScenicSpotStrategy(scenicSpotStrategy);
        return ApiResult.success();
    }

    /**
     * 景点攻略删除
     * DELETE /api/v1.0/online-travel-api/scenic-spot-strategy/{id}
     *
     * @param id 景点攻略主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delScenicSpotStrategy(@PathVariable Integer id) {
        scenicSpotStrategyService.delScenicSpotStrategy(id);
        return ApiResult.success();
    }

    /**
     * 通过景点攻略ID查询详情信息
     * POST /api/v1.0/online-travel-api/scenic-spot-strategy/query
     *
     * @param id 主键ID
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @GetMapping("/{id}/detail")
    public Result<ScenicSpotStrategyDetailVO> detail(@PathVariable Integer id) {
        ScenicSpotStrategyDetailVO scenicSpotStrategyDetailVO = scenicSpotStrategyService.detail(id);
        return ApiResult.success(scenicSpotStrategyDetailVO);
    }

    /**
     * 景点攻略查询
     * POST /api/v1.0/online-travel-api/scenic-spot-strategy/queryList
     *
     * @param scenicSpotStrategyQueryDTO 查询条件类
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/queryList")
    public Result<List<ScenicSpotStrategyListVO>> queryList(@RequestBody ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO) {
        List<ScenicSpotStrategyListVO> scenicSpotStrategyListVOS = scenicSpotStrategyService.queryList(scenicSpotStrategyQueryDTO);
        Integer count = scenicSpotStrategyService.queryListCount(scenicSpotStrategyQueryDTO);
        return ApiResult.success(scenicSpotStrategyListVOS, count);
    }

    /**
     * 景点攻略审核
     * POST /api/v1.0/online-travel-api/scenic-spot-strategy/changeAuditStatus
     *
     * @param id 景点攻略主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @PutMapping("/changeAuditStatus/{id}/{status}")
    public Result<Void> changeAuditStatus(@PathVariable Integer id,
                                          @PathVariable Boolean status) {
        scenicSpotStrategyService.auditChange(id, status);
        return ApiResult.success();
    }

    /**
     * 用户查询自己发布的景点攻略
     * POST /api/v1.0/online-travel-api/scenic-spot-strategy/queryUserList
     *
     * @param scenicSpotStrategyQueryDTO 查询条件类
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/queryUserList")
    public Result<List<ScenicSpotStrategyListVO>> queryUserList(@RequestBody ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO) {
        List<ScenicSpotStrategyListVO> scenicSpotStrategyListVOS = scenicSpotStrategyService.queryUserList(scenicSpotStrategyQueryDTO);
        Integer count = scenicSpotStrategyService.queryListCount(scenicSpotStrategyQueryDTO);
        return ApiResult.success(scenicSpotStrategyListVOS, count);
    }

    /**
     * 查询用户收藏的景点攻略信息
     * POST /api/v1.0/online-travel-api/scenic-spot-strategy/collection
     *
     * @param scenicSpotStrategyQueryDTO 景点主键ID
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/collection")
    public Result<List<ScenicSpotStrategyListVO>> collection(@RequestBody ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO) {
        List<ScenicSpotStrategyListVO> scenicSpotStrategyListVOS = scenicSpotStrategyService.collection(scenicSpotStrategyQueryDTO);
        if (CollectionUtils.isEmpty(scenicSpotStrategyListVOS)) {
            return ApiResult.success(scenicSpotStrategyListVOS, 0);
        }
        Integer count = scenicSpotStrategyService.queryListCount(scenicSpotStrategyQueryDTO);
        return ApiResult.success(scenicSpotStrategyListVOS, count);
    }

    /**
     * 查询景点关联的全部景点攻略
     * GET /api/v1.0/online-travel-api/scenic-spot-strategy/{scenicSpotId}/all
     *
     * @param scenicSpotId 景点ID
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @GetMapping("/{scenicSpotId}/all")
    public Result<List<ScenicSpotStrategyListVO>> collection(@PathVariable Integer scenicSpotId) {
        List<ScenicSpotStrategyListVO> scenicSpotStrategyListVOS = scenicSpotStrategyService.all(scenicSpotId);
        return ApiResult.success(scenicSpotStrategyListVOS);
    }

    /**
     * 景点攻略推荐 - 协同过滤算法
     * POST /api/v1.0/online-travel-api/scenic-spot-strategy/{count}/recommend
     *
     * @param count 推荐条数
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @Pager
    @GetMapping("/{count}/recommend")
    public Result<List<ScenicSpotStrategyListVO>> recommend(@PathVariable Integer count) {
        List<ScenicSpotStrategyListVO> scenicSpotStrategyListVOS = scenicSpotStrategyService.recommend(count);
        return ApiResult.success(scenicSpotStrategyListVOS);
    }

}