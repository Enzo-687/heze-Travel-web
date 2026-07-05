package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.context.LocalThreadHolder;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.OrderRejectRefundDTO;
import com.kmbeast.pojo.dto.ScenicSpotTicketOrderQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotTicketOrder;
import com.kmbeast.pojo.vo.ScenicSpotTicketOrderVO;
import com.kmbeast.service.ScenicSpotTicketOrderService;
import com.kmbeast.utils.RoleValidUtils;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 景点门票订单控制器
 */
@RestController
@RequestMapping("/scenic-spot-ticket-order")
public class ScenicSpotTicketOrderController {

    @Resource
    private ScenicSpotTicketOrderService scenicSpotTicketOrderService;

    /**
     * 景点门票订单新增
     * POST /api/v1.0/online-travel-api/scenic-spot-ticket-order
     *
     * @param scenicSpotTicketOrder 景点门票订单实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping
    public Result<Void> addScenicSpotTicketOrder(@RequestBody ScenicSpotTicketOrder scenicSpotTicketOrder) {
        scenicSpotTicketOrderService.addScenicSpotTicketOrder(scenicSpotTicketOrder);
        return ApiResult.success();
    }

    /**
     * 景点门票订单修改
     * POST /api/v1.0/online-travel-api/scenic-spot-ticket-order/update
     *
     * @param scenicSpotTicketOrder 景点门票订单实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping("/update")
    public Result<Void> updateScenicSpotTicketOrder(@RequestBody ScenicSpotTicketOrder scenicSpotTicketOrder) {
        scenicSpotTicketOrderService.updateScenicSpotTicketOrder(scenicSpotTicketOrder);
        return ApiResult.success();
    }

    /**
     * 景点门票订单删除
     * DELETE /api/v1.0/online-travel-api/scenic-spot-ticket-order/{id}
     *
     * @param id 景点门票订单主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delScenicSpotTicketOrder(@PathVariable Integer id) {
        scenicSpotTicketOrderService.delScenicSpotTicketOrder(id);
        return ApiResult.success();
    }

    /**
     * 景点门票订单查询
     * POST /api/v1.0/online-travel-api/scenic-spot-ticket-order/query
     *
     * @param scenicSpotTicketOrderQueryDTO 查询条件类
     * @return Result<List < ScenicSpotTicketOrderVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/query")
    public Result<List<ScenicSpotTicketOrderVO>> queryPage(@RequestBody ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO) {
        RoleValidUtils.requestedAdmin("无操作权限");
        List<ScenicSpotTicketOrderVO> scenicSpotTicketOrderVOS = scenicSpotTicketOrderService.queryPage(scenicSpotTicketOrderQueryDTO);
        Integer count = scenicSpotTicketOrderService.queryPageCount(scenicSpotTicketOrderQueryDTO);
        return ApiResult.success(scenicSpotTicketOrderVOS, count);
    }

    /**
     * 变更订单状态
     * PUT /api/v1.0/online-travel-api/scenic-spot-ticket-order/{id}/status/{methodType}
     *
     * @param id          订单ID
     * @param methodsType 操作
     * @return Result<Void> 后台通用返回封装类
     */
    @PutMapping("/{id}/status/{methodsType}")
    public Result<Void> status(@PathVariable Integer id,
                               @PathVariable String methodsType) {
        scenicSpotTicketOrderService.status(id, methodsType);
        return ApiResult.success();
    }

    /**
     * 订单拒绝退款
     * POST /api/v1.0/online-travel-api/scenic-spot-ticket-order/rejectRefund
     *
     * @param orderRejectRefundDTO 接收参数
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping("/rejectRefund")
    public Result<Void> rejectRefund(@RequestBody OrderRejectRefundDTO orderRejectRefundDTO) {
        scenicSpotTicketOrderService.rejectRefund(orderRejectRefundDTO);
        return ApiResult.success();
    }

    /**
     * 查询用户关联的景点门票订单
     * POST /api/v1.0/online-travel-api/scenic-spot-ticket-order/queryUser
     *
     * @param scenicSpotTicketOrderQueryDTO 查询条件类
     * @return Result<List < ScenicSpotTicketOrderVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/queryUser")
    public Result<List<ScenicSpotTicketOrderVO>> queryUser(@RequestBody ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO) {
        scenicSpotTicketOrderQueryDTO.setUserId(LocalThreadHolder.getUserId());
        List<ScenicSpotTicketOrderVO> scenicSpotTicketOrderVOS = scenicSpotTicketOrderService.queryPage(scenicSpotTicketOrderQueryDTO);
        Integer count = scenicSpotTicketOrderService.queryPageCount(scenicSpotTicketOrderQueryDTO);
        return ApiResult.success(scenicSpotTicketOrderVOS, count);
    }

}