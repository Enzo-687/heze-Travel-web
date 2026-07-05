package com.kmbeast.controller;

import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.vo.ValuesVO;
import com.kmbeast.service.DashboardService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Comparator;
import java.util.List;

/**
 * 仪表盘控制器
 */
@RestController
@RequestMapping(value = "/dashboard")
public class DashboardController {

    @Resource
    private DashboardService dashboardService;

    /**
     * 静态数据统计
     * @return Result<List<ValuesVO>>
     */
    @GetMapping(value = "/staticValues")
    public Result<List<ValuesVO>> staticValues(){
        List<ValuesVO> valuesVOS = dashboardService.staticValues();
        return ApiResult.success(valuesVOS);
    }

    /**
     * 饼状图 - 男女比例
     * @return Result<List<ValuesVO>>
     */
    @GetMapping(value = "/pieValues")
    public Result<List<ValuesVO>> pieValues(){
        List<ValuesVO> valuesVOS = dashboardService.pieValues();
        return ApiResult.success(valuesVOS);
    }

    /**
     * 折线图 - 订单销售额统计
     * @return Result<List<ValuesVO>>
     */
    @GetMapping(value = "/{days}/ordersMoney")
    public Result<List<ValuesVO>> ordersMoney(@PathVariable Integer days){
        List<ValuesVO> valuesVOS = dashboardService.ordersMoney(days);
        valuesVOS.sort(Comparator.comparing(ValuesVO::getName));
        return ApiResult.success(valuesVOS);
    }

    /**
     * 折线图 - 订单退款额统计
     * @return Result<List<ValuesVO>>
     */
    @GetMapping(value = "/{days}/ordersRefundMoney")
    public Result<List<ValuesVO>> ordersRefundMoney(@PathVariable Integer days){
        List<ValuesVO> valuesVOS = dashboardService.ordersRefundMoney(days);
        valuesVOS.sort(Comparator.comparing(ValuesVO::getName));
        return ApiResult.success(valuesVOS);
    }

}
