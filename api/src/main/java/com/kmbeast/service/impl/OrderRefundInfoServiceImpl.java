package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.mapper.OrderRefundInfoMapper;
import com.kmbeast.pojo.entity.OrderRefundInfo;
import com.kmbeast.service.OrderRefundInfoService;
import org.springframework.stereotype.Service;

/**
 * 景点门票订单退款申请业务逻辑接口实现类
 */
@Service
public class OrderRefundInfoServiceImpl extends ServiceImpl<OrderRefundInfoMapper, OrderRefundInfo> implements OrderRefundInfoService {

}
