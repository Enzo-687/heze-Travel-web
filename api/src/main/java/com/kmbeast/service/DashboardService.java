package com.kmbeast.service;

import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.vo.ValuesVO;

import java.util.List;

/**
 * 仪表盘业务逻辑接口
 */
public interface DashboardService {

    List<ValuesVO>  staticValues();

    List<ValuesVO> pieValues();

    List<ValuesVO> ordersMoney(Integer days);

    List<ValuesVO> ordersRefundMoney(Integer days);

}
