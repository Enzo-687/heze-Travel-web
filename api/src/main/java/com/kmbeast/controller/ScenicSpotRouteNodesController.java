package com.kmbeast.controller;

import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.entity.ScenicSpotRouteNodes;
import com.kmbeast.service.ScenicSpotRouteNodesService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 景点路线项节点控制器
 */
@RestController
@RequestMapping("/scenic-spot-route-nodes")
public class ScenicSpotRouteNodesController {

    @Resource
    private ScenicSpotRouteNodesService scenicSpotRouteNodesService;

    /**
     * 景点路线项节点新增
     * POST /api/v1.0/online-travel-api/scenic-spot-route-nodes
     *
     * @param scenicSpotRouteNodes 景点路线项节点实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping
    public Result<Void> addScenicSpotRouteNotes(@RequestBody ScenicSpotRouteNodes scenicSpotRouteNodes) {
        scenicSpotRouteNodesService.addScenicSpotRouteNotes(scenicSpotRouteNodes);
        return ApiResult.success();
    }

    /**
     * 景点路线项节点修改
     * POST /api/v1.0/online-travel-api/scenic-spot-route-nodes/update
     *
     * @param scenicSpotRouteNodes 景点路线项节点实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping("/update")
    public Result<Void> updateScenicSpotRouteNotes(@RequestBody ScenicSpotRouteNodes scenicSpotRouteNodes) {
        scenicSpotRouteNodesService.updateScenicSpotRouteNotes(scenicSpotRouteNodes);
        return ApiResult.success();
    }

    /**
     * 景点路线项节点删除
     * DELETE /api/v1.0/online-travel-api/scenic-spot-route-nodes/{id}
     *
     * @param id 景点路线项节点主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delScenicSpotRouteNotes(@PathVariable Integer id) {
        scenicSpotRouteNodesService.delScenicSpotRouteNotes(id);
        return ApiResult.success();
    }

    /**
     * 景点路线项节点查询
     * POST /api/v1.0/online-travel-api/scenic-spot-route-nodes/query
     *
     * @param id 景点路线项ID
     * @return Result<List < ScenicSpotRouteNodes>> 后台通用返回封装类
     */
    @GetMapping("/{id}/list")
    public Result<List<ScenicSpotRouteNodes>> queryPage(@PathVariable Integer id) {
        List<ScenicSpotRouteNodes> scenicSpotRouteNodes = scenicSpotRouteNodesService.nodes(id);
        return ApiResult.success(scenicSpotRouteNodes);
    }

}