package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.ScenicSpotTicketQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotTicket;
import com.kmbeast.service.ScenicSpotTicketService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 景点门票控制器
 */
@RestController
@RequestMapping("/scenic-spot-ticket")
public class ScenicSpotTicketController {

    @Resource
    private ScenicSpotTicketService scenicSpotTicketService;

    /**
     * 景点门票新增
     * POST /api/v1.0/online-travel-api/scenic-spot-ticket
     *
     * @param scenicSpotTicket 景点门票实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping
    public Result<Void> addScenicSpotTicket(@RequestBody ScenicSpotTicket scenicSpotTicket) {
        scenicSpotTicketService.addScenicSpotTicket(scenicSpotTicket);
        return ApiResult.success();
    }

    /**
     * 景点门票修改
     * POST /api/v1.0/online-travel-api/scenic-spot-ticket/update
     *
     * @param scenicSpotTicket 景点门票实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping("/update")
    public Result<Void> updateScenicSpotTicket(@RequestBody ScenicSpotTicket scenicSpotTicket) {
        scenicSpotTicketService.updateScenicSpotTicket(scenicSpotTicket);
        return ApiResult.success();
    }

    /**
     * 景点门票删除
     * DELETE /api/v1.0/online-travel-api/scenic-spot-ticket/{id}
     *
     * @param id 景点门票主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delScenicSpotTicket(@PathVariable Integer id) {
        scenicSpotTicketService.delScenicSpotTicket(id);
        return ApiResult.success();
    }

    /**
     * 景点门票查询
     * POST /api/v1.0/online-travel-api/scenic-spot-ticket/query
     *
     * @param scenicSpotTicketQueryDTO 查询条件类
     * @return Result<List < ScenicSpotTicket>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/query")
    public Result<List<ScenicSpotTicket>> queryPage(@RequestBody ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO) {
        List<ScenicSpotTicket> scenicSpotTickets = scenicSpotTicketService.queryPage(scenicSpotTicketQueryDTO);
        Integer count = scenicSpotTicketService.queryPageCount(scenicSpotTicketQueryDTO);
        return ApiResult.success(scenicSpotTickets, count);
    }

}